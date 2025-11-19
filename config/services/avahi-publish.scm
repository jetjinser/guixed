(define-module (config services avahi-publish)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (guix records)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 match)
  #:export (avahi-publish-configuration
            avahi-publish-service-type))

(define %publish-script (local-file "../../files/publish.scm"))

(define-record-type* <avahi-publish-configuration>
  avahi-publish-configuration make-avahi-publish-configuration
  avahi-publish-configuration?
  (addresses avahi-publish-configuration-addresses
            (default '())))

(define avahi-publish-shepherd-service
  (match-lambda
    [($ <avahi-publish-configuration> addresses)
     (list (shepherd-service
             (documentation "Publish mDNS records via Avahi")
             (provision '(avahi-publish))
             (requirement '(avahi-daemon))
             (start #~(make-forkexec-constructor
                        (list
                          #$(file-append guile-3.0 "/bin/guile")
                          "-L" #$(file-append guile-avahi "/share/guile/site/3.0")
                          "-C" #$(file-append guile-avahi "/share/guile/site/3.0")
                          #$%publish-script)
                       #:log-file "/var/log/avahi-publish.log"))
             (stop #~(make-kill-destructor))))]))

(define avahi-publish-service-type
  (service-type
    (name 'avahi-publish)
    (description "Publish mDNS records via Avahi")
    (extensions
      (list (service-extension shepherd-root-service-type
                               avahi-publish-shepherd-service)))
    (default-value '())))
