(define-module (config systems herb)
  #:use-module (ice-9 textual-ports)
  #:use-module (config systems images nanopi-r2s)
  #:use-module (config utils secrets)
  #:use-module (gnu)
  #:use-module (gnu image)
  #:use-module (gnu system image)
  #:use-module (guix platforms arm)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system linux-module)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages monitoring)
  #:use-module (gnu packages books)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages scheme)
  #:use-module ((gnu packages admin)      #:prefix admin:)
  #:use-module ((gnu packages dns)        #:prefix dns:)
  #:use-module ((gnu packages networking) #:prefix net:)
  #:use-module ((gnu packages vim)        #:prefix vim:)
  #:use-module ((rosenthal packages networking) #:prefix net:)
  #:use-module ((rosenthal packages web)  #:prefix web:)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services linux)
  #:use-module (gnu services ssh)
  #:use-module (gnu services admin)
  #:use-module (gnu services avahi)
  #:use-module (gnu services sysctl)
  #:use-module (gnu services networking)
  #:use-module (gnu services dns)
  #:use-module (gnu services monitoring)
  #:use-module (rosenthal packages networking)
  #:use-module (rosenthal services networking)
  #:use-module (rosenthal services web)
  #:export (%herb herb-raw-image))

;; gnu/system/image.scm
(define root-partition
  (partition
    (size        'guess)
    (label       "ROOT")
    (file-system "ext4")
    ;; Disable the metadata_csum and 64bit features of ext4, for compatibility
    ;; with U-Boot.
    (file-system-options (list "-O" "^metadata_csum,^64bit"))
    (flags       '(boot))
    (initializer (gexp initialize-root-partition))))

(define root-file-system
  (file-system
    (device      (file-system-label "ROOT"))
    (mount-point "/")
    (type        "ext4")
    (flags       '(no-atime))
    (options     "commit=60")))

;; WPA passphrase for the wlan0 AP, kept out of version control.
(define %herb-wpa-passphrase
  (read-secret "secrets/herb.wpa"))

(define %link-name-rule
  (udev-rule
    "10-link-name.rules"
    (string-append
      "ACTION==\"add\", SUBSYSTEM==\"net\", ATTR{address}==\"6e:c9:82:b9:b4:e8\", NAME=\"wan\", "
      "RUN+=\"/bin/sh -c 'echo f > /sys/class/net/wan/queues/rx-0/rps_cpus && echo 32768 > /sys/class/net/wan/queues/rx-0/rps_flow_cnt'\"\n"
      "ACTION==\"add\", SUBSYSTEM==\"net\", ATTR{address}==\"6e:c9:82:b9:b4:e9\", NAME=\"lan\", "
      "RUN+=\"/bin/sh -c 'echo f > /sys/class/net/lan/queues/rx-0/rps_cpus && echo 32768 > /sys/class/net/lan/queues/rx-0/rps_flow_cnt'\"")))

;;; AICSemi AIC8800D80 USB Wi-Fi 6 adapter (a69c:8d80, e.g. AX900-class).
;;;
;;; Driver tree: <https://github.com/shenmintao/aic8800d80> (vendor code).
;;; Flow on the R2S: the stick enumerates as a fake USB mass-storage
;;; device ("AIC flash", a69c:572x); the udev rule below ejects it, the
;;; stick re-enumerates as a69c:8d80, aic_load_fw uploads the firmware
;;; from /lib/firmware/aic8800D80, and aic8800_fdrv provides the netdev.

;; Branch "main" serves adapters reporting chip_mcu_id=0.  If dmesg shows
;; "chip_mcu_id = 1" (firmware upload times out at 0x170400, see upstream
;; issues #58/#65), switch to branch "legacy-mcu1": change the commit and
;; refresh the hash with `guix download <url>`.
(define %aic8800-commit "2895da26d8fe35bcec7483705d44c02c39e018fe")
(define %aic8800-version "6.4.3.0")

(define aic8800-source
  (origin
    (method url-fetch)
    (uri (string-append
          "https://codeload.github.com/shenmintao/aic8800d80/tar.gz/"
          %aic8800-commit))
    (file-name (string-append "aic8800d80-" %aic8800-version ".tar.gz"))
    (sha256
     (base32 "1msh1l2d0sixb9smvyhyzra2lhgi3v53b1g7pvnibp1v2qrzhzvp"))
    (modules '((guix build utils)))
    (snippet
     ;; a69c:8d80 is missing from the aic8800_fdrv USB ID table; map it to
     ;; the D81 chipid so Wi-Fi-only sticks probe (upstream issue #79).
     #~(begin
         (use-modules (guix build utils))
         (substitute* "drivers/aic8800/aic8800_fdrv/aicwf_usb.h"
           (("#define USB_PRODUCT_ID_AIC8800M80_CUS0  0x8D84")
            (string-append "#define USB_PRODUCT_ID_AIC8800M80_BASE  0x8D80\n"
                           "#define USB_PRODUCT_ID_AIC8800M80_CUS0  0x8D84")))
         (substitute* "drivers/aic8800/aic8800_fdrv/aicwf_usb.c"
           (("\\|\\| pid == USB_PRODUCT_ID_AIC8800M80_CUS0 ")
            (string-append "|| pid == USB_PRODUCT_ID_AIC8800M80_BASE "
                           "|| pid == USB_PRODUCT_ID_AIC8800M80_CUS0 "))
           (("\\{USB_DEVICE\\(USB_VENDOR_ID_AIC, USB_PRODUCT_ID_AIC8800DW\\)\\},")
            (string-append
             "{USB_DEVICE(USB_VENDOR_ID_AIC, USB_PRODUCT_ID_AIC8800DW)},\n"
             "    {USB_DEVICE(USB_VENDOR_ID_AIC, USB_PRODUCT_ID_AIC8800M80_BASE)},")))))))

(define aic8800-firmware
  (package
    (name "aic8800-firmware")
    (version %aic8800-version)
    (source aic8800-source)
    (build-system copy-build-system)
    (arguments
     (list #:install-plan
           #~'(("fw/aic8800D80" "lib/firmware/aic8800D80"))))
    (home-page "https://github.com/shenmintao/aic8800d80")
    (synopsis "Firmware for AICSemi AIC8800D80 USB Wi-Fi 6 adapters")
    (description
     "Non-free firmware blobs for AIC8800D80 based USB Wi-Fi 6 adapters
(VID:PID a69c:8d80).  Loaded by the aic_load_fw and aic8800_fdrv modules
from @file{/lib/firmware/aic8800D80}.")
    ;; Redistributable blobs; AICSemi does not state a license.
    (license (license:non-copyleft
              "https://github.com/shenmintao/aic8800d80/tree/main/fw"
              "Redistributable firmware for AIC8800D80."))))

;; aic_load_fw and aic8800_fdrv are built together in a single kbuild
;; invocation: fdrv references symbols exported by loadfw (get_testmode,
;; get_fw_path, aicwf_prealloc_txq_alloc, ...), and modpost only resolves
;; such cross-module references within the same build tree.
(define aic8800-modules
  (package
    (name "aic8800-modules")
    (version %aic8800-version)
    (source aic8800-source)
    (build-system linux-module-build-system)
    (arguments
     (list
      ;; Build against the customized NanoPi R2S kernel so that vermagic
      ;; matches the running system.
      #:linux linux-libre-nanopi-r2s
      #:tests? #f
      #:source-directory "drivers/aic8800"
      ;; Skip the BT ACL ZLP quirk module (scoped to 368b:8d81 adapters).
      #:make-flags #~'("CONFIG_AIC_ZLP_QUIRK=n")))
    (home-page "https://github.com/shenmintao/aic8800d80")
    (synopsis "AIC8800 firmware loader and fullmac Wi-Fi driver")
    (description
     "Out-of-tree kernel modules for AIC8800D80 USB Wi-Fi 6 adapters:
@code{aic_load_fw} uploads the firmware from @file{/lib/firmware/aic8800D80}
and @code{aic8800_fdrv} provides the netdev.")
    (license license:gpl2)))

(define aic8800-udev-rules
  ;; Eject the fake driver CD-ROM so the stick leaves mass-storage mode
  ;; (a69c:572x) and re-enumerates as a WLAN device (a69c:8d80).  Mirrors
  ;; upstream aic.rules.  "Pandora" clones idling at 1111:1111 need
  ;; usb_modeswitch instead and are not covered here.
  (computed-file
   "aic8800-udev-rules"
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils))
         (define rules.d (string-append #$output "/lib/udev/rules.d"))
         (define eject #$(file-append util-linux "/bin/eject"))
         (mkdir-p rules.d)
         (call-with-output-file
             (string-append rules.d "/99-aic8800-mode-switch.rules")
           (lambda (port)
             (for-each
              (lambda (pid)
                (display
                 (string-append
                  "ACTION==\"add\", SUBSYSTEM==\"block\", "
                  "ATTRS{idVendor}==\"a69c\", "
                  "ATTRS{idProduct}==\"" pid "\", "
                  "RUN+=\"" eject " /dev/%k\"\n")
                 port))
              '("5721" "5722" "5723" "5724" "5725" "5726" "5727"
                "572a" "572c" "572f"))))))))

(define %herb
  (let ([base nanopi-r2s-barebones-os])
    (operating-system
     (inherit base)
     (host-name "herb")
     (kernel-arguments '("console=ttyS2,1500000"
                         "earlycon=uart8250,mmio32,0xff130000"))
     ;; AIC8800D80 USB Wi-Fi 6 dongle (a69c:8d80).
     (kernel-loadable-modules (list aic8800-modules))
     (firmware (cons* aic8800-firmware %base-firmware))
     (users (cons (user-account
                    (name "jinser")
                    (comment "Jinser Kafka")
                    (password "$6$REDACTED")
                    (group "users")
                    (supplementary-groups '("wheel")))
              %base-user-accounts))
     (skeletons (list))
     (packages
       (cons*
         ;; ---
         admin:pfetch
         admin:tcpdump
         net:sing-box
         curl
         `(,dns:isc-bind "utils")
         ;; ---
         (operating-system-packages base)))
     (file-systems (cons*
                     root-file-system
                     (file-system
                       (device      "none")
                       (mount-point "/tmp")
                       (type        "tmpfs")
                       (flags '(no-suid no-dev no-exec))
                       (check? #f)
                       (create-mount-point? #t))
                     (file-system
                       (device      "none")
                       (mount-point "/var/log")
                       (type        "tmpfs")
                       (flags '(no-suid no-dev no-exec))
                       (check? #f)
                       (create-mount-point? #t))
                     %base-file-systems))
     (services
       (cons* (service avahi-service-type
                       (avahi-configuration
                         (host-name host-name)
                         (wide-area? #t)))
              (service openssh-service-type
                       (openssh-configuration
                         (openssh openssh-sans-x)
                         ; (permit-root-login 'prohibit-password)
                         (authorized-keys
                           (let [(dorothy (local-file "../../files/dorothy.pub"))
                                 (cosette (local-file "../../files/cosette.pub"))
                                 (hooray  (local-file "../../files/hooray.pub"))]
                             `(("jinser" ,dorothy ,cosette ,hooray)
                               ("root"   ,dorothy ,cosette ,hooray))))
                         (port-number 2222)))
              (service resize-file-system-service-type
                       (resize-file-system-configuration
                         (file-system root-file-system)))
              (service tailscale-service-type
                       (tailscale-configuration
                         (extra-options '("-port" "41641"))))
              (service agetty-service-type
                (agetty-configuration
                  (tty "ttyS2")
                  (baud-rate "1500000")))
              ;; Eject rule switches the stick out of its fake
              ;; mass-storage mode (a69c:572x -> a69c:8d80).
              (udev-rules-service 'aic8800-mode-switch aic8800-udev-rules)
              ;; AIC8800D80 as AP (station-mode wpa_supplicant not needed).
              ;; Addressing (bridge with LAN / DHCP server) is up to the
              ;; rest of the router configuration.
              (service hostapd-service-type
                       (hostapd-configuration
                        (interface "wlan0")
                        (ssid "herb")
                        (channel 6)
                        ;; 5GHz instead: hw_mode=a, channel 36, and add
                        ;; ieee80211ax=1 if the firmware supports HE AP.
                        (extra-settings
                         (string-append "\
country_code=CN
hw_mode=g
ieee80211n=1
wmm_enabled=1
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_passphrase=" %herb-wpa-passphrase))))
              ;; Wireless LAN segment: static address on wlan0, DHCP for
              ;; clients, and masquerade out wan (single NAT, same as any
              ;; wired client behind this box).
              (service static-networking-service-type
                       (list (static-networking
                              (addresses
                               (list (network-address
                                      (device "wlan0")
                                      (value "192.168.9.1/24")))))))
              (service dhcpd-service-type
                       (dhcpd-configuration
                        (interfaces '("wlan0"))
                        (config-file
                         (plain-file "dhcpd.conf" "\
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 192.168.9.0 netmask 255.255.255.0 {
  range 192.168.9.50 192.168.9.150;
  option routers 192.168.9.1;
  option domain-name-servers 223.5.5.5, 119.29.29.29;
}
"))))
              (service nftables-service-type
                       (nftables-configuration
                        (ruleset
                         (plain-file "nftables.conf" "\
flush ruleset

table inet filter {
  chain input {
    type filter hook input priority 0; policy accept
  }
  chain forward {
    type filter hook forward priority 0; policy accept
  }
  chain output {
    type filter hook output priority 0; policy accept
  }
}

table ip nat {
  chain postrouting {
    type nat hook postrouting priority 100; policy accept
    oifname \"wan\" masquerade
  }
}
"))))
              (modify-services services
                ;; The server must trust the Guix packages you build. If you add the signing-key
                ;; manually it will be overridden on next `guix deploy` giving
                ;; "error: unauthorized public key". This automatically adds the signing-key.
                (guix-service-type config =>
                                   (guix-configuration
                                     (inherit config)
                                     (authorized-keys
                                       (append (list (local-file "/etc/guix/signing-key.pub"))
                                               %default-authorized-guix-keys))))
                (sysctl-service-type config =>
                                     (sysctl-configuration
                                       (inherit config)
                                       (settings (append
                                                   '(("net.ipv4.ip_forward"            . "1")
                                                     ("net.ipv6.conf.all.forwarding"   . "1")
                                                     ("net.ipv6.conf.all.accept_ra"    . "2")
                                                     ("net.core.netdev_budget"         . "600")
                                                     ("net.core.netdev_budget_usecs"   . "8000")
                                                     ("net.core.rps_sock_flow_entries" . "600"))
                                                   (sysctl-configuration-settings config)))))
                ;; SSH only
                ; (delete console-font-service-type)
                ; (delete mingetty-service-type)
                (delete agetty-service-type)
                ;; dhcpcd manages wan only; wlan0 gets a static address and
                ;; provides 'networking for dhcpd.
                (dhcpcd-service-type config =>
                                     (dhcpcd-configuration
                                      (inherit config)
                                      (interfaces '("wan"))
                                      (shepherd-provision '(dhcpcd-wan))))))))))

(define herb-image-type
  (let ([base (image-without-os
                (format 'disk-image)
                (partitions
                  (list (partition
                          (inherit root-partition)
                          ;; 16MiB
                          (offset (expt 2 24)))))
                ;; FIXME: Deleting and creating "/var/run" and "/tmp" on the overlayfs
                ;; fails.
                (volatile-root? #f))])
    (image-type (name 'herb-raw)
                (constructor (lambda (os)
                               (image (inherit base)
                                      (name 'herb-disk-image)
                                      (operating-system os)
                                      (platform aarch64-linux)))))))

(define herb-raw-image
  (image (inherit (os+platform->image %herb
                                      aarch64-linux
                                      #:type herb-image-type))
         (name 'herb-raw-image)))
         ; (volatile-root? #t)))

herb-raw-image
