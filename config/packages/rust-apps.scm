(define-module (config packages rust-apps)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (config utils cargo)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages musl))

(define-public hickory-dns
  (package
    (name "hickory-dns")
    (version "0.26.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hickory-dns/hickory-dns")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "06fmlr6sll6bcy20sh7wnwhbll04qm989g6nirdyxx1lpvsjl5wd"))))
    (build-system cargo-build-system)
    (arguments
      (list
        #:tests? #f                       ;TODO.
        #:install-source? #f
        #:features
        '(list
           "sqlite" "resolver" "rustls-platform-verifier"
           "tls-ring" "https-ring" "quic-ring" "dnssec-ring"
           "blocklist" "prometheus-metrics")
        #:cargo-install-paths
        '(list "bin")))
    (inputs (cons sqlite (cargo-inputs* 'hickory-dns)))
    (home-page "https://hickory-dns.org/")
    (synopsis
     "Hickory DNS is a safe and secure DNS server with a variety of protocol features
(DNSSEC, TSIG, SIG(0), DoT, DoQ, DoH). It can be operated as an authoritative
DNS server, forwarding resolver, stub resolver, or a recursive resolver (experimental).
Zone data can be managed in-memory, with flat files, or with an SQLite database.")
    (description
     "This package provides Hickory DNS is a safe and secure DNS server with a variety of protocol features
(DNSSEC, TSIG, SIG(0), @code{DoT}, @code{DoQ}, @code{DoH}).  It can be operated
as an authoritative DNS server, forwarding resolver, stub resolver, or a
recursive resolver (experimental).  Zone data can be managed in-memory, with
flat files, or with an SQLite database.")
    (license (list license:expat license:asl2.0))))

hickory-dns
