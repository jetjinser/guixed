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
  #:use-module (rosenthal services shellutils)
  #:use-module (gnu services)
  #:use-module (guix gexp))

(home-environment
  (packages (list neovim git tmux curl
                  transmission direnv
                  rust:fd rust:ripgrep rust:bat))
  (services (list
              (service home-fish-service-type
                (home-fish-configuration
                 (abbreviations '(("g" . "git")))))
              (service home-fish-plugin-direnv-service-type)
              (service home-xdg-configuration-files-service-type
                (list `("git/config" ,(local-file "../../files/gitconfig"))))
              (service home-ssh-agent-service-type
                       (home-ssh-agent-configuration
                        (extra-options '("-t" "1h30m")))))))
