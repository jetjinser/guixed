(use-modules (gnu) (gnu system nss))
(use-modules (srfi srfi-1))

(use-service-modules networking ssh)
(use-package-modules bootloaders ssh certs shells nvi text-editors)

(use-modules (gnu services file-sharing))
(use-modules (gnu services sysctl))

(use-modules (pkgs transmission))
(use-modules (sss pbh))

(define %transmission-daemon-configuration-directory
  "/var/lib/transmission-daemon")

(operating-system
  (host-name "cosette")
  (timezone "Asia/Shanghai")
  (locale "en_US.utf8")

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

  (users (cons (user-account
                (name "jinser")
                (comment "The JK")
                (group "users")
                (shell (file-append fish "/bin/fish"))
                ;; not working?
                ;; (password "$6$gVQz/r75hkES.aRj$tjswSTTNHcdvoKFY1i40xfspAg3/vTZLAweg81OrQveQRs9cBb/qIGv1F8jd.c5//cTmHxwnBidqbAjbCuU/u/")
                (home-directory "/home/jinser")
                (supplementary-groups '("wheel" "netdev" "transmission"
                                        "audio" "video")))
               %base-user-accounts))

  (packages (lset-difference eqv? %base-packages (list nvi mg)))

  (services (append (list (service dhcp-client-service-type)
                          (service openssh-service-type
                                   (openssh-configuration
                                    (openssh openssh-sans-x)
                                    (permit-root-login 'prohibit-password)
                                    (authorized-keys
                                      `(("jinser" ,(local-file "dorothy.pub"))
                                        ("root" ,(local-file "dorothy.pub"))))
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
                          ; (service pbh-daemon-service-type (pbh-daemon-configuration)))
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
                                  %default-sysctl-settings)))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
