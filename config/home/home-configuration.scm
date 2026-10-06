(define-module (config home home-configuration)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services ssh)
  #:use-module (gnu packages)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages shellutils)
  #:use-module (gnu packages bittorrent)
  #:use-module ((gnu packages rust-apps) #:prefix rust:)
  #:use-module (gnu packages tree-sitter)
  #:use-module (rosenthal services shellutils)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (guix packages))

(define tree-sitter-grammar (@@ (gnu packages tree-sitter) tree-sitter-grammar))

(define tree-sitter-caddy
  (tree-sitter-grammar
   "caddy" "Caddyfile"
   "102wkzdhqy3naf86kjm3zcm3g9h0ynwccnrld5b6pry1qxzksjwk"
   "0.1.1"
   #:repository-url "https://github.com/opa-oz/tree-sitter-caddy"))

(define neovim/parsers
  (package
    (inherit neovim)
    (propagated-inputs
      (cons* tree-sitter-scheme
             ; tree-sitter-fennel
             tree-sitter-caddy
             tree-sitter-json
             (map cadr propagated-inputs)))))

(home-environment
  (packages (list neovim/parsers git tmux curl
                  transmission direnv
                  rust:fd rust:ripgrep rust:bat))
  (services (list
              (service home-fish-service-type
                (home-fish-configuration
                 (abbreviations '(("g" . "git")))))
              (service home-fish-plugin-direnv-service-type)
              (service home-xdg-configuration-files-service-type
                (list `("git/config" ,(local-file "../../assets/gitconfig"))))
              (service home-ssh-agent-service-type
                       (home-ssh-agent-configuration
                        (extra-options '("-t" "1h30m")))))))
