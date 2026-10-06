(define-module (systems hosts mizuki)
  #:use-module (gnu)
  #:use-module (gnu image)
  #:use-module (gnu system image)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages ssh)
  #:use-module ((gnu packages admin) #:prefix admin:)
  #:use-module ((gnu packages dns)   #:prefix dns:)
  #:use-module (gnu services admin)
  #:use-module (gnu services avahi)
  #:use-module (gnu services ssh)
  #:use-module (gnu services networking)
  #:use-module (guix platforms arm)
  #:use-module (systems boards tspi-rk3566)
  #:use-module (config utils secrets)
  #:export (%mizuki mizuki-raw-image))

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

;; WPA passphrase for the "lz" network, kept out of version control.
(define %mizuki-wpa-passphrase
  (read-secret "secrets/mizuki.wpa"))

(define %mizuki
  (let ([base tspi-barebones-os])
    (operating-system
      (inherit base)
      (host-name "mizuki")
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
                            (let [(dorothy (local-file "../../assets/keys/dorothy.pub"))
                                  (cosette (local-file "../../assets/keys/cosette.pub"))
                                  (hooray  (local-file "../../assets/keys/hooray.pub"))]
                              `(("jinser" ,dorothy ,cosette ,hooray)
                                ("root"   ,dorothy ,cosette ,hooray))))
                          (port-number 2222)))
               (service resize-file-system-service-type
                        (resize-file-system-configuration
                          (file-system root-file-system)))
               (service wpa-supplicant-service-type
                        (wpa-supplicant-configuration
                         (interface "wlan0")
                         (config-file (plain-file "wpa_supplicant.conf"
                                                  (string-append "\
ctrl_interface=/var/run/wpa_supplicant
ap_scan=1
network={
    ssid=\"lz\"
    psk=\"" %mizuki-wpa-passphrase "\"
}
")))))
               (modify-services services
                 (guix-service-type config =>
                                    (guix-configuration
                                      (inherit config)
                                      (authorized-keys
                                        (append (list (local-file "/etc/guix/signing-key.pub"))
                                                %default-authorized-guix-keys))))))))))
                 ; (delete dhcpcd-service-type)
                 ; (delete nscd-service-type)))))))
                 ;; SSH only
                 ; (delete console-font-service-type)
                 ; (delete mingetty-service-type)
                 ; (delete agetty-service-type)))))))

(define mizuki-image-type
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
    (image-type (name 'mizuki-raw)
                (constructor (lambda (os)
                               (image (inherit base)
                                      (name 'mizuki-disk-image)
                                      (operating-system os)
                                      (platform aarch64-linux)))))))

(define mizuki-raw-image
  (image (inherit (os+platform->image %mizuki
                                      aarch64-linux
                                      #:type mizuki-image-type))
         (name 'mizuki-raw-image)))

mizuki-raw-image
