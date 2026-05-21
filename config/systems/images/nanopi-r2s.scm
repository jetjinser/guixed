(define-module (config systems images nanopi-r2s)
  #:use-module (gnu)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader u-boot)
  #:use-module (gnu image)
  #:use-module (gnu packages linux)
  #:use-module (guix packages)
  #:use-module (guix platforms arm)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services networking)
  #:use-module (gnu system)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system image)
  #:use-module (gnu system locale)
  #:use-module (ice-9 match)
  #:export (nanopi-r2s-barebones-os
            nanopi-r2s-image-type
            nanopi-r2s-barebones-raw-image))

(define make-u-boot-rockchip-package
  (@@ (gnu packages bootloaders) make-u-boot-rockchip-package))

(define u-boot-nanopi-r2s
  (make-u-boot-rockchip-package "nanopi-r2s" 'rk3328))

(define u-boot-nanopi-r2s-bootloader
  (bootloader
    (inherit u-boot-orangepi-r1-plus-lts-rk3328-bootloader)
    (package u-boot-nanopi-r2s)))

(define (configs->strings options)
  (map (match-lambda
         ((option . 'm)
          (string-append option "=m"))
         ((option . #t)
          (string-append option "=y"))
         ((option . #f)
          (string-append option "=n"))
         ((option . string)
          (string-append option "=\"" string "\"")))
       options))

(define-public linux-libre-nanopi-r2s
                  ;; nftables support
  (let* ([configs `(("CONFIG_NF_TABLES"               . #t)
                    ("CONFIG_NETFILTER_NETLINK_QUEUE" . #t)
                    ("CONFIG_NF_CONNTRACK"            . #t)
                    ("CONFIG_NF_CONNTRACK_MARK"       . #t)
                    ("CONFIG_NF_TABLES_INET"          . #t)
                    ("CONFIG_NF_TABLES_NETDEV"        . #t)
                    ("CONFIG_NFT_NUMGEN"              . #t)
                    ("CONFIG_NFT_CT"                  . #t)
                    ("CONFIG_NFT_FLOW_OFFLOAD"        . #t)
                    ("CONFIG_NFT_CONNLIMIT"           . #t)
                    ("CONFIG_NFT_LOG"                 . #t)
                    ("CONFIG_NFT_LIMIT"               . #t)
                    ("CONFIG_NFT_MASQ"                . #t)
                    ("CONFIG_NFT_REDIR"               . #t)
                    ("CONFIG_NFT_NAT"                 . #t)
                    ("CONFIG_NFT_TUNNEL"              . #t)
                    ("CONFIG_NFT_QUEUE"               . #t)
                    ("CONFIG_NFT_QUOTA"               . #t)
                    ("CONFIG_NFT_REJECT"              . m)
                    ("CONFIG_NFT_COMPAT"              . m)
                    ("CONFIG_NFT_HASH"                . #t)
                    ("CONFIG_NFT_FIB_INET"            . m)
                    ("CONFIG_NFT_SOCKET"              . m)
                    ("CONFIG_NFT_OSF"                 . #t)
                    ("CONFIG_NFT_TPROXY"              . m)
                    ("CONFIG_NFT_SYNPROXY"            . #t)
                    ("CONFIG_NFT_DUP_NETDEV"          . #t)
                    ("CONFIG_NFT_FWD_NETDEV"          . #t)
                    ("CONFIG_NFT_FIB_NETDEV"          . m)
                    ("CONFIG_NFT_REJECT_NETDEV"       . m)
                    ("CONFIG_NF_FLOW_TABLE"           . #t)
                    ("CONFIG_NFT_DUP_IPV4"            . #t)
                    ("CONFIG_NFT_FIB_IPV4"            . #t)
                    ("CONFIG_NF_LOG_IPV4"             . #t)
                    ("CONFIG_NFT_DUP_IPV6"            . m)
                    ("CONFIG_NFT_FIB_IPV6"            . m)
                    ("CONFIG_NF_NAT"                  . #t)
                    ("CONFIG_NF_NAT_MASQUERADE"              . #t)
                    ("CONFIG_NETFILTER_XT_TARGET_MASQUERADE" . m)
                    ("CONFIG_NETFILTER_XT_MATCH_CONNMARK"    . m)
                    ("CONFIG_NETFILTER_XT_TARGET_CONNMARK"   . m)
                    ("CONFIG_NETFILTER_XT_CONNMARK"          . m)

                    ("CONFIG_PPP"                     . #t)
                    ("CONFIG_PPPOE"                   . #t)
                    ("CONFIG_PPP_ASYNC"               . #t)
                    ("CONFIG_PPP_DEFLATE"             . #t)
                    ("CONFIG_PPP_BSDCOMP"             . #t)

                    ("CONFIG_USB_GADGET"        . #t)
                    ("CONFIG_USB_ETH"           . m))]

                    ; ("CONFIG_PSI"               . m))]
         [base (customize-linux
                 #:linux linux-libre-arm64-generic
                 #:extra-version "arm64-nanopi-r2s"
                 #:configs (configs->strings configs))])
    (package
      (inherit base)
      (name "linux-libre-nanopi-r2s"))))

(define nanopi-r2s-barebones-os
  (operating-system
    (host-name "R2S")
    (timezone "Asia/Shanghai")
    (locale "en_US.utf8")
    (bootloader (bootloader-configuration
                  (bootloader u-boot-nanopi-r2s-bootloader)
                  (targets '("/dev/mmcblk0"))))
    (initrd-modules
      (list "dwmac_rk"
            "stmmac_platform"
            "stmmac"
            "pcs_xpcs"
            "r8152"
            "usbnet"
            "cdc_ether"
            "r8153_ecm"))
    (kernel linux-libre-nanopi-r2s)
    ; (kernel linux-libre)
    ; (kernel linux-libre-arm64-generic)
    (file-systems (cons (file-system
                          (device (file-system-label "ROOT"))
                          (mount-point "/")
                          (type "ext4"))
                        %base-file-systems))
    (packages (filter (lambda (pkg)
                        (not (member (package-name pkg) '("mg"     "nano"        "nvi"
                                                          "man-db" "info-reader"
                                                          "wget"   "iw"          "wireless-tools"
                                                          "which"  "patch"
                                                          "guile-colorized"      "guile-readline"))))
                      %base-packages))
    (services
      (cons* (service dhcpcd-service-type)
             (service ntp-service-type)
             %base-services))
    (locale-definitions (list (locale-definition
                                (name "en_US.utf8") (source "en_US"))))))

(define nanopi-r2s-image-type
  (image-type (name 'nanopi-r2s-raw)
              (constructor (lambda (os)
                             (image (inherit (raw-with-offset-disk-image (expt 2 24))) ; 16MiB
                                    (name 'nanopi-r2s-disk-image)
                                    (operating-system os)
                                    (platform aarch64-linux))))))

(define nanopi-r2s-barebones-raw-image
  (image (inherit (os+platform->image nanopi-r2s-barebones-os
                                      aarch64-linux
                                      #:type nanopi-r2s-image-type))
         (name 'nanopi-r2s-barebones-raw-image)))

linux-libre-nanopi-r2s
