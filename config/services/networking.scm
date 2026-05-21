(define-module (config services networking)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services configuration)
  #:use-module (gnu system shadow)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages samba)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages tls)
  #:use-module (guix records)
  #:use-module (guix gexp)
  #:use-module (config packages rust-apps)
  #:export (hickory-dns-service-type
            hickory-dns-configuration
            update-blocklist-timer
            initial-blocklist-update

            pppoe-service-type
            pppoe-configuration

            nftables-service-type*
            nftables-configuration*
            nftables-configuration*?
            nftables-configuration*-package
            nftables-configuration*-debug-levels
            nftables-configuration*-ruleset
            %default-nftables-ruleset*))


(define %hickory-dns-accounts
  (list (user-group (name "hickory-dns") (system? #t))
        (user-account
          (name "hickory-dns")
          (group "hickory-dns")
          (system? #t)
          (comment "Hickory DNS user")
          (home-directory "/var/empty")
          (shell (file-append shadow "/sbin/nologin")))))

(define-record-type* <hickory-dns-configuration>
  hickory-dns-configuration make-hickory-dns-configuration
  hickory-dns-configuration?
  (hickory-dns hickory-dns-configuration-hickory-dns
               (default hickory-dns))
  (config-file hickory-dns-configuration-config-file
               (default "/etc/named.toml"))
  (zone-dir    hickory-dns-configuration-config-file
               (default #f)))

(define (hickory-dns-shepherd-service config)
  (match-record config <hickory-dns-configuration>
    (hickory-dns config-file zone-dir)
    (list (shepherd-service
            (provision '(hickory-dns))
            (requirement '(user-processes networking))
            (documentation "Run the Hickory DNS server/forwarder.")
            (start #~(make-forkexec-constructor
                       (list (string-append #$hickory-dns "/bin/hickory-dns")
                             "-c" #$config-file
                             #$@(if zone-dir
                                  (string-append "-z" #$zone-dir)
                                  '()))
                       #:log-file "/var/log/hickory-dns.log"
                       #:group    "hickory-dns"))
            (stop #~(make-kill-destructor))))))

(define hickory-dns-service-type
  (service-type (name 'hickory-dns)
                (extensions (list (service-extension shepherd-root-service-type
                                                     hickory-dns-shepherd-service)
                                  (service-extension account-service-type
                                                     (const %hickory-dns-accounts))))
                (default-value (hickory-dns-configuration))
                (description "Run the @command{hickory-dns}, a secure and modern DNS resolver written in Rust.")))

(define update-blocklist-program
  (program-file
   "update-blocklist"
   (with-extensions (list guile-gnutls)
     (with-imported-modules '((guix build utils))
       #~(begin
           (use-modules (web client)
                        (web response)
                        (ice-9 receive)
                        (ice-9 ftw)
                        (ice-9 binary-ports)
                        (guix build utils))

           (define dir "/var/lib/hickory-dns")
           (define dest (string-append dir "/blocklist.txt"))
           (define url "https://blocklistproject.github.io/Lists/ads.txt")
           (define pw (getpwnam "hickory-dns"))
           (define uid (passwd:uid pw))
           (define gid (passwd:gid pw))

           (format #t "Starting blocklist update...~%")
           (mkdir-p dir)
           (chown dir uid gid)
           (chmod dir #o755)

           (format #t "Downloading from ~a ...~%" url)
           (receive (response body)
                    (http-get url #:decode-body? #f)
             (let ([code (response-code response)])
               (cond
                 [(= code 200)
                  (let ([tmp (string-append dir "/.tmp-blocklist")])
                     (format #t "Download successful (HTTP ~a). Writing to temporary file...~%" code)
                     (call-with-output-file tmp
                       (lambda (port)
                         (put-bytevector port body)))
                     (chown tmp uid gid)
                     (chmod tmp #o644)
                     (rename-file tmp dest)
                     (format #t "Blocklist file updated successfully.~%")
                     (format #t "Restarting hickory-dns service...~%")
                     (invoke #$(file-append shepherd "/bin/herd")
                             "restart" "hickory-dns")
                     (format #t "Service restarted. Update complete.~%"))]
                 [else
                  (format (current-error-port)
                          "Blocklist update failed (HTTP ~a)~%" code)
                  (exit 1)]))))))))

(define update-blocklist-timer
  (shepherd-timer
    '(update-blocklist)
    #~(calendar-event #:hours '(5) #:minutes '(0))
    #~(#$update-blocklist-program)
    #:requirement '(networking hickory-dns)
    #:documentation "Weekly update of the DNS blocklist."))

(define initial-blocklist-update
  (shepherd-service
    (provision '(update-blocklist-once))
    (requirement '(networking hickory-dns))
    (one-shot? #t)
    (start #~(lambda _ (make-system-constructor
                         #$update-blocklist-program)))
    (auto-start? #t)
    (documentation "Run blocklist update once at boot.")))


(define-record-type* <pppoe-configuration>
  pppoe-configuration make-pppoe-configuration
  pppoe-configuration?
  (ppp       pppoe-configuration-ppp
             (default ppp))
  (peer-file pppoe-configuration-peer-file
             (default #f))
  (log-file  pppoe-configuration-log-file
             (default "/var/log/pppoe.log")))

(define (pppoe-shepherd-service config)
  (match-record config <pppoe-configuration>
    (ppp peer-file log-file)
    (list (shepherd-service
            (provision '(pppoe))
            (requirement '(user-processes wan-ready loopback))
            (documentation "Run PPPoE connection using pppd.")
            (start #~(make-forkexec-constructor
                      (list #$(file-append ppp "/sbin/pppd")
                            "file" #$peer-file)
                      #:log-file #$log-file))
            (stop #~(make-kill-destructor))))))

(define pppoe-service-type
  (service-type (name 'pppoe)
                (extensions
                 (list (service-extension shepherd-root-service-type
                                          pppoe-shepherd-service)))
                (default-value (pppoe-configuration))
                (description "Establish a PPPoE connection with @command{pppd}.")))

;;;
;;; nftables.
;;;

(define %default-nftables-ruleset*
  (plain-file "nftables.conf" "\
# A simple and safe firewall
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;

    # early drop of invalid connections
    ct state invalid drop

    # allow established/related connections
    ct state { established, related } accept

    # allow from loopback
    iif lo accept
    # drop connections to lo not coming from lo
    iif != lo ip daddr 127.0.0.1/8 drop
    iif != lo ip6 daddr ::1/128 drop

    # allow icmp
    ip protocol icmp accept
    ip6 nexthdr icmpv6 accept

    # allow ssh
    tcp dport ssh accept

    # reject everything else
    reject with icmpx type port-unreachable
  }
  chain forward {
    type filter hook forward priority 0; policy drop;
  }
  chain output {
    type filter hook output priority 0; policy accept;
  }
}
"))

(define (debug-level? x)
  (member x '(scanner parser eval netlink mnl proto-ctx segtree all)))

(define list-of-debug-levels?
  (list-of debug-level?))

(define-maybe/no-serialization list-of-debug-levels)

(define-configuration/no-serialization nftables-configuration*
  (package
    (file-like nftables)
    "The @code{nftables} package to use.")
  (debug-levels
   maybe-list-of-debug-levels
   "A list of debug levels, for enabling debugging output.  Valid debug level values
are the @samp{scanner}, @samp{parser}, @samp{eval}, @samp{netlink},
@samp{mnl}, @samp{proto-ctx}, @samp{segtree} or @samp{all} symbols.")
  (ruleset
   (file-like %default-nftables-ruleset*)
   "A file-like object containing the complete nftables ruleset.  The default
ruleset rejects all incoming connections except those to TCP port 22, with
connections from the loopback interface are allowed."))

(define (nftables-shepherd-service* config)
  (match-record config <nftables-configuration*>
                (package debug-levels ruleset)
    (let ((nft (file-append package "/sbin/nft")))
      (shepherd-service
       (documentation "Packet filtering and classification")
       (actions (list (shepherd-configuration-action ruleset)))
       (requirement '(networking pppoe)) ; XXX
       (provision '(nftables))
       (start #~(lambda _
                  (invoke #$nft
                          #$@(if (maybe-value-set? debug-levels)
                                 (list (format #f "--debug=~{~a~^,~}"
                                               debug-levels))
                                 #~())
                          "--file" #$ruleset)))
       (stop #~(lambda _
                 (invoke #$nft "flush" "ruleset")))))))

(define nftables-service-type*
  (service-type
   (name 'nftables)
   (description
    "Run @command{nft}, setting up the specified ruleset.")
   (extensions
    (list (service-extension shepherd-root-service-type
                             (compose list nftables-shepherd-service*))
          (service-extension profile-service-type
                             (compose list nftables-configuration*-package))))
   (default-value (nftables-configuration*))))
