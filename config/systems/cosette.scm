(define-module (config systems cosette)
  #:use-module (gnu)
  #:use-module (config systems base-system)
  #:use-module (config packages transmission))

(use-service-modules file-sharing sysctl networking ssh)
(use-package-modules bootloaders ssh shells)

(define %transmission-daemon-configuration-directory
  "/var/lib/transmission-daemon")

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

  (services (append (list (service dhcp-client-service-type)
                          (service openssh-service-type
                                   (openssh-configuration
                                     (openssh openssh-sans-x)
                                     (permit-root-login 'prohibit-password)
                                     (authorized-keys
                                       `(("jinser" ,(local-file "../../files/dorothy.pub"))
                                         ("root" ,(local-file "../../files/dorothy.pub"))))
                                     (port-number 22)))
                          (service transmission-daemon-service-type
                                   (transmission-daemon-configuration
                                     (transmission transmission*)
                                     (rpc-port 9001)
                                     (rpc-authentication-required? #t)
                                     (rpc-username "jinser")
                                     (rpc-password "{2b79a09b99bc2b99da06665666853bd337052a05ypW43WFG")
                                     (rpc-whitelist '("127.0.0.1" "::1" "192.168.*.*"))
                                     (lpd-enabled? #t)
                                     (download-dir "/srv/store/t")
                                     (incomplete-dir-enabled? #t)
                                     (incomplete-dir (string-append %transmission-daemon-configuration-directory
                                                                    "/.incomplete"))
                                     (speed-limit-up-enabled? #t)
                                     (speed-limit-up 450))))
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
                                                     %default-sysctl-settings))))))))
