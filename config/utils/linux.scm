(define-module (config utils linux)
  #:use-module (ice-9 match)
  #:export (configs->strings))

(define (configs->strings options)
  "Convert OPTIONS, an alist mapping kernel CONFIG symbols to values, to the
list of @code{CONFIG_FOO=y} strings expected by @code{customize-linux}."
  (map (match-lambda
         ((option . 'm)     (string-append option "=m"))
         ((option . #t)     (string-append option "=y"))
         ((option . #f)     (string-append option "=n"))
         ((option . string) (string-append option "=\"" string "\"")))
       options))
