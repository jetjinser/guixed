(use-modules (config systems mizuki)
             (gnu machine)
             (gnu machine ssh))

(list
  (machine (operating-system %mizuki)
           (environment managed-host-environment-type)
           (configuration (machine-ssh-configuration
                            (host-name "localhost")
                            (port 22222)
                            (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE4zsw+nWWhcuSqUbE7EispZO6vtCl2CACqdEV6LEhJi")
                            (system "aarch64-linux")
                            (user "root")
                            (identity "/home/jinser/.ssh/id_ed25519")))))


