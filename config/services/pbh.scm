(define-module (config services pbh)
  #:use-module (pkgs pbh)
  #:use-module (gnu services)
  #:use-module (gnu services admin)
  #:use-module (gnu services configuration)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system shadow)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages java)
  #:use-module (guix gexp)
  #:export (pbh-daemon-service-type
            pbh-daemon-configuration))

(define %pbh-daemon-user "pbh")
(define %pbh-daemon-group "pbh")

(define %pbh-daemon-configuration-directory
  "/var/lib/pbh")
(define %pbh-daemon-log-file
  "/var/log/pbh.log")

(define-configuration pbh-daemon-configuration
  (pbh
    (file-like pbh)
    "The PeerBanHelper package to use."))

(define (pbh-daemon-shepherd-service config)
  "Return a <shepherd-service> for PBH Daemon with CONFIG."
  (let [(pbh (pbh-daemon-configuration-pbh config))
        (java openjdk21)]
    (list
      (shepherd-service
        (provision '(pbh))
        (requirement '(user-processes networking transmission))
        (documentation "PeerBanHelper")
        (start #~(make-forkexec-constructor
                   '(java "-Xmx512M" "-XX:+UseG1GC" "-XX:+UseStringDeduplication"
                     "-XX:+ShrinkHeapInSteps" "-jar"
                     #$(file-append pbh "PeerBanHelper.jar"))
                   #:user #$%pbh-daemon-user
                   #:group #$%pbh-daemon-group
                   #:directory #$%pbh-daemon-configuration-directory
                   #:log-file #$%pbh-daemon-log-file))
        (stop #~(make-kill-destructor))))))

(define %pbh-daemon-accounts
  (list (user-group
         (name %pbh-daemon-group)
         (system? #t))
        (user-account
         (name %pbh-daemon-user)
         (group %pbh-daemon-group)
         (comment "Transmission Daemon service account")
         (home-directory %pbh-daemon-configuration-directory)
         (shell (file-append shadow "/sbin/nologin"))
         (system? #t))))

(define pbh-daemon-service-type
  (service-type
    (name 'pbh)
    (extensions
      (list (service-extension shepherd-root-service-type
                                pbh-daemon-shepherd-service)
            (service-extension account-service-type
                               (const %pbh-daemon-accounts))))
    (default-value (pbh-daemon-configuration))
    (description "BitTorrent PeerBanHelper")))
