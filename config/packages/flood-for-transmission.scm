(define-module (config packages flood-for-transmission)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system node)
  #:use-module (gnu packages node-xyz)
  #:export (flood-for-transmission))

(define-public node-mkdirp
  (package
    (name "node-mkdirp")
    (version "0.5.6")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/isaacs/node-mkdirp")
              (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32 "1ljrs27fqj67gc8cl2ls1g997cr59i2ygxvzlikb003xan7jlrx0"))))
    (build-system node-build-system)
    (arguments
      '(#:tests? #f
        #:phases
        (modify-phases %standard-phases
          (add-after 'patch-dependencies 'delete-dependencies
            (lambda args
              (modify-json (delete-dependencies '("tap"))))))))
    (inputs (list node-minimist))
    (home-page "https://github.com/isaacs/node-mkdirp")
    (synopsis "Recursively mkdir, like `mkdir -p`, but in node.js")
    (description "Recursively mkdir, like `mkdir -p`, but in node.js.")
    (license (list license:expat))))

(define-public node-core-js
  (package
    (name "node-core-js")
    (version "3.39.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/zloirock/core-js")
              (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32 "0xh93r6g7yv6b4fpd4g4jsrgh4174rdmgvws4zd2dbxi4xgn7svn"))))
    (build-system node-build-system)
    (arguments
      '(#:phases
        (modify-phases %standard-phases
          (add-after 'patch-dependencies 'delete-dependencies
            (lambda args
              (modify-json (delete-dependencies
                            '("@babel/core"
                              "@babel/core"
                              "@babel/plugin-transform-arrow-functions"
                              "@babel/plugin-transform-block-scoped-functions"
                              "@babel/plugin-transform-block-scoping"
                              "@babel/plugin-transform-classes"
                              "@babel/plugin-transform-class-properties"
                              "@babel/plugin-transform-class-static-block"
                              "@babel/plugin-transform-computed-properties"
                              "@babel/plugin-transform-destructuring"
                              "@babel/plugin-transform-duplicate-named-capturing-groups-regex"
                              "@babel/plugin-transform-exponentiation-operator"
                              "@babel/plugin-transform-for-of"
                              "@babel/plugin-transform-literals"
                              "@babel/plugin-transform-logical-assignment-operators"
                              "@babel/plugin-transform-member-expression-literals"
                              "@babel/plugin-transform-modules-commonjs"
                              "@babel/plugin-transform-new-target"
                              "@babel/plugin-transform-nullish-coalescing-operator"
                              "@babel/plugin-transform-numeric-separator"
                              "@babel/plugin-transform-object-rest-spread"
                              "@babel/plugin-transform-object-super"
                              "@babel/plugin-transform-optional-catch-binding"
                              "@babel/plugin-transform-optional-chaining"
                              "@babel/plugin-transform-parameters"
                              "@babel/plugin-transform-private-methods"
                              "@babel/plugin-transform-private-property-in-object"
                              "@babel/plugin-transform-property-literals"
                              "@babel/plugin-transform-regexp-modifiers"
                              "@babel/plugin-transform-reserved-words"
                              "@babel/plugin-transform-shorthand-properties"
                              "@babel/plugin-transform-spread"
                              "@babel/plugin-transform-template-literals"
                              "@babel/plugin-transform-unicode-regex"
                              "konan"
                              "npm-run-all2"
                              "semver"
                              "zx"))))))))
    (inputs (list node-mkdirp)) ; WARN: not work
    (home-page "https://github.com/zloirock/core-js")
    (synopsis "Standard Library")
    (description "Standard Library")
    (license (list license:expat))))

(define-public flood-for-transmission
  (package
    (name "flood-for-transmission")
    (version "2024-11-16T12-26-17")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/johman10/flood-for-transmission")
              (commit version)))
        (file-name (git-file-name name version))
        (sha256
         (base32 "15f014n9slp8x82dvcyqhkza2314bda1ajlykhqfqmxmk1igch1q"))))
    (build-system node-build-system)
    (arguments
      '(#:phases
        (modify-phases %standard-phases
          (add-after 'patch-dependencies 'delete-dependencies
            (lambda args
              (modify-json (delete-dependencies
                            '("@babel/core"
                              "@babel/eslint-parser"
                              "@babel/plugin-proposal-class-properties"
                              "@babel/preset-env"
                              "@eslint/eslintrc"
                              "@eslint/js"
                              "@rollup/plugin-alias"
                              "@rollup/plugin-babel"
                              "@rollup/plugin-commonjs"
                              "@rollup/plugin-json"
                              "@rollup/plugin-node-resolve"
                              "@rollup/plugin-replace"
                              "@rollup/plugin-terser"
                              "dotenv"
                              "eslint"
                              "eslint-plugin-svelte"
                              "globals"
                              "prettier"
                              "prettier-plugin-svelte"
                              "rollup"
                              "rollup-plugin-copy"
                              "rollup-plugin-css-only"
                              "rollup-plugin-livereload"
                              "rollup-plugin-svelte"
                              "svelte"
                              "svelte-eslint-parser"
                              "workbox-cli"))))))))
    (home-page "https://github.com/johman10/flood-for-transmission")
    (synopsis "Flood clone for Transmission")
    (description "A Flood (https://github.com/Flood-UI/flood) clone for Transmission.")
    (license (list license:gpl3))))

node-core-js
