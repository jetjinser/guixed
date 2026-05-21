(define-module (config systems herb)
  #:use-module (ice-9 textual-ports)
  #:use-module (config systems images nanopi-r2s)
  #:use-module (gnu)
  #:use-module (gnu image)
  #:use-module (gnu system image)
  #:use-module (guix platforms arm)
  #:use-module (guix packages)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages monitoring)
  #:use-module ((gnu packages admin)      #:prefix admin:)
  #:use-module ((gnu packages dns)        #:prefix dns:)
  #:use-module ((gnu packages networking) #:prefix net:)
  #:use-module ((gnu packages vim)        #:prefix vim:)
  #:use-module ((rosenthal packages networking) #:prefix net:)
  #:use-module ((rosenthal packages web)  #:prefix web:)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services ssh)
  #:use-module (gnu services admin)
  #:use-module (gnu services avahi)
  #:use-module (gnu services sysctl)
  #:use-module (gnu services networking)
  #:use-module (gnu services dns)
  #:use-module (gnu services monitoring)
  #:use-module (rosenthal services networking)
  #:use-module (rosenthal services web)
  #:use-module (config services networking)
  #:use-module (config build noxcaddy)
  #:export (%herb herb-raw-image))

(define caddy/porkbun/ddns
  (caddy-with-plugins
    #:caddy       web:caddy
    #:plugins     '(("github.com/caddy-dns/porkbun"      . "v0.3.1")
                    ("github.com/mholt/caddy-dynamicdns" . "v0.0.0-20251231002810-1af4f8876598"))
    #:vendor-hash "0ap9bq4w7d7wzwrv1h102l12k9k136bc3xbna5n0difiaskm0fi9"
    #:go          go-1.26))

(define-syntax-rule (include-relative path)
  (call-with-input-file (string-append (dirname (current-filename)) path)
                        get-string-all))

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
      "ACTION==\"add\", SUBSYSTEM==\"net\", ATTR{address}==\"6e:c9:82:b9:b4:e8\", NAME=\"wan\"\n"
      "ACTION==\"add\", SUBSYSTEM==\"net\", ATTR{address}==\"6e:c9:82:b9:b4:e9\", NAME=\"lan\"")))

(define %herb
  (let ([base nanopi-r2s-barebones-os])
    (operating-system
     (inherit base)
     (host-name "herb")
     (users (cons (user-account
                    (name "jinser")
                    (comment "Jinser Kafka")
                    (password "$6$nOXYtPYrnonO1Wqz$nVr86fVu/sE3APSuJN7lcWBg8ez9771nFerJAf37Lh21AHPXA3ot9mZC8fN8KWazpJKmiDudHKp70BXFK1gTw1")
                    (group "users")
                    (supplementary-groups '("wheel")))
              %base-user-accounts))
     (skeletons (list))
     (packages
       (cons*
         ;; ---
         admin:pfetch
         admin:tcpdump
         admin:dhcpcd
         net:arp-scan
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
                     ;; TODO: required by syslogd
                     (file-system
                       (device      "none")
                       (mount-point "/var/log")
                       (type        "tmpfs")
                       (flags '(no-suid no-dev no-exec))
                       (check? #f)
                       (create-mount-point? #t))
                     ; (file-system
                     ;   (device      "none")
                     ;   (mount-point "/run")
                     ;   (type        "tmpfs")
                     ;   (flags '(no-suid no-dev no-exec))
                     ;   (check? #f)
                     ;   (create-mount-point? #t))
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
                                 (cosette (local-file "../../files/cosette.pub"))]
                             `(("jinser" ,dorothy ,cosette)
                               ("root"   ,dorothy ,cosette))))
                         (port-number 22)))
              (service resize-file-system-service-type
                       (resize-file-system-configuration
                         (file-system root-file-system)))
              (udev-rules-service 'link-name %link-name-rule)
              (service pppoe-service-type
                       (pppoe-configuration
                         (peer-file (local-file "herb/pppoe.peer"))))
              (service dhcpcd-service-type
                       (dhcpcd-configuration
                         (interfaces '("ppp0"))
                         (shepherd-provision '(pppoe-ipv6))
                         (shepherd-requirement '(pppoe))
                         (extra-content (include-relative "/herb/dhcpcd.tail"))))
              (service nftables-service-type*
                       (nftables-configuration*
                         (ruleset (local-file "herb/ruleset.nft"))))
              (service dnsmasq-service-type
                       (dnsmasq-configuration
                         (no-resolv? #t)
                         (no-hosts? #t)
                         (servers '("127.0.0.1#15353"))
                         (listen-addresses '("127.0.0.1" "::1"))
                         (conf-file (list (local-file "herb/dnsmasq.conf")))))
              (service hickory-dns-service-type
                       (hickory-dns-configuration
                         (config-file (local-file "herb/named.toml"))))
              (simple-service 'blocklist-updater
                              shepherd-root-service-type
                              (list update-blocklist-timer))
              (service tailscale-service-type
                       (tailscale-configuration
                         (extra-options '("-port" "41641"))))
              (service prometheus-node-exporter-service-type
                       (prometheus-node-exporter-configuration
                         (package prometheus-node-exporter)
                         (web-listen-address "100.115.6.12:9100")))
              (service caddy-service-type
                       (caddy-configuration
                         (caddy caddy/porkbun/ddns)
                         (caddyfile (local-file "herb/caddyfile"))))
              (service static-networking-service-type
                       (list
                         (static-networking
                           (addresses (list (network-address
                                              (device "lo")
                                              (value "127.0.0.1/8"))))
                           (requirement '())
                           (provision '(loopback)))
                         (static-networking
                           (provision '(wan-ready))
                           (requirement '(udev))
                           (links (list (network-link
                                          (name "wan")
                                          (arguments '((up . #t))))))
                           (addresses '()))
                         (static-networking
                           (provision '(br0-device))
                           (links (list (network-link
                                          (name "br0")
                                          (type 'bridge)
                                          (arguments '()))))
                           (addresses '()))
                         (static-networking
                           (provision '(networking))
                           (requirement '(wan-ready br0-device))
                           (links (list (network-link
                                          (name "lan")
                                          (arguments '((master . "br0")
                                                       (up     . #t))))))
                           (addresses (list (network-address
                                             (device "br0")
                                             (value "192.168.1.1/24"))))
                           (name-servers '("127.0.0.1")))))
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
                                                   '(("net.ipv4.ip_forward"          . "1")
                                                     ("net.ipv6.conf.all.forwarding" . "1")
                                                     ("net.ipv6.conf.all.accept_ra"  . "2"))
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
