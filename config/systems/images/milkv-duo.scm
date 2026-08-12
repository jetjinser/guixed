(define-module (config systems images milkv-duo)
  #:use-module (gnu)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader u-boot)
  #:use-module (gnu image)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages bootloaders)
  #:use-module (guix packages)
  #:use-module (guix platforms arm)
  #:use-module (guix utils)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services networking)
  #:use-module (gnu system)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system image)
  #:use-module (gnu system locale)
  #:use-module (gnu services ssh)
  #:use-module (gnu services avahi)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages admin) ; neofetch
  #:export (milkv-duo-barebones-os
            milkv-duo-image-type
            milkv-duo-barebones-raw-image))

;; CV1800B
;; C906 RV64IMAFDCV

(define-public u-boot-milkv-duo
  (let ((base (make-u-boot-package "milkv_duo" "riscv64-linux-gnu")))
    (package
      (inherit base)
      (name "u-boot-milkv-duo")
      (arguments
       (substitute-keyword-arguments (package-arguments base)
         ((#:configs configs)
          ;; 0x80200000 是算能 FSBL 跳转的硬编码地址
          `("CONFIG_TEXT_BASE=0x80200000"
            "CONFIG_SYS_MALLOC_LEN=0x200000"
            ,@configs))
         ((#:phases phases)
          #~(modify-phases #$phases
              (add-after 'install 'install-bin
                (lambda* (#:key outputs #:allow-other-keys)
                  (let* ((out (assoc-ref outputs "out"))
                         (libexec (string-append out "/libexec")))
                    (mkdir-p libexec)
                    (install-file "u-boot.bin" libexec)))))))))))

u-boot-milkv-duo
