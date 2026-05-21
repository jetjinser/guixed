(use-modules (guix packages)
             (guix profiles)
             (bluebox packages blue)
             (gnu packages)
             (gnu packages guile))

(define blue/guile-latest
  (package
    (inherit blue)
    (inputs
     (modify-inputs inputs
       (replace "guile" guile-3.0-latest)))))

(concatenate-manifests
 (list (packages->manifest
         (list blue/guile-latest))
       (specifications->manifest
        (list "sops"))))

