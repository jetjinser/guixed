(list (channel
        (name 'guix)
        (url "https://codeberg.org/guix/guix.git")
        (branch "master")
        (commit
          "a9fb5fa2b9e9f36f8d6f601966d775fe4fe9a47b")
        (introduction
          (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
      (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        (branch "master")
        (commit
          "0f68c1684169cbef8824fb246dfefa3e6832225b")
        (introduction
          (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
              "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
      (channel
        (name 'rosenthal)
        (url "https://codeberg.org/hako/rosenthal.git")
        (branch "trunk")
        (commit
          "5ac1f7973ad82747402bbd93bb50744a9f9955b8")
        (introduction
          (make-channel-introduction
            "7677db76330121a901604dfbad19077893865f35"
            (openpgp-fingerprint
              "13E7 6CD6 E649 C28C 3385  4DF5 5E5A A665 6149 17F7")))))
