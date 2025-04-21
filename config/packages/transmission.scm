(define-module (config packages transmission)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages bittorrent)
  #:export (transmission*))

(define-public transmission*
 (package (inherit transmission)
   (name "transmission")
   (version "4.1.0-beta.2")
   (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/transmission/transmission")
              (commit "4.1.0-beta.2")
              (recursive? #t)))
       (file-name (git-file-name name version))
       (sha256
         (base32
           "1lgip9vd8d3kw9dy9nizg67ga0i888ikqjpzzznsbzsh0dg6aq3q"))))))
