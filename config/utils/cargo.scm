(define-module (config utils cargo)
  #:use-module (srfi srfi-26) ; cut
  #:use-module (guix build-system cargo)
  #:export (cargo-inputs*))

(define cargo-inputs*
  (cut cargo-inputs <> #:module '(config packages rust-crates)))

