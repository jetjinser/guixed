;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu packages)
             (gnu packages vim)
             (gnu packages version-control)
             (gnu services)
             (guix gexp)
             (gnu home services)
             (gnu home services shells))

(home-environment
  (packages (list neovim git))
  (services (list
    (service home-fish-service-type
      (home-fish-configuration))
    (service home-xdg-configuration-files-service-type
      (list `("git/config" ,(local-file "gitconfig")))))))
