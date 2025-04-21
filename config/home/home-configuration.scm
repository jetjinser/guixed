(define-module (config home home-configuration)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu packages)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages shellutils)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (config packages transmission))

(home-environment
  (packages (list neovim git tmux curl
                  transmission* direnv))
  (services (list
              (service home-fish-service-type
                (home-fish-configuration
                 (abbreviations '(("g" . "git")))))
              (service home-xdg-configuration-files-service-type
                (list `("git/config" ,(local-file "../../files/gitconfig")))))))
