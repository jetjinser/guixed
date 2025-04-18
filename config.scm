;; This is an operating system configuration template
;; for a "desktop" setup without full-blown desktop
;; environments.

(use-modules (gnu) (gnu system nss))
(use-modules (srfi srfi-1))

(use-service-modules networking ssh)
(use-package-modules bootloaders ssh certs shells nvi text-editors)

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
                (supplementary-groups '("wheel" "netdev"
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
                                    (port-number 22))))
                    %base-services))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
