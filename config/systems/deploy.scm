(define-module (config systems deploy)
  #:use-module (gnu machine)
  #:use-module (gnu machine ssh)
  #:use-module (guix gexp)
  #:use-module (rnrs io ports)
  #:use-module (config systems cosette))

(define cosette
  (call-with-input-file "../../files/cosette.pub" get-string-all))

(list (machine
        (operating-system %cosette)
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration
                         (host-name "localhost")
                         (system "x86_64-linux")
                         (user "jinser")
                         (host-key cosette)))))
