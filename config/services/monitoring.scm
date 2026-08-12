(define-module (config services monitoring)
  #:use-module (guix records)
  #:use-module (guix gexp)
  #:use-module (gnu system shadow)
  #:use-module (gnu packages admin)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services configuration)
  #:use-module (config packages monitoring)
  #:export (mtail-service-type
            mtail-configuration))

(define %mtail-accounts
  (list (user-group (name "mtail") (system? #t))
        (user-account
          (name "mtail")
          (group "mtail")
          (system? #t)
          (comment "mtail log metrics exporter")
          (home-directory "/var/empty")
          (shell (file-append shadow "/sbin/nologin")))))

(define-record-type* <mtail-configuration>
  mtail-configuration make-mtail-configuration
  mtail-configuration?
  (mtail     mtail-configuration-mtail
             (default mtail))
  (progs-dir mtail-configuration-progs-dir
             (default "/etc/mtail"))
  (logs      mtail-configuration-logs
             (default '()))
  (port      mtail-configuration-port
             (default 3903))
  (user      mtail-configuration-user
             (default "mtail"))
  (group     mtail-configuration-group
             (default "mtail")))

(define (mtail-shepherd-service config)
  (match-record config <mtail-configuration>
    (mtail progs-dir logs port user group)
    (let ((log-args (apply append (map (lambda (log) (list "-logs" log)) logs))))
      (list (shepherd-service
              (provision '(mtail))
              (requirement '(user-processes networking))
              (documentation "Run mtail to extract Prometheus-style metrics from log files.")
              (start #~(make-forkexec-constructor
                         (list (string-append #$mtail "/bin/mtail")
                               "-progs" #$progs-dir
                               #$@log-args
                               "-port" (number->string #$port))
                         #:log-file "/var/log/mtail.log"
                         #:user  #$user
                         #:group #$group))
              (stop #~(make-kill-destructor)))))))

(define mtail-service-type
  (service-type (name 'mtail)
                (extensions (list (service-extension shepherd-root-service-type
                                                     mtail-shepherd-service)
                                  (service-extension account-service-type
                                                     (const %mtail-accounts))))
                (default-value (mtail-configuration))
                (description "Run @command{mtail}, a Google tool for extracting Prometheus-style metrics from application logs.")))

