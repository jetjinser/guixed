(use-modules (systems hosts herb)
             (gnu machine)
             (gnu machine ssh))

(list
  (machine (operating-system %herb)
           (environment managed-host-environment-type)
           (configuration (machine-ssh-configuration
                            (host-name "herb")
                            (port 2222)
                            (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMMtJYnyMfpaN2D5VxoMMzC6PhcH1bBdwPAfNhu3C5p")
                            (system "aarch64-linux")
                            (user "root")
                            (identity "/home/jinser/.ssh/id_ed25519")))))

