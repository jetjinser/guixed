(define-module (config utils secrets)
  #:use-module (ice-9 textual-ports)
  #:use-module (srfi srfi-13)
  #:export (read-secret))

;; Minimum viable secret handling: real values live in the git-ignored
;; `secrets/' directory and are read at configuration-evaluation time.
;; The trade-off is that the value ends up in the world-readable store;
;; replace with sops-guix (`sops-secrets-service-type') when ready.
(define (read-secret file-name)
  "Return the single-line secret stored in FILE-NAME, relative to the
current working directory."
  (string-trim-both
   (call-with-input-file file-name get-string-all)))
