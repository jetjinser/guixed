(use-modules (gnu machine)
             (gnu machine ssh)
             (guix gexp)
             (rnrs io ports)
             (systems hosts cosette))

(define cosette
  (call-with-input-file "assets/keys/cosette.host.pub" get-string-all))

(list (machine
        (operating-system %cosette)
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration
                         (host-name "localhost")
                         (system "x86_64-linux")
                         (user "jinser")
                         (host-key cosette)))))
