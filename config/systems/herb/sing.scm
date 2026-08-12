(define-module (config systems herb sing)
  #:use-module (guix gexp)
  #:use-module (config packages networking))

(define final-out "dc99-out")

(define inbound/mixed
  #~'(["type"        . "mixed"]
      ["tag"         . "mixed-in"]
      ["listen"      . "::"]
      ["listen_port" . 7890]))

(define inbound/tproxy
  #~'(["type"                       . "tproxy"]
      ["tag"                        . "tproxy-in"]
      ["listen"                     . "::"]
      ["listen_port"                . 7891]
      ["tcp_fast_open"              . #t]
      ["udp_fragment"               . #t]
      ["sniff"                      . #t]
      ["sniff_override_destination" . #f]
      ["domain_strategy"            . "prefer_ipv6"]))

;; FIXME: sops-fy
(define outbound/dc99
  #~'(["type"        . "shadowsocks"]
      ["tag"         . "dc99-out"]
      ["server_port" . 29137]
      ["server"      . "..."]
      ["password"    . "..."]
      ["method"      . "..."]))
(define outbound/direct
  #~'(["type"            . "direct"]
      ["tag"             . "direct-out"]
      ["domain_resolver" . "local"]))

(define (make-geosite-rule-set topic)
  #~'(["type"   . "local"]
      ["tag"    . #$topic]
      ["format" . "binary"]
      ["path"   . #$(file-append sing-geosite
                                 "/share/sing-box/rule-set/geosite-"
                                 topic
                                 ".srs")]))
(define (make-geoip-rule-set topic)
  #~'(["type"   . "local"]
      ["tag"    . #$topic]
      ["format" . "binary"]
      ["path"   . #$(file-append sing-geoip
                                 "/share/sing-box/rule-set/geoip-"
                                 topic
                                 ".srs")]))

(define-public sing-box-config
  #~(let ([inbounds  (vector #$inbound/mixed
                             #$inbound/tproxy)]
          [outbounds (vector #$outbound/direct
                             #$outbound/dc99)]
          [rule-set  (vector #$(make-geoip-rule-set "geoip-cn"))])
      `(["log" . (["level"    . "warn"])]
        ["dns" . (["servers"  . #((["type" . "local"]
                                   ["tag"  . "local"]))]
                  ["final"    . "local"]
                  ["strategy" . "prefer_ipv6"])]
        ["inbounds"  . ,inbounds]
        ["outbounds" . ,outbounds]
        ["route" . (["rules"                   . #()]
                    ["rule_set"                . ,rule-set]
                    ["final"                   . #$final-out]
                    ["default_mark"            . 255]
                    ["default_domain_resolver" . "local"])])))
