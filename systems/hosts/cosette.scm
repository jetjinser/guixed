(define-module (systems hosts cosette)
  #:use-module (gnu)
  #:use-module (gnu services desktop)
  #:use-module (gnu services shepherd)
  #:use-module (systems base)
  #:use-module (config services avahi-publish)
  #:use-module (rosenthal services networking)
  #:use-module (rosenthal services monitoring)
  #:use-module (rosenthal services bittorrent)
  #:use-module (gnu system accounts)
  #:use-module (gnu packages monitoring)
  #:use-module (gnu services monitoring)
  #:use-module (gnu services containers)
  #:export (%cosette))

(use-service-modules file-sharing sysctl networking ssh upnp avahi dns virtualization samba
                     databases)
(use-package-modules bootloaders ssh shells databases)

(define +immich-ver+ "v3.0.1")
(define immich-service
  (simple-service 'immich-provisioning
    oci-service-type
    (oci-extension
      (networks
        (list
          (oci-network-configuration (name "immich-net"))))
      (volumes
        (list
          (oci-volume-configuration (name "immich-model-cache"))
          (oci-volume-configuration (name "immich-db-data"))
          (oci-volume-configuration (name "immich-server-data"))))
      (containers
        (list
          (oci-container-configuration
            (network "immich-net")
            (image   (string-append "ghcr.io/immich-app/immich-server" ":" +immich-ver+))
            (provision "immich-server")
            (requirement '[immich-db immich-kv immich-machine-learning])
            (ports '(("2283" . "2283")))
            (auto-start? #t)
            (respawn? #t)
            (volumes
              '(("immich-server-data" . "/data")))
            (environment
              '(("DB_HOSTNAME"      . "immich-db")
                ("DB_PORT"          . "5432")
                ("DB_USERNAME"      . "immich")
                ("DB_PASSWORD"      . "internal")
                ("DB_DATABASE_NAME" . "immich")
                ("REDIS_HOSTNAME"   . "immich-kv")
                ("REDIS_PORT"       . "6379"))))
          (oci-container-configuration
            (network "immich-net")
            (image   (string-append "ghcr.io/immich-app/immich-machine-learning" ":" +immich-ver+))
            (provision "immich-machine-learning")
            (auto-start? #t)
            (respawn? #t)
            (volumes
              '(("immich-model-cache" . "/cache"))))
          (oci-container-configuration
            (network "immich-net")
            (image   "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23")
            (provision "immich-db")
            (auto-start? #t)
            (respawn? #t)
            (environment
              '(("POSTGRES_PASSWORD"    . "internal")
                ("POSTGRES_USER"        . "immich")
                ("POSTGRES_DB"          . "immich")
                ("POSTGRES_INITDB_ARGS" . "--data-checksums")))
            (volumes
              '(("immich-db-data" . "/var/lib/postgresql/data"))))
          (oci-container-configuration
            (network "immich-net")
            (image   "docker.io/valkey/valkey:9@sha256:4963247afc4cd33c7d3b2d2816b9f7f8eeebab148d29056c2ca4d7cbc966f2d9")
            (provision "immich-kv")
            (auto-start? #t)
            (respawn? #t)))))))

(define pbh-service
  (simple-service 'pbh-provisioning
    oci-service-type
    (oci-extension
      (containers
        (list
          (oci-container-configuration
            (network     "host")
            (image       "registry.cn-hangzhou.aliyuncs.com/ghostchu/peerbanhelper:latest")
            (provision   "pbh")
            (auto-start? #t)
            (respawn?    #t)
            (volumes
              '(("/var/lib/pbh" . "/app/data")))))))))

(define %qbittorrent-config-file
  (local-file "cosette/qbittorrent.conf"))
(define qbittorrent-config-activation
  #~(begin
      (use-modules (srfi srfi-1)
                   (srfi srfi-26)
                   (guix build utils))
      (let* ((user (getpwnam "qbittorrent"))
             (uid (passwd:uid user))
             (gid (passwd:gid user))
             (profile-dir "/var/lib/qbittorrent")
             (config-dir  (string-append profile-dir "/qBittorrent/config"))
             (cache-dir   (string-append profile-dir "/qBittorrent/cache"))
             (target-file (string-append config-dir "/qBittorrent.conf")))

        (mkdir-p config-dir)
        (mkdir-p cache-dir)

        (unless (file-exists? target-file)
          (copy-file #$%qbittorrent-config-file target-file))

        (chown profile-dir uid gid)
        (for-each
         (cut chown <> uid gid)
         (find-files profile-dir #:directories? #t)))))
(define qbittorrent-service
  (service qbittorrent-service-type
    (qbittorrent-configuration
      (webui-port 9001))))

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
                                             ("root"   ,dorothy ,cosette))))
                                       (port-number 22)))
                            (service avahi-service-type
                                     (avahi-configuration
                                       (host-name host-name)
                                       (wide-area? #t)))
                            (service avahi-publish-service-type
                                     (avahi-publish-configuration))
                            qbittorrent-service
                            (simple-service 'qbittorrent-config-activation
                              activation-service-type
                              qbittorrent-config-activation)
                            (service readymedia-service-type
                                     (readymedia-configuration
                                       (friendly-name "cosette-landing")
                                       (port 9002)
                                       (media-directories
                                         (list (readymedia-media-directory (path "/srv/store/pv")
                                                                           (types '(P V)))
                                               (readymedia-media-directory (path "/srv/store/v")
                                                                           (types '(V)))))))
                            (service samba-service-type
                                     (samba-configuration
                                       (enable-smbd? #t)
                                       (config-file (plain-file "smb.conf" "
[global]
    server role = standalone server
    map to guest = Never
    logging = syslog@1
[srv]
comment = Read Only Srv Directory
path = /srv
browseable = yes
read only = yes
guest ok = no
valid users = jinser"))))
                            ; (service wsdd-service-type
                            ;          (wsdd-configuration
                            ;            (chroot #t)))
                            (service tailscale-service-type
                                     (tailscale-configuration
                                       (extra-options '("-port" "41641"))))
                            (service postgresql-service-type
                                     (postgresql-configuration
                                       (postgresql postgresql)))
                            ; (service prometheus-node-exporter-service-type
                            ;          (prometheus-node-exporter-configuration
                            ;            (package prometheus-node-exporter)
                            ;            (web-listen-address "cosette:9100")
                            ;            (textfile-directory "/var/lib/prometheus-node-exporter")))
                            ; (service prometheus-service-type
                            ;          (prometheus-configuration
                            ;            (listen-address "cosette:9090")
                            ;            (shepherd-requirement '(tailscaled))
                            ;            (config
                            ;              #~'(("global"
                            ;                    ("scrape_interval" . "15s")
                            ;                    ("evaluation_interval" . "15s"))
                            ;                  ("scrape_configs" . #((("job_name"       . "~node")
                            ;                                         ("static_configs" . #((("targets" . #("herb:9100"))
                            ;                                                                ("labels"  . (("nodename" . "herb"))))
                            ;                                                               (("targets" . #("cosette:9100"))
                            ;                                                                ("labels"  . (("nodename" . "cosette")))))))
                            ;                                        (("job_name"        . "~tailscale-metrics")
                            ;                                         ("scrape_interval" . "30s")
                            ;                                         ("static_configs"  . #((("targets" . #("cosette:5252"))
                            ;                                                                 ("labels"  . (("hostname" . "cosette"))))
                            ;                                                                (("targets" . #("herb:5252"))
                            ;                                                                 ("labels"  . (("hostname" . "herb")))))))
                            ;                                        (("job_name"        . "~dns")
                            ;                                         ("scrape_interval" . "15s")
                            ;                                         ("static_configs"  . #((("targets" . #("herb:15354"))
                            ;                                                                 ("labels"  . (("hostname" . "herb")))))))
                            ;                                        (("job_name"        . "~mtail")
                            ;                                         ("scrape_interval" . "15s")
                            ;                                         ("static_configs"  . #((("targets" . #("herb:13903"))
                            ;                                                                 ("labels"  . (("hostname" . "herb")))))))
                            ;                                        (("job_name"        . "~caddy")
                            ;                                         ("scrape_interval" . "15s")
                            ;                                         ("static_configs"  . #((("targets" . #("100.115.6.12:2019")) ; herb
                            ;                                                                 ("labels"  . (("hostname" . "herb")))))))))))))
                            ; (service grafana-service-type
                            ;          (grafana-configuration
                            ;            (postgresql-password-file
                            ;              (local-file-absolute-file-name (local-file "cosette/password-file.txt")))
                            ;            (config
                            ;              #~'(("paths"
                            ;                   ("data" . "/var/lib/grafana")
                            ;                   ("logs" . "/var/log/grafana")
                            ;                   ("http_addr" . "cosette"))))))
                            (simple-service 'guix-moe guix-service-type
                              (guix-extension
                                (authorized-keys
                                 (list (plain-file "guix-moe-old.pub"
                                         "(public-key (ecc (curve Ed25519) (q #374EC58F5F2EC0412431723AF2D527AD626B049D657B5633AAAEBC694F3E33F9#)))")
                                       ;; 2025-10-29 起用的新公鑰
                                       (plain-file "guix-moe.pub"
                                         "(public-key (ecc (curve Ed25519) (q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))")
                                       (plain-file "dorothy.pub"
                                         "(public-key (ecc (curve Ed25519) (q #C4167FEBE89D1D5E4BC4AE1B01892E4E15008A392AAA3B02B291CFA6D39385E2#)))")))
                                (substitute-urls
                                 '("https://cache-cdn.guix.moe"
                                   "https://mirror.sjtu.edu.cn/guix"
                                   "https://mirror.sjtu.edu.cn/guix-bordeaux"))))
                            (service qemu-binfmt-service-type
                              (qemu-binfmt-configuration
                                (platforms (lookup-qemu-platforms "aarch64" "riscv64"))))
                            (service elogind-service-type)

                            (service rootless-podman-service-type
                              (rootless-podman-configuration
                                (subgids
                                 (list (subid-range (name "jinser"))))
                                (subuids
                                 (list (subid-range (name "jinser"))))))
                            (service oci-service-type
                              (oci-configuration
                                (runtime 'podman)))
                            (simple-service 'oci-limits pam-limits-service-type
                              (list
                                (pam-limits-entry "oci-container" 'both 'nofile 65536)))

                            pbh-service
                            immich-service)
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
