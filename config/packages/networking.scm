(define-module (config packages networking)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system go)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages golang)
  #:use-module (rosenthal utils download))

;; Adapted from Nixpkgs v2ray-domain-list-community.
;; See: https://github.com/NixOS/nixpkgs/blob/f83fc3c307e74bc5fd5adb7eb6b8b13ffd2a36e1/pkgs/by-name/v2/v2ray-domain-list-community/package.nix
;; Credit for the contributors who have contributed to this package.
(define v2fly-domain-list-community/generator
  (package
    (name "v2fly-domain-list-community")
    (version "20260520170255")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/v2fly/domain-list-community")
                     (commit version)))
              (file-name (git-file-name name version))
              (sha256
                (base32
                  "093qhjbcwmv6g0wzijinc72w8bl4fcx8ahv8bqbii7vb6k5x9gim"))))
    (build-system go-build-system)
    (arguments
      (list
        #:go go-1.26
        #:install-source? #f
        #:import-path "."
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
                  (apply invoke "go" "build" "-ldflags=-s -w" "-trimpath"
                         "-o" (string-append #$output "/bin/")
                         `(,@build-flags
                           "github.com/v2fly/domain-list-community"))
                  (apply invoke "go" "build" "-ldflags=-s -w" "-trimpath"
                         "-o" (string-append #$output "/bin/")
                         `(,@build-flags
                           "github.com/v2fly/domain-list-community/cmd/datdump")))))
            (delete 'check)
            (add-after 'install 'check
              (lambda* (#:key tests? #:allow-other-keys)
                (when tests?
                  (for-each
                   (lambda (cmd)
                     (invoke (string-append #$output "/bin/" cmd) "--help"))
                   '("datdump"
                     "domain-list-community"))))))))
    (native-inputs
      (list (origin
              (method (go-mod-vendor #:go go-1.26))
              (uri (package-source this-package))
              (file-name "vendored-go-dependencies")
              (sha256
                 (base32
                  "0699r646wfknlgf2i4iq4xpd315gq8qy61yq6x1hr8y1n3xfzmgn")))))
    (home-page "https://github.com/v2fly/domain-list-community")
    (synopsis "Community managed domain list")
    (description "TODO")
    (license license:expat)))

(define-public v2fly-domain-list-community
  (package
    (name "v2fly-domain-list-community")
    (version (package-version v2fly-domain-list-community/generator))
    (source (package-source v2fly-domain-list-community/generator))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (delete 'check)
          (replace 'build
            (lambda _
              (invoke #$(file-append v2fly-domain-list-community/generator
                                     "/bin/domain-list-community")
                      "-datapath" "data")
              (invoke #$(file-append v2fly-domain-list-community/generator
                                     "/bin/datdump")
                      "--inputdata=dlc.dat"
                      "--exportlists=_all_")))
          (replace 'install
            (lambda _
              (let ([out #$output]
                    [dest (string-append #$output "/share/v2ray")])
                (mkdir-p dest)
                (copy-file "dlc.dat"
                           (string-append dest "/geosite.dat"))
                (copy-file "dlc.dat_plain.yml"
                           (string-append dest "/geosite.dat_plain.yml"))))))))
    (native-inputs
      (list v2fly-domain-list-community/generator))
    (home-page (package-home-page v2fly-domain-list-community/generator))
    (synopsis "Pre-generated V2Ray domain list")
    (description
     "This package provides pre-built geosite.dat and its plain YAML version,
generated from the v2fly/domain-list-community repository.  It can be used
directly with V2Ray and Xray.")
    (license license:expat)))


;; Adapted from Nixpkgs sing-geosite.
;; See: https://github.com/NixOS/nixpkgs/blob/f83fc3c307e74bc5fd5adb7eb6b8b13ffd2a36e1/pkgs/by-name/si/sing-geosite/package.nix
;; Credit for the contributors who have contributed to this package.
(define-public sing-geosite
  (package
    (name "sing-geosite")
    (version (package-version v2fly-domain-list-community/generator))
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/SagerNet/sing-geosite")
                     (commit "20250326132209")))
              (file-name (git-file-name name version))
              (sha256
                (base32
                  "0lrjipax9cc8vxmkfxlj1h8y7h0f1lnn8bhkivb4dc5i2aij7mlp"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (delete 'check)
          (add-after 'unpack 'patch-source
            (lambda* (#:key inputs #:allow-other-keys)
              (let ((geosite-file
                     (string-append
                      #+(this-package-native-input "v2fly-domain-list-community")
                      "/share/v2ray/geosite.dat")))
                (substitute* "main.go"
                  (("\"io\"")
                   "\"io\"\n\t\"io/ioutil\""))
                (invoke "sed" "-i" "/func main(/,/^}/d" "main.go")
                (substitute* "main.go"
                  (("vData, err := download\\(release\\)")
                   (string-append "vData, err := ioutil.ReadFile(\"" geosite-file "\")")))
                (let ([port (open-file "main.go" "a")])
                  (display "
func main() {
  generate(nil, \"geosite.db\", \"geosite-cn.db\", \"rule-set\", \"rule-set-unstable\")
}
"                          port)
                  (close-port port)))))
          (replace 'build
            (lambda _
              (setenv "GOCACHE" (string-append (getcwd) "/.go-cache"))
              (setenv "HOME" (getcwd))
              (mkdir-p (getenv "GOCACHE"))
              (copy-recursively
               #+(this-package-native-input "vendored-go-dependencies")
               "vendor")
              (invoke "go" "run" "-mod=vendor" "-v" ".")))
          (replace 'install
            (lambda _
              (let ((dest (string-append #$output "/share/sing-box/rule-set")))
                (mkdir-p dest)
                (copy-recursively "rule-set" dest)))))))
    (native-inputs
      (list
        v2fly-domain-list-community
        go-1.26
        (origin
          (method (go-mod-vendor #:go go-1.26))
          (uri (package-source this-package))
          (file-name "vendored-go-dependencies")
          (sha256
             (base32
              "1is151d2rwmjk52jp1gfsgsggr9vscg3n6ily8qpg5fy8yj056yz")))))
    (home-page "https://github.com/SagerNet/sing-geosite")
    (synopsis "Community managed domain list")
    (description "TODO")
    (license license:gpl3+)))


;; Adapted from Nixpkgs v2ray-domain-list-community.
;; See: https://github.com/NixOS/nixpkgs/blob/f83fc3c307e74bc5fd5adb7eb6b8b13ffd2a36e1/pkgs/by-name/db/dbip-country-lite/package.nix
;; Credit for the contributors who have contributed to this package.
(define-public dbip-country-lite
  (package
    (name "dbip-country-lite")
    (version "2026-05")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://download.db-ip.com/free/dbip-country-lite-"
             version ".mmdb.gz"))
       (sha256
        (base32 "1ypd51plj820q9h49z9ifa89ahhqnhn4xvxrkzw9g19y57fv0ii3"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (delete 'unpack)
          (delete 'configure)
          (delete 'build)
          (delete 'check)
          (replace 'install
            (lambda* (#:key inputs #:allow-other-keys)
              (let ((src (assoc-ref inputs "source"))
                    (out #$output))
                (mkdir-p (string-append out "/share/dbip"))
                (invoke "sh" "-c"
                        (string-append
                         "gzip -dc " src
                         " > " (string-append out "/share/dbip/dbip-country-lite.mmdb")))))))))
    (home-page "https://db-ip.com/db/download/ip-to-country-lite")
    (synopsis "Free IP to Country Lite database (DB-IP)")
    (description "This package provides the DB-IP Country Lite database in
MaxMind DB format, containing IP-to-country mappings.  It is freely
licensed under CC BY 4.0 and updated monthly.")
    (license license:cc-by4.0)))


;; Adapted from Nixpkgs sing-geoip.
;; See: https://github.com/NixOS/nixpkgs/blob/f83fc3c307e74bc5fd5adb7eb6b8b13ffd2a36e1/pkgs/by-name/si/sing-geoip/package.nix
;; Credit for the contributors who have contributed to this package.
(define sing-geoip/generator
  (package
    (name "sing-geoip-generator")
    (version "20240312")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/SagerNet/sing-geoip")
              (commit version)))
       (file-name (git-file-name name version))
       (sha256
         (base32 "09jv50mx2da6xd4562w95n2155bmrz5sh1gip2r93nwa824dp2lw"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.26
      #:install-source? #f
      #:import-path "github.com/sagernet/sing-geoip"
      #:modules '((ice-9 match)
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
          (add-after 'unpack 'patch-main
            (lambda _
              (invoke "sed" "-i" "/func main()/,/^}/d" "main.go")
              (let ((port (open-file "main.go" "a")))
                (display
                 "func main() {
    var err error

    input := os.Args[1]
    ruleSetOutput := \"rule-set\"

    binary, err := os.ReadFile(input)
    if err != nil {
        panic(err)
    }
    _, countryMap, err := parse(binary)
    if err != nil {
        panic(err)
    }

    err = os.MkdirAll(ruleSetOutput, 0o755)
    if err != nil {
        panic(err)
    }
    for countryCode, ipNets := range countryMap {
        var headlessRule option.DefaultHeadlessRule
        headlessRule.IPCIDR = make([]string, 0, len(ipNets))
        for _, cidr := range ipNets {
            headlessRule.IPCIDR = append(headlessRule.IPCIDR, cidr.String())
        }
        var plainRuleSet option.PlainRuleSet
        plainRuleSet.Rules = []option.HeadlessRule{
            {
                Type:           C.RuleTypeDefault,
                DefaultOptions: headlessRule,
            },
        }
        srsPath, _ := filepath.Abs(filepath.Join(ruleSetOutput, \"geoip-\"+countryCode+\".srs\"))
        os.Stderr.WriteString(\"write \" + srsPath + \"\\n\")
        outputRuleSet, err := os.Create(srsPath)
        if err != nil {
            panic(err)
        }
        err = srs.Write(outputRuleSet, plainRuleSet)
        if err != nil {
            outputRuleSet.Close()
            panic(err)
        }
        outputRuleSet.Close()
    }
}"
                 port)
                (close-port port))))
          (replace 'build
            (lambda* (#:key import-path #:allow-other-keys)
              (setenv "GOCACHE" (string-append (getcwd) "/.go-cache"))
              (setenv "HOME" (getcwd))
              (mkdir-p (getenv "GOCACHE"))
              (invoke "go" "build"
                      "-mod=vendor"
                      "-ldflags=-s -w"
                      "-trimpath"
                      "-o" (string-append #$output "/bin/sing-geoip")
                      import-path)))
          (replace 'install-license-files
            (assoc-ref gnu:%standard-phases 'install-license-files)))))
    (native-inputs
     (list (origin
             (method (go-mod-vendor #:go go-1.26))
             (uri (package-source this-package))
             (file-name "vendored-go-dependencies")
             (sha256
              (base32 "1dgqasmrv13q367i09ca1lq8pfb2dpqgl1rfffajia1s1lr1wzaq")))))
    (home-page "https://github.com/SagerNet/sing-geoip")
    (synopsis "GeoIP data generator for sing-box")
    (description "This package provides the sing-geoip tool to convert MaxMind DB
files into sing-box rule-set format.")
    (license license:gpl3+)))

(define-public sing-geoip
  (package
    (name "sing-geoip")
    (version (package-version dbip-country-lite))
    (source #f)
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (delete 'unpack)
          (delete 'configure)
          (delete 'check)
          (replace 'build
            (lambda _
              (invoke #$(file-append sing-geoip/generator "/bin/sing-geoip")
                      #$(file-append dbip-country-lite "/share/dbip/dbip-country-lite.mmdb"))))
          (replace 'install
            (lambda _
              (let ((dest (string-append #$output "/share/sing-box/rule-set")))
                (mkdir-p dest)
                (copy-recursively "rule-set" dest)))))))
    (native-inputs
     (list sing-geoip/generator))
    (inputs
     (list dbip-country-lite))
    (home-page (package-home-page sing-geoip/generator))
    (synopsis "Pre-built GeoIP rule-set for sing-box")
    (description "This package provides pre-generated GeoIP rule-set files
(@file{geoip-*.srs}) for use with @command{sing-box}, built from the DB-IP
Country Lite database.")
    (license (package-license dbip-country-lite))))
