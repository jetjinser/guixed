(define-module (config systems base-system)
  #:use-module (gnu)
  #:use-module (gnu system nss)
  #:use-module (srfi srfi-1)
  #:export (%base-system))

(use-service-modules networking ssh)
(use-package-modules bootloaders shells nvi text-editors)

(define %base-system
  (operating-system
    (host-name "base")
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
                  (comment "Jinser Kafka")
                  (group "users")
                  (shell (file-append fish "/bin/fish"))
                  (home-directory "/home/jinser")
                  (supplementary-groups '("wheel" "netdev" "transmission"
                                          "audio" "video" "readymedia")))
                 %base-user-accounts))

    (packages (lset-difference eqv? %base-packages (list nvi mg)))

    (services (append (list (service dhcp-client-service-type)
                            (service openssh-service-type
                                     (openssh-configuration
                                       (openssh openssh-sans-x)
                                       (permit-root-login 'prohibit-password)
                                       (authorized-keys
                                         `(("jinser" ,(local-file "../../files/dorothy.pub"))
                                           ("root" ,(local-file "../../files/dorothy.pub"))))
                                       (port-number 22))))
                      %base-services))

     ;; Allow resolution of '.local' host names with mDNS.
    (name-service-switch %mdns-host-lookup-nss)))
