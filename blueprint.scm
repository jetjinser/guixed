;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

;;; Based on Hilton's blueprint.scm

(use-modules (ice-9 match)
             (ice-9 threads)
             (srfi srfi-1)
             (srfi srfi-26) ; cut(e)
             (blue build)
             (blue computation)
             (blue subprocess)
             (blue types blueprint)
             (blue types command)
             (blue types configuration)
             (blue types variable))

(define-syntax %build-options
  (identifier-syntax (build-options)))


(define (build-options)
  `("--keep-failed"
    "--keep-going"
    "--verbosity=1"))

(define (print-header header target)
  (format (current-output-port) "\t~a\t~a\n" header target))

(define ($ cmd)
  (match cmd
    ((prog . args)
     (let ((exit-val (popen prog args)))
       (zero? exit-val)))))

(define* ($guix args #:key (channels "channels.scm") #:allow-other-keys)
  ($ `("guix" "time-machine" "-C" ,channels "--" ,@args)))

;; TODO: figure it out
(define-command (update-command arguments)
  ((invoke "update")
   (category 'development)
   (synopsis "Update channels.scm to latest channel revisions"))
  ($guix `("repl" "--" "scripts/write-channels.scm") #:channels "channels.scm"))

;; TODO: figure it out
(define-command (deploy-os-command arguments)
  ((invoke "deploy-os")
   (category 'deployment)
   (synopsis "Deploy Guix System")
   (help "[SYSTEMS] ...
Deploy all Guix Systems in this repository or only those matching SYSTEMS."))
  (every
    (cut eq? #t <>)
    (map (match-lambda
           ((name . args)
            (let ((config (string-append "deploy/" name ".scm")))
              (print-header "DEPLOY OS" name)
              (apply $guix
                     `("deploy" ,config
                       ,@(if #%?CMD
                             `(,@%build-options "-x" "--" "sh" "--login" "-c" ,#%?CMD)
                             %build-options))
                     args))))
         `(("herb")))))

;; temporary
(define-command (run-command arguments)
  ((invoke "run")
   (category 'development)
   (synopsis "Run any guix command in time-machine"))
  (match arguments
    ((command . args)
     (apply system* "guix" "time-machine" "-C" "channels.scm" "--"
                    command "-L" "." args))))

(blueprint
  (configuration
    (configuration
     (variables
      (list (variable
             (name "CMD")
             (value #f)
             (hint "Deployment command for 'guix deploy'"))))))
  (commands
    (list update-command
          deploy-os-command

          run-command)))
