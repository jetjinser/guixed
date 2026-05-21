(define-module (config build noxcaddy)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system go)
  #:use-module (gnu packages golang)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (make-caddy-source
            go-mod-vendor+tidy
            caddy-with-plugins))

;; Semantic Import Versioning
(define (siv-major version)
  "Extract the major version number from a semver string like \"v2.9.1\".
Returns #f if the string does not parse as a valid 'vN...' semver."
  (and (string? version)
       (string-prefix? "v" version)
       (let* ((rest (string-drop version 1))
              (idx (string-index rest (lambda (c) (char=? c #\.)))))
         (and idx
              (let ((major-str (substring rest 0 idx)))
                (string->number major-str))))))

(define (versioned-module-path module-path module-version)
  "Return MODULE-PATH with /v<major> appended if MODULE-VERSION is a
semver tag with major > 1.  Returns MODULE-PATH unchanged for non-semver
versions (commits, branches) or empty version."
  (let ((major (siv-major module-version)))
    (if (and major (> major 1))
        (let ((suffix (format #f "/v~a" major)))
          (if (string-contains module-path suffix)
              module-path
              (string-append module-path suffix)))
        module-path)))

;;;
;;; Source generator: computed-file that produces main.go + go.mod
;;;

(define* (make-caddy-source #:key
                             caddy-version
                             (caddy-module "github.com/caddyserver/caddy")
                             (plugins '()))
  "Return a computed-file containing a minimal Go module source that
imports Caddy core plus the given PLUGINS via blank imports.

PLUGINS is a list of (module-path version) pairs, e.g.:
  '((\"github.com/caddyserver/cloudflare\" . \"v1.0.0\")
    (\"github.com/mholt/caddy-l4\"         . \"v0.0.0-20240101-abcdef\"))

This source is designed to be fed to 'go-mod-vendor' to resolve all
transitive dependencies, producing a vendor/ tree that can be used
in an offline go-build-system build."

  (define (resolve-caddy-path)
    (versioned-module-path caddy-module caddy-version))

  (define (resolve-plugin-path path ver)
    (versioned-module-path path ver))

  (define caddy-import-path (resolve-caddy-path))

  (define plugin-imports
    (map (lambda (p)
           (let ((path (resolve-plugin-path (car p) (cdr p))))
             (format #f "    _ \"~a\"" path)))
         plugins))

  (define plugin-requires
    (map (lambda (p)
           (let ((path (resolve-plugin-path (car p) (cdr p))))
             (format #f "    ~a ~a" path (cdr p))))
         plugins))

  (define main-content
    (string-append
     "package main\n\n"
     "import (\n"
     "    caddycmd \"" caddy-import-path "/cmd\"\n"
     "\n"
     "    _ \"" caddy-import-path "/modules/standard\"\n"
     (string-join plugin-imports "\n")
     "\n"
     ")\n\n"
     "func main() {\n"
     "    caddycmd.Main()\n"
     "}\n"))

  (define go-mod-content
    (string-append
     "module caddy\n\n"
     "go 1.22\n\n"
     "require (\n"
     (format #f "    ~a ~a" caddy-import-path caddy-version)
     "\n"
     (string-join plugin-requires "\n")
     "\n"
     ")\n"))

  (computed-file
   (simple-format #f "caddy-source-~aplugins" (length plugins))
   #~(begin
       (let ((out #$output))
         (mkdir out)
         (call-with-output-file (string-append out "/main.go")
           (lambda (port)
             (display #$main-content port)))
         (call-with-output-file (string-append out "/go.mod")
           (lambda (port)
             (display #$go-mod-content port)))))))

;;;
;;; Modified go-mod-vendor: runs 'go mod tidy' first to create go.sum
;;; before 'go mod vendor'.  The upstream (rosenthal utils download) version
;;; assumes go.sum already exists in the source.
;;;

(define* (go-mod-vendor+tidy #:key go)
  "Like go-mod-vendor, but also runs 'go mod tidy' first to generate
go.sum entries from a bare go.mod (no existing go.sum).

Outputs the ENTIRE resolved module directory (go.mod + go.sum + vendor/),
not just vendor/, because 'go mod tidy' modifies go.mod to add indirect
dependencies that must match vendor/modules.txt for consistent vendoring."
  (lambda* (src hash-algo hash #:optional name #:key (system (%current-system)))
    (define nss-certs
      (module-ref (resolve-interface '(gnu packages nss)) 'nss-certs))

    (gexp->derivation
     (or name "vendored-go-dependencies")
     (with-imported-modules %default-gnu-imported-modules
       #~(begin
           (use-modules (guix build gnu-build-system)
                        (guix build utils))
           (setlocale LC_ALL "C.UTF-8")
           (setenv "SSL_CERT_DIR"
                   #+(file-append nss-certs "/etc/ssl/certs"))

           ((assoc-ref %standard-phases 'unpack) #:source #+src)
           (invoke #+(file-append go "/bin/go") "mod" "tidy")
           (invoke #+(file-append go "/bin/go") "mod" "vendor")
           (copy-recursively "." #$output)))
     #:system system
     #:hash-algo hash-algo
     #:hash hash
     #:recursive? #t
     #:env-vars '(("GOCACHE" . "/tmp/go-cache")
                  ("GOPATH" . "/tmp/go"))
     #:leaked-env-vars '("GOPROXY"
                         "http_proxy" "https_proxy"
                         "LC_ALL" "LC_MESSAGES" "LANG"
                         "COLUMNS")
     #:local-build? #t)))

;;;
;;; caddy-with-plugins
;;;

(define (package->go pkg)
  "Extract the Go compiler package from a go-build-system package's arguments."
  (or (assoc-ref (package-arguments pkg) #:go)
      go))

(define (package->caddy-version pkg)
  (string-append "v" (package-version pkg)))

(define* (caddy-with-plugins #:key
                             (caddy #f)
                             (version #f)
                             (plugins '())
                             (go #f)
                             vendor-hash)
  "Return a package that builds Caddy with the given PLUGINS.

PLUGINS is a list of (module-path version) pairs, e.g.:
  '((\"github.com/caddy-dns/porkbun\"      . \"v0.3.1\")
    (\"github.com/caddyserver/cloudflare\" . \"v1.0.0\"))

There are two usage styles:

  ;; 1. From an existing Caddy package (like Nix's caddy.withPlugins):
  (caddy-with-plugins
    #:caddy caddy            ;; any Caddy package (e.g. from Rosenthal)
    #:plugins '(...)
    #:vendor-hash \"...\")   ;; FOD hash of the resolved dependency tree

  ;; 2. Standalone with explicit version and Go compiler:
  (caddy-with-plugins
    #:version \"v2.11.2\"    ;; Caddy version (with 'v' prefix)
    #:go go-1.26             ;; Go compiler package
    #:plugins '(...)
    #:vendor-hash \"...\")"
  (let* ([go-pkg (or go
                     (and caddy (package->go caddy))
                     (error "either #:go or #:caddy is required"))]
         [caddy-version (or version
                            (and caddy (package->caddy-version caddy))
                            (error "either #:version or #:caddy is required"))]
         [src (make-caddy-source
                #:caddy-version caddy-version
                #:plugins       plugins)])
    (package
      (name (string-join (cons "caddy" (map (compose basename car) plugins)) "-"))
      (version caddy-version)
      (source src)
      (build-system go-build-system)
      (arguments
       (list #:go go-pkg
             #:tests? #f
             #:install-source? #f
             #:import-path "."
             #:build-flags
             #~(list "-mod=vendor"
                     "-tags" "nobadger nomysql nopgx"
                     (string-append
                      "-ldflags="
                      "-X github.com/caddyserver/caddy/v2.CustomVersion="
                      #$caddy-version))
             #:modules
             '((guix build go-build-system)
               ((guix build gnu-build-system) #:prefix gnu:)
               (guix build utils)
               (ice-9 match))
             #:phases
             #~(modify-phases %standard-phases
                 (replace 'unpack
                   (lambda args
                     (unsetenv "GO111MODULE")
                     (apply (assoc-ref gnu:%standard-phases 'unpack) args)
                     (copy-recursively
                      #+(this-package-native-input
                          "vendored-go-dependencies")
                      ".")))
                 (replace 'install-license-files
                   (assoc-ref gnu:%standard-phases 'install-license-files))
                 (add-after 'install 'check-cli
                   (lambda* (#:key outputs #:allow-other-keys)
                     (let ((caddy (string-append (assoc-ref outputs "out")
                                                 "/bin/caddy")))
                       (invoke caddy "version")))))))
      (native-inputs
       (list go-pkg
             (origin
               (method (go-mod-vendor+tidy #:go go-pkg))
               (uri (package-source this-package))
               (file-name "vendored-go-dependencies")
               (sha256 (base32 vendor-hash)))))
      (home-page "https://caddyserver.com/")
      (synopsis "Caddy web server with custom plugins")
      (description
       "Caddy is an extensible HTTP web server with automatic HTTPS.
This package bundles additional third-party plugins alongside the
standard Caddy modules.")
      (license license:asl2.0)))) ; FIXME: ?
