(define-module (systems boards tspi-rk3566)
  #:use-module (gnu)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader u-boot)
  #:use-module (gnu build bootloader)
  #:use-module (gnu image)
  #:use-module (gnu packages bootloaders)
  #:use-module (gnu packages linux)
  #:use-module ((nongnu packages linux) #:prefix nonguix:) ; nonguix 非 libre 内核
  #:use-module (guix build-system trivial)
  #:use-module (guix build utils)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
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
  #:use-module (config utils linux)
  #:export (rtw88-rtw8723d-firmware
            rtl8723ds-bt-firmware
            rtl8723ds-bt-config
            brcmfmac43430-sdio-firmware
            brcmfmac43430-board-config
            brcmfmac43430-clm-blob
            bcm43438a1-bt-firmware
            tspi-barebones-os
            tspi-image-type
            tspi-barebones-raw-image))

(define arm-trusted-firmware-rk3568
  ;; 官方包默认的 ATF 版本（2.12.x）没有 RK3568 的 SCMI server，而内核 7.1 的
  ;; rk356x dtsi 用 arm,scmi-smc 提供 CPU/GPU 时钟，导致 SCMI 通信失败、GPU 永远
  ;; -517(EPROBE_DEFER)。ATF 从 v2.14 起才合入 SCMI server，这里覆盖到 lts-v2.14.6。
  (let ((base ((@@ (gnu packages firmware) make-arm-trusted-firmware) "rk3568")))
    (package
      (inherit base)
      (version "2.14.6")
      (source
       (origin
         (inherit (package-source base))
         (method git-fetch)
         (uri (git-reference
                (url "https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git/")
                (commit "lts-v2.14.6")))
         (file-name (git-file-name "arm-trusted-firmware" "2.14.6"))
         ;; 官方模板自带的 8mq 补丁是针对 imx8mq 的老补丁，对 2.14.6 已无法干净应用，
         ;; 且与本平台（rk3568）无关，这里去掉。
         (patches '())
         (sha256
          (base32 "0xxvyhxrj90w2zciw08dm329qjj0ix8561n3h6cpz9ggiz069bjx")))))))

(define rk3568-ddr-bin
  (package
    (name "rkbin-rk3568-ddr")
    (version "1.25")
    (source
     (origin
       (method url-fetch)
       (uri "https://raw.githubusercontent.com/rockchip-linux/rkbin/master/bin/rk35/rk3568_ddr_1560MHz_v1.25.bin")
       (file-name "rk3568_ddr_1560MHz_v1.25.bin")
       (sha256
        (base32 "1z07kvkc7vxklv3h6948pjpgmq6iqh8vjm5angs6wsr55a19n7db"))))
    (build-system trivial-build-system)
    (arguments
     (list #:modules '((guix build utils))
           #:builder
           #~(begin
               (use-modules (guix build utils))
               (mkdir-p (string-append #$output "/bin"))
               (copy-file #$(package-source this-package)
                          (string-append #$output "/bin/rk3568_ddr_1560MHz_v1.25.bin")))))
    (home-page "https://github.com/rockchip-linux/rkbin")
    (synopsis "Rockchip DDR initialisation binary for RK3568/RK3566")
    (description "Binary blob from Rockchip's rkbin, required by mainline U-Boot
to initialise DRAM on RK3568/RK3566.  Proprietary; kept out of Guix upstream.")
    (license (license:non-copyleft "https://github.com/rockchip-linux/rkbin"))))

;; RTL8723DS WiFi/Bluetooth 固件（专有 blob，Guix 没有 linux-firmware 包，需自行打包）
(define %linux-firmware-base
  "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain")

(define %armbian-firmware-base
  "https://raw.githubusercontent.com/armbian/firmware/master")

(define* (single-firmware-package name version url sha64 relpath)
  "Return a trivial package installing the single firmware blob at URL to
/lib/firmware/RELPATH on the target system."
  (package
    (name name)
    (version version)
    (source (origin
              (method url-fetch)
              (uri url)
              (sha256 (base64 sha64))))
    (build-system trivial-build-system)
    (arguments
     (list #:modules '((guix build utils))
           #:builder
           #~(begin
               (use-modules (guix build utils))
               (let ((dest (string-append #$output "/lib/firmware/"
                                          #$relpath)))
                 (mkdir-p (dirname dest))
                 (copy-file #$source dest)))))
    (home-page "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/")
    (synopsis "Firmware for the RTL8723DS WiFi/Bluetooth module")
    (description "Proprietary Realtek firmware blob, loaded at runtime by the
rtw88 WiFi driver and the btrtl Bluetooth driver.")
    (license (license:non-copyleft url))))

;; rtw88 (RTL8723DS SDIO WiFi) 固件，来自 linux-firmware。
(define-public rtw88-rtw8723d-firmware
  (single-firmware-package
   "rtw88-rtw8723d-firmware" "6.1"
   (string-append %linux-firmware-base "/rtw88/rtw8723d_fw.bin")
   "nGTgeYFaMzo/e3Mb58wL5lIG68iDiRZZ3I/17Tal4vU="
   "rtw88/rtw8723d_fw.bin"))

;; btrtl (RTL8723DS UART 蓝牙) 固件；linux-firmware/树莓派/Debian 均未收录，
;; 可靠在线来源是 Armbian firmware 仓库（本镜像 rootfs 中也包含同份文件）。
(define-public rtl8723ds-bt-firmware
  (single-firmware-package
   "rtl8723ds-bt-firmware" "6.1"
   (string-append %armbian-firmware-base "/rtl_bt/rtl8723ds_fw.bin")
   "GcG+16k1mxoCHCD4G1Jb3r9QZ/kCFxaZHZS+kQH3bmM="
   "rtl_bt/rtl8723ds_fw.bin"))

(define-public rtl8723ds-bt-config
  (single-firmware-package
   "rtl8723ds-bt-config" "6.1"
   (string-append %armbian-firmware-base "/rtl_bt/rtl8723ds_config.bin")
   "fR4Y33ZU2o9jglIIQbtTXy0SRvyEleOuZS97I+ggFo0="
   "rtl_bt/rtl8723ds_config.bin"))

;; AP6212（BCM43430A1）WiFi/蓝牙固件。泰山派板载模块为博通 AP6212，
;; 主线 brcmfmac/btbcm 需要以下三个文件（linux-firmware 中没有 BCM43430A1.hcd，
;; 蓝牙 patchram 取自 armbian firmware 的 ap6212 目录）。
(define-public brcmfmac43430-sdio-firmware
  (single-firmware-package
   "brcmfmac43430-sdio-firmware" "1.0"
   (string-append %linux-firmware-base "/cypress/cyfmac43430-sdio.bin")
   "k/PEDJQ0DCmkBxTLBOPomXSHD8rkKoRLikVEdQFZ9A0="
   "brcm/brcmfmac43430-sdio.bin"))

;; NVRAM 取自泰山派官方 buildroot 固件（tspi-1m-kernel6.1-buildroot-hdmi-20260320.img
;; 的 rootfs /lib/firmware/nvram_ap6212a.txt），板载模组为 AP6212A。
;; 注意不要用 Armbian ap6212/nvram_ap6212.txt（Linaro 版）：其 PA 校准参数
;; (pa2ga0/maxp2ga0/TX gain 表)与本模组不符，实测表现为关联后数秒即被踢出、
;; 认证超时。两版身份字段(devid/boardtype/MAC)完全相同，仅射频校准不同。
(define-public brcmfmac43430-board-config
  (package
    (name "brcmfmac43430-board-config")
    (version "1.0")
    (source (local-file "files/nvram_ap6212a.txt"))
    (build-system trivial-build-system)
    (arguments
     (list #:modules '((guix build utils))
           #:builder
           #~(begin
               (use-modules (guix build utils))
               (let ((brcm-dir (string-append #$output "/lib/firmware/brcm/"))
                     (cyp-dir  (string-append #$output "/lib/firmware/cypress/")))
                 (mkdir-p brcm-dir)
                 (mkdir-p cyp-dir)
                 (copy-file #$source (string-append brcm-dir "brcmfmac43430-sdio.txt"))
                 (symlink "brcmfmac43430-sdio.txt"
                          (string-append brcm-dir "brcmfmac43430-sdio.rockchip,rk3566-tspi.txt"))
                 (copy-file #$source (string-append cyp-dir "cyfmac43430-sdio.txt"))))))
    (home-page "")
    (synopsis "NVRAM configuration for AP6212 Wi-Fi module")
    (description "Board-specific NVRAM configuration for AP6212 on TSPi.")
    (license #f)))

;; 信道/校准地图。缺它时 dmesg 报 "no clm_blob available ... limited channels"，
;; 扫描会受限甚至 -52(ENETDOWN)。
(define-public brcmfmac43430-clm-blob
  (single-firmware-package
   "brcmfmac43430-clm-blob" "1.0"
   (string-append %linux-firmware-base "/cypress/cyfmac43430-sdio.clm_blob")
   "M3a5ybMtFr92LiHH+vtmU2UHCuJA0JJJjQ0Zh8IgIqo="
   "brcm/brcmfmac43430-sdio.clm_blob"))

(define-public bcm43438a1-bt-firmware
  (single-firmware-package
   "bcm43438a1-bt-firmware" "1.0"
   (string-append %armbian-firmware-base "/ap6212/bcm43438a1.hcd")
   "05aRKqTvp+Dqk9xrY7EIhhm1lnarU0BNFP559ccaXaA="
   "brcm/BCM43430A1.hcd"))

(define u-boot-tspi
  (let ((base (make-u-boot-package "lckfb-tspi-rk3566" "aarch64-linux-gnu")))
    (package
      (inherit base)
      (arguments
       (substitute-keyword-arguments (package-arguments base)
         ((#:phases phases)
          #~(modify-phases #$phases
              (add-after 'unpack 'set-environment
                (lambda* (#:key inputs #:allow-other-keys)
                  (setenv "BL31" (search-input-file inputs "/bl31.elf"))
                  (setenv "ROCKCHIP_TPL"
                          (search-input-file inputs "/bin/rk3568_ddr_1560MHz_v1.25.bin"))))))))
      (inputs
       (modify-inputs (package-inputs base)
         (append arm-trusted-firmware-rk3568
                 rk3568-ddr-bin))))))

(define u-boot-tspi-bootloader
  (bootloader
    (inherit u-boot-bootloader)
    (package u-boot-tspi)
    (disk-image-installer
     #~(lambda (bootloader _ image)
         (let ((idbloader (string-append bootloader "/libexec/idbloader.img"))
               (itb (string-append bootloader "/libexec/u-boot.itb")))
           (write-file-on-device idbloader
                                 (stat:size (stat idbloader))
                                 image
                                 32768)
           (write-file-on-device itb
                                 (stat:size (stat itb))
                                 image
                                 8388608))))))

;; 2. 内核定制：适配 RK3566 与网关/路由配置。
;;    基于 nonguix 的 vanilla（非 deblob）内核，以便加载 AP6212 等非自由固件。
(define-public linux-tspi
  (let* ([configs `(["CONFIG_NF_TABLES"               . #t]
                    ["CONFIG_NETFILTER_NETLINK_QUEUE" . #t]
                    ["CONFIG_NF_CONNTRACK"            . #t]
                    ["CONFIG_NF_CONNTRACK_MARK"       . #t]
                    ["CONFIG_NF_TABLES_INET"          . #t]
                    ["CONFIG_NF_TABLES_NETDEV"        . #t]
                    ["CONFIG_NFT_NUMGEN"              . #t]
                    ["CONFIG_NFT_CT"                  . #t]
                    ;; NFT_FLOW_OFFLOAD 依赖 NF_FLOW_TABLE
                    ["CONFIG_NF_FLOW_TABLE"           . #t]
                    ["CONFIG_NFT_FLOW_OFFLOAD"        . #t]
                    ["CONFIG_NFT_MASQ"                . #t]
                    ["CONFIG_NFT_REDIR"               . #t]
                    ["CONFIG_NFT_NAT"                 . #t]
                    ["CONFIG_NF_NAT"                  . #t]

                    ;; 泰山派板载网卡及通用外设支持 (STMMAC / Realtek)
                    ["CONFIG_STMMAC_ETH"              . #t]
                    ["CONFIG_DWMAC_ROCKCHIP"          . #t]
                    ["CONFIG_R8169"                   . #t]
                    ["CONFIG_MOTORCOMM_PHY"           . #t] ; 某些 RK3566 板子使用的 YT8521/8531 系列 PHY

                    ["CONFIG_PPP"                     . #t]
                    ["CONFIG_PPPOE"                   . #t]

                    ["CONFIG_NET"                     . #t]
                    ["CONFIG_RFKILL"                  . #t]
                    ["CONFIG_NETLINK_DIAG"            . #t]
                    ["CONFIG_WIRELESS"                . #t]
                    ["CONFIG_CFG80211"                . #t]
                    ["CONFIG_MAC80211"                . m]
                    ["CONFIG_BRCMUTIL"                . m]
                    ["CONFIG_BRCMFMAC"                . m]
                    ["CONFIG_BRCMFMAC_SDIO"           . #t]

                    ;; AP6212 蓝牙（主线 hci_uart + btbcm）
                    ["CONFIG_BT"                      . m]
                    ["CONFIG_BT_HCIUART"              . m]
                    ["CONFIG_BT_HCIUART_H4"           . #t]
                    ["CONFIG_BT_HCIUART_BCM"          . #t]

                    ;; SDIO（WiFi 模块挂载于 mmc 控制器）
                    ["CONFIG_MMC"                     . #t]
                    ["CONFIG_MMC_SDHCI"               . #t]
                    ["CONFIG_MMC_SDHCI_OF_DWCMSHC"    . #t]

                    ;; 媒体：rkvdec 硬解（HEVC/H.264，arm64 defconfig 未包含）
                    ["CONFIG_VIDEO_ROCKCHIP_VDEC"     . m]

                    ;; 声卡：RK809 codec + I2S（模拟音频 / HDMI 音频）
                    ;; 7.1 里 SND_SOC 是 tristate（SND=m 时只能 =m）；
                    ;; 机器驱动 SND_SOC_ROCKCHIP 已移除（simple-audio-card 不需要它）
                    ["CONFIG_SND"                      . m]
                    ["CONFIG_SND_SOC"                  . m]
                    ["CONFIG_SND_SOC_ROCKCHIP_I2S_TDM" . m]
                    ["CONFIG_SND_SOC_RK817"            . m]
                    ["CONFIG_SND_SIMPLE_CARD"          . m]

                    ;; SATA（combphy 走 AHCI-DWC）
                    ["CONFIG_ATA"                     . #t]
                    ["CONFIG_SATA_AHCI"               . m]
                    ["CONFIG_AHCI_DWC"                . m]

                    ;; iptables（xtables 兼容层，路由器常用工具依赖）。
                    ;; 7.1 拆分了 legacy 层：IP_NF_* 子表依赖 *_IPTABLES_LEGACY
                    ["CONFIG_NETFILTER_XTABLES_LEGACY"       . #t]
                    ["CONFIG_IP_NF_IPTABLES_LEGACY"          . m]
                    ["CONFIG_IP6_NF_IPTABLES_LEGACY"         . m]
                    ["CONFIG_NETFILTER_XT_MATCH_ADDRTYPE"    . m]
                    ["CONFIG_NETFILTER_XT_MATCH_COMMENT"     . m]
                    ["CONFIG_NETFILTER_XT_MATCH_CONNTRACK"   . m]
                    ["CONFIG_NETFILTER_XT_MATCH_STATE"       . m]
                    ["CONFIG_NETFILTER_XT_MATCH_TCPMSS"      . m]
                    ["CONFIG_NETFILTER_XT_TARGET_MASQUERADE" . m]
                    ["CONFIG_NETFILTER_XT_TARGET_REDIRECT"   . m]
                    ["CONFIG_NETFILTER_XT_TARGET_LOG"        . m]
                    ["CONFIG_IP_NF_IPTABLES"          . m]
                    ["CONFIG_IP_NF_FILTER"            . m]
                    ["CONFIG_IP_NF_NAT"               . m]
                    ["CONFIG_IP_NF_MANGLE"            . m]
                    ["CONFIG_IP_NF_TARGET_MASQUERADE" . m]
                    ["CONFIG_IP6_NF_IPTABLES"         . m]
                    ["CONFIG_IP6_NF_FILTER"           . m]
                    ["CONFIG_IP6_NF_NAT"              . m]
                    ["CONFIG_IP6_NF_MANGLE"           . m]

                    ;; PPP 补充
                    ["CONFIG_PPP_ASYNC"               . #t]
                    ["CONFIG_PPP_SYNC_TTY"            . #t]
                    ["CONFIG_PPP_DEFLATE"             . #t]
                    ["CONFIG_PPP_MPPE"                . #t]
                    ["CONFIG_PPP_MULTILINK"           . #t]

                    ;; USB gadget（把板子当 USB 网卡/串口用，无网时接入）。
                    ;; 7.1 的 configfs 功能符号不带 F_ 前缀（defconfig 已默认 =y）
                    ["CONFIG_USB_GADGET"              . #t]
                    ["CONFIG_USB_CONFIGFS"            . m]
                    ["CONFIG_USB_CONFIGFS_ECM"        . #t]
                    ["CONFIG_USB_CONFIGFS_RNDIS"      . #t]
                    ["CONFIG_USB_CONFIGFS_EEM"        . #t]
                    ["CONFIG_USB_CONFIGFS_SERIAL"     . #t]
                    ["CONFIG_USB_CONFIGFS_ACM"        . #t]
                    ["CONFIG_USB_CONFIGFS_F_FS"       . #t]
                    ["CONFIG_USB_ETH"                 . m] ; g_ether

                    ;; USB 有线网卡（无板载网口时的联网兜底）
                    ["CONFIG_USB_NET_CDCETHER"        . m]
                    ["CONFIG_USB_NET_AX8817X"         . m]
                    ["CONFIG_USB_RTL8152"             . m] ; 7.1 起改名为 USB_RTL8152
                    ["CONFIG_USB_ACM"                 . m]

                    ;; 其它
                    ["CONFIG_INPUT_UINPUT"            . m])]
         [base (customize-linux
                 #:linux nonguix:linux-arm64-generic
                 #:extra-version "arm64-tspi"
                 #:configs (configs->strings configs))])
    (package
      (inherit base)
      (name "linux-tspi"))))

(define tspi-barebones-os
  (operating-system
    (host-name "tspi")
    (timezone "Asia/Shanghai")
    (locale "en_US.utf8")
    (bootloader (bootloader-configuration
                  (bootloader u-boot-tspi-bootloader)
                  (targets '("/dev/mmcblk0"))))

    (initrd-modules
      (list "dwmac_rk"
            "stmmac_platform"
            "stmmac"
            "pcs_xpcs"
            "phy_rockchip_inno_usb2"
            "phy_rockchip_naneng_combphy"
            "rockchip_thermal"))

    (kernel linux-tspi)

    (kernel-arguments
      (list "console=ttyS2,1500000n8"
            "modprobe.blacklist=usbmouse,usbkbd"
            "quiet"))

    ;; 板载 WiFi/蓝牙固件（通过 firmware-service-type 挂载到 /lib/firmware）。
    ;; AP6212 是博通方案；rtl8723ds 固件保留给其他硬件版本。
    ;; wireless-regdb 提供 regulatory.db（否则 cfg80211 报加载失败，WiFi 只能跑世界域）。
    (firmware (cons* brcmfmac43430-sdio-firmware
                     brcmfmac43430-board-config
                     brcmfmac43430-clm-blob
                     bcm43438a1-bt-firmware
                     wireless-regdb
                     rtw88-rtw8723d-firmware
                     rtl8723ds-bt-firmware
                     rtl8723ds-bt-config
                     %base-firmware))

    (file-systems (cons (file-system
                          (device (file-system-label "ROOT"))
                          (mount-point "/")
                          (type "ext4"))
                        %base-file-systems))

    (services
      (cons* (service dhcpcd-service-type)
             (service ntp-service-type)
             %base-services))
    (locale-definitions (list (locale-definition
                                (name "en_US.utf8") (source "en_US"))))))

;; 4. Rockchip 镜像偏置配置（RK3566 引导通常需要 16MiB 偏置预留给 SPL/U-Boot）
(define tspi-image-type
  (image-type (name 'tspi-raw)
              (constructor (lambda (os)
                             (image (inherit (raw-with-offset-disk-image (expt 2 24))) ; 16MiB
                                    (name 'tspi-disk-image)
                                    (operating-system os)
                                    (platform aarch64-linux))))))

(define tspi-barebones-raw-image
  (image (inherit (os+platform->image tspi-barebones-os
                                      aarch64-linux
                                      #:type tspi-image-type))
         (name 'tspi-barebones-raw-image)))

tspi-barebones-raw-image
