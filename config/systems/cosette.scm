(define-module (config systems cosette)
  #:use-module (gnu)
  #:use-module (config systems base-system)
  #:use-module (config packages transmission)
  #:use-module (config services avahi-publish)
  #:use-module (rosenthal services networking)
  #:export (%cosette))

(use-service-modules file-sharing sysctl networking ssh upnp avahi dns)
(use-package-modules bootloaders ssh shells)

(define %transmission-daemon-configuration-directory
  "/var/lib/transmission-daemon")

(define %cosette
  (operating-system
      (inherit %base-system)
      (host-name "cosette")

      (bootloader (bootloader-configuration
                    (bootloader grub-efi-bootloader)
                    (targets '("/boot/efi"))))

      (file-systems (append
                      (list (file-system
                              (device (file-system-label "root"))
                              (mount-point "/")
                              (type "btrfs"))
                            (file-system
                              (device (file-system-label "ESP"))
                              (mount-point "/boot/efi")
                              (type "vfat")))
                      %base-file-systems))
      (swap-devices (list
                      (swap-space
                        (target "/swap/swapfile")
                        (dependencies (filter (file-system-mount-point-predicate "/")
                                              file-systems)))))

      (services (append (list (service dhcpcd-service-type
                                (dhcpcd-configuration (static '("domain_name_servers=127.0.0.1"))))
                              (service dnsmasq-service-type
                                (dnsmasq-configuration
                                  (no-resolv? #t)
                                  (listen-addresses '("127.0.0.1"))
                                  (servers '("223.5.5.5"
                                             "1.1.1.1"
                                             "8.8.8.8"
                                             ;; tailscale dns
                                             "100.100.100.100"))
                                  (cache-size 10000)))
                              (simple-service 'tailscale-search etc-service-type
                                ;; tailscale tsnet
                                `(("resolv.conf.tail" ,(plain-file "resolv.conf.tail"
                                                                   "search elk-agama.ts.net"))))
                              (service nftables-service-type
                                       (nftables-configuration
                                         (ruleset
                                           (local-file "../../files/rulesets.nft"
                                                       "rulesets.nft"))))
                              (service ntp-service-type (ntp-configuration))
                              (service openssh-service-type
                                       (openssh-configuration
                                         (openssh openssh-sans-x)
                                         (permit-root-login 'prohibit-password)
                                         (authorized-keys
                                           (let [(dorothy (local-file "../../files/dorothy.pub"))
                                                 (cosette (local-file "../../files/cosette.pub"))]
                                             `(("jinser" ,dorothy ,cosette)
                                               ("root" ,dorothy ,cosette))))
                                         (port-number 22)))
                              (service avahi-service-type
                                       (avahi-configuration
                                         (host-name host-name)
                                         (wide-area? #t)))
                              (service avahi-publish-service-type
                                       (avahi-publish-configuration))
                              (service transmission-daemon-service-type
                                       (transmission-daemon-configuration
                                         (transmission transmission*)
                                         (rpc-port 9001)
                                         (rpc-authentication-required? #t)
                                         (rpc-username "jinser")
                                         (rpc-password "{2b79a09b99bc2b99da06665666853bd337052a05ypW43WFG")
                                         (rpc-whitelist '("127.0.0.1" "::1" "192.168.*.*"))
                                         (download-dir "/srv/store/t")
                                         (incomplete-dir-enabled? #t)
                                         (incomplete-dir (string-append %transmission-daemon-configuration-directory
                                                                        "/.incomplete"))
                                         (speed-limit-up-enabled? #t)
                                         (speed-limit-up 800)
                                         (alt-speed-enabled? #t)
                                         (alt-speed-up 450) ; 450 KB/s
                                         (alt-speed-down 10000000) ; 10 GB/s
                                         (alt-speed-time-enabled? #t)
                                         (alt-speed-time-begin 480) ; 8am
                                         (alt-speed-time-end 60) ; 1am
                                         (download-queue-size 10) ; default = 5
                                         (lpd-enabled? #t)))
                              (service readymedia-service-type
                                       (readymedia-configuration
                                         (friendly-name "cosette-landing")
                                         (port 9002)
                                         (media-directories
                                           (list (readymedia-media-directory (path "/srv/store/pv")
                                                                             (types '(P V)))
                                                 (readymedia-media-directory (path "/srv/store/v")
                                                                             (types '(V)))))))
                              (service tailscale-service-type
                                       (tailscale-configuration
                                         (extra-options '("-port" "41641"))))
                              (simple-service 'guix-moe guix-service-type
                                (guix-extension
                                  (authorized-keys
                                   (list (plain-file "guix-moe-old.pub"
                                           "(public-key (ecc (curve Ed25519) (q #374EC58F5F2EC0412431723AF2D527AD626B049D657B5633AAAEBC694F3E33F9#)))")
                                         ;; 2025-10-29 起用的新公鑰
                                         (plain-file "guix-moe.pub"
                                           "(public-key (ecc (curve Ed25519) (q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))")))
                                  (substitute-urls
                                   '("https://cache-cdn.guix.moe"
                                     "https://mirror.sjtu.edu.cn/guix")))))
                        (modify-services %base-services
                                         (sysctl-service-type
                                           config =>
                                           (sysctl-configuration
                                             (settings (append
                                                         '(("net.ipv4.tcp_congestion_control" . "bbr")
                                                           ("net.ipv4.tcp_rmem" . "8192 262144 1073741824")
                                                           ("net.ipv4.tcp_wmem" . "4096 16384 1073741824")
                                                           ("net.ipv4.tcp_adv_win_scale" . "-2")

                                                           ("net.core.default_qdisc" . "fq")
                                                           ("net.core.rmem_max" . "7500000")
                                                           ("net.core.wmem_max" . "7500000"))
                                                         %default-sysctl-settings)))))))))

%cosette
