(define-module (config packages monitoring)
  #:use-module (ice-9 match)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system go)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages c)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages web)
  #:use-module (rosenthal utils download))

(define-syntax-rule (alist->cmake-flags alist)
  (map (match-lambda
         [(flag . #t)
          (string-append "-D" (symbol->string flag) "=On")]
         [(flag . #f)
          (string-append "-D" (symbol->string flag) "=Off")]
         [(flag . string)
          (string-append flag "=\"" string "\"")])
       alist))

;; XXX: cursed for embedded
; (define-public fluent-bit
;   (package
;     (name "fluent-bit")
;     (version "5.0.6")
;     (source
;      (origin
;        (method git-fetch)
;        (uri (git-reference
;              (url "https://github.com/fluent/fluent-bit")
;              (commit (string-append "v" version))))
;        (file-name (git-file-name name version))
;        (sha256
;         (base32 "1pqk8d6vir8ddkkq7jfhgp8kyq2r6wkz7988xqfjy5nr8hbzaxsm"))))
;     (build-system cmake-build-system)
;     (arguments
;      (list
;        #:tests? #f
;        ; #:build-type "Release"
;        #:configure-flags
;        #~(list #$@
;                (alist->cmake-flags
;                  '(; (FLB_RELEASE          . #t)
;                    (FLB_SMALL            . #t)
;                    (FLB_JEMALLOC         . #f)
;                    (FLB_STREAM_PROCESSOR . #f)
;                    (FLB_WASM             . #f)
;                    (FLB_SHARED_LIB       . #f)
;
;                    (FLB_MINIMAL          . #t)
;
;                    (FLB_LUAJIT           . #f)
;                    (FLB_ARROW            . #f)
;                    (FLB_AVRO_ENCODER     . #f)
;                    (FLB_AWS              . #t)
;                    (FLB_CONFIG_YAML      . #t)
;                    (FLB_CUSTOM_CALYPTIA  . #f)
;                    (FLB_EXAMPLES         . #f)
;                    (FLB_HTTP_SERVER      . #t)
;                    (FLB_INOTIFY          . #f)
;                    (FLB_KAFKA            . #f)
;                    (FLB_PROXY_GO         . #f)
;                    (FLB_SIGNV4           . #f)
;                    (FLB_SIMD             . #t)
;                    (FLB_ZIG              . #f))))))
;     (native-inputs
;      (list pkg-config bison flex libyaml))
;     (inputs
;      (list openssl zlib yyjson nghttp3))
;     (home-page "https://fluentbit.io/")
;     (synopsis "Fast and lightweight log processor and aggregator")
;     (description
;      "Fluent Bit is a fast, light and multi-platform Log Processor and Forwarder
; for Linux, Embedded Linux, MacOS and BSD family operating systems.  It has been
; designed with performance and low resource consumption in mind.")
;     (license license:asl2.0)))

(define-public mtail
  (package
    (name "mtail")
    (version "3.0.8")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/google/mtail")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1vimwg5d1mcx4vpyk4xb5jy7xc28vqjw4az9yr1a36lhkz2x5ani"))))
    (build-system go-build-system)
    (arguments
      (list
        #:go go-1.26
        #:install-source? #f
        #:import-path "."
        #:build-flags
          #~(list (string-append
                   "-ldflags="
                   " -X main.Branch=main"
                   " -X main.Version="
                   #$(package-version this-package)
                   " -X main.Revision="
                   #$(string-append "v" (package-version this-package))))
        #:modules
        '((ice-9 match)
          ((guix build gnu-build-system) #:prefix gnu:)
          (guix build go-build-system)
          (guix build utils))
        #:phases
        #~(modify-phases %standard-phases
            (replace 'unpack
              (lambda args
                (unsetenv "GO111MODULE")
                (apply (assoc-ref gnu:%standard-phases 'unpack) args)
                (copy-recursively
                 #+(this-package-native-input "vendored-go-dependencies")
                 "vendor")))
            (replace 'install-license-files
              (assoc-ref gnu:%standard-phases 'install-license-files))
            (replace 'build
              (lambda* (#:key build-flags parallel-build? #:allow-other-keys)
                (let* ((njobs (if parallel-build? (parallel-job-count) 1)))
                  (setenv "GOMAXPROCS" (number->string njobs))
                  (for-each
                   (lambda (pkg)
                     (apply invoke "go" "build" "-ldflags=-s -w" "-trimpath"
                            "-o" (string-append #$output "/bin/" pkg)
                            `(,@build-flags
                              ,(string-append "github.com/google/mtail/cmd/" pkg))))
                   '("mdot"
                     "mfmt"
                     "mgen"
                     "mtail")))))
            (delete 'check)
            (add-after 'install 'check
              (lambda* (#:key tests? #:allow-other-keys)
                (when tests?
                  (for-each
                   (lambda (cmd)
                     (invoke (string-append #$output "/bin/" cmd) "--help"))
                   '("mdot"
                     "mfmt"
                     "mgen"
                     "mtail"))))))))
    (native-inputs
      (list (origin
              (method (go-mod-vendor #:go go-1.26))
              (uri (package-source this-package))
              (file-name "vendored-go-dependencies")
              (sha256
                 (base32
                  "032vrlj4f9gp61447nmpznk3lqiqg3hfs8px5fk5m5wz5x4pwifz")))))
    (home-page "https://github.com/google/mtail")
    (synopsis "Log Extractor")
    (description "Extract internal monitoring data from application logs for collection in a timeseries database")
    (license license:asl2.0)))
