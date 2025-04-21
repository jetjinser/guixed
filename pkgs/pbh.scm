(define-module (pkgs pbh)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (gnu packages compression)
  #:export (pbh))

(define-public pbh
 (package
   (name "pbh")
   (version "7.4.12")
   (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/PBH-BTN/PeerBanHelper"
                           "/releases/download/v" version
                           "/PeerBanHelper_" version ".zip"))
       (sha256
         (base32
           "0v7qi4729clyiwcs57l97fwahp7m411nzr38rb36ayqkm5hx9fgh"))))
   (build-system copy-build-system)
   (native-inputs (list unzip))
   (home-page "https://github.com/PBH-BTN/PeerBanHelper")
   (synopsis "PeerBanHelper")
   (description "Automatically block unwanted, leeches and abnormal BT peers with support for customized and cloud rules.")
   (license (list license:gpl3))))

pbh
