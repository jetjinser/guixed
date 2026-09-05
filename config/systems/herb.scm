;; TODO:
;; 2. prometheus-node-exporter should require tailscale
;; 3. pppoe-ipv6 failed for strange reason when os start

(define-module (config systems herb)
  #:use-module (ice-9 textual-ports)
  #:use-module (config systems images nanopi-r2s)
  #:use-module (gnu)
  #:use-module (gnu image)
  #:use-module (gnu system image)
  #:use-module (guix platforms arm)
  #:use-module (guix packages)
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

(define %link-name-rule
  (udev-rule
    "10-link-name.rules"
    (string-append
      "ACTION==\"add\", SUBSYSTEM==\"net\", ATTR{address}==\"6e:c9:82:b9:b4:e8\", NAME=\"wan\", "
      "RUN+=\"/bin/sh -c 'echo f > /sys/class/net/wan/queues/rx-0/rps_cpus && echo 32768 > /sys/class/net/wan/queues/rx-0/rps_flow_cnt'\"\n"
      "ACTION==\"add\", SUBSYSTEM==\"net\", ATTR{address}==\"6e:c9:82:b9:b4:e9\", NAME=\"lan\", "
      "RUN+=\"/bin/sh -c 'echo f > /sys/class/net/lan/queues/rx-0/rps_cpus && echo 32768 > /sys/class/net/lan/queues/rx-0/rps_flow_cnt'\"")))

(define %herb
  (let ([base nanopi-r2s-barebones-os])
    (operating-system
     (inherit base)
     (host-name "herb")
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
                         (permit-root-login 'prohibit-password)
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
              (udev-rules-service 'link-name %link-name-rule)
              (service kernel-module-loader-service-type
                       '("dwc2" "g_ether"))
              (service dhcpcd-service-type
                       (dhcpcd-configuration
                         (interfaces '("wan"))))
              ; (service nftables-service-type
              ;          (nftables-configuration
              ;            (ruleset (local-file "herb/ruleset.nft"))))
              (service dnsmasq-service-type
                       (dnsmasq-configuration
                         (no-resolv? #t)
                         (no-hosts? #t)
                         (servers '("127.0.0.1#15353"))
                         (listen-addresses '("127.0.0.1" "::1"))
                         (conf-file (list (local-file "herb/dnsmasq.conf")))))
              ; (service hickory-dns-service-type
              ;          (hickory-dns-configuration
              ;            (config-file (local-file "herb/named.toml"))))
              ; (simple-service 'blocklist-updater
              ;                 shepherd-root-service-type
              ;                 (list update-blocklist-timer))
              (service tailscale-service-type
                       (tailscale-configuration
                         (extra-options '("-port" "41641"))))
              (simple-service 'tailscale-auto-auth
                shepherd-root-service-type
                (list
                  (shepherd-service
                    (provision '(tailscale-auth))
                    (requirement '(tailscaled))
                    (one-shot? #t)
                    (start #~(lambda ()
                               (zero? (system* #$(file-append tailscale "/bin/tailscale")
                                               "up"
                                               "--authkey=tskey-auth-REDACTED"
                                               "--ssh=true"))))
                    (documentation "Tailscale auto auth"))))
              (service static-networking-service-type
                       (list
                         (static-networking
                           (provision '(loopback))
                           (requirement '(udev))
                           (links (list
                                    (network-link
                                          (name "br0")
                                          (type 'bridge)
                                          (arguments '()))
                                    (network-link
                                          (name "lan")
                                          (arguments '((master . "br0")
                                                       (up     . #t))))
                                    (network-link
                                      (name "wan")
                                      (arguments '((up . #t))))))
                           (addresses (list
                                        (network-address
                                                  (device "lo")
                                                  (value "127.0.0.1/8"))
                                        (network-address
                                          (device "br0")
                                          (value "192.168.1.2/24"))))
                           (name-servers '("1.1.1.1" "223.5.5.5")))
                         (static-networking
                           (provision '(usb0))
                           (addresses
                             (list (network-address
                                     (device "usb0")
                                     (value "10.42.0.1/24")))))))
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
                (delete static-networking-service-type)
                (delete dhcpcd-service-type)
                (delete nscd-service-type)
                ;; SSH only
                (delete console-font-service-type)
                (delete mingetty-service-type)
                (delete agetty-service-type)))))))

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
