(use-modules (guix profiles)
             (guix gexp))

(define %base-manifest
  (packages->manifest
    (list)))

(define (hello-manifest-entry name expr)
  (let [(prog (program-file name expr))]
    (manifest-entry
      (name name)
      (version "0.0.0")
      (item
        (computed-file
          (string-append name "-directory")
          #~(let [(bin (string-append #$output "/bin"))]
              (mkdir #$output) (mkdir bin)
              (symlink #$prog (string-append bin "/" #$name))))))))

(manifest-add %base-manifest
              (list (hello-manifest-entry "hello"
                                          #~(begin
                                              (display "Hi")
                                              (newline)
                                              (format #t "I got ~a~%!" (read))))))

