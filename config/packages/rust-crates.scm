(define-module (config packages rust-crates)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:export (lookup-cargo-inputs))

(define rust-adler2-2.0.1
  (crate-source "adler2" "2.0.1"
                "1ymy18s9hs7ya1pjc9864l30wk8p2qfqdi7mhhcc5nfakxbij09j"))

(define rust-ahash-0.8.12
  (crate-source "ahash" "0.8.12"
                "0xbsp9rlm5ki017c0w6ay8kjwinwm8knjncci95mii30rmwz25as"))

(define rust-aho-corasick-1.1.4
  (crate-source "aho-corasick" "1.1.4"
                "00a32wb2h07im3skkikc495jvncf62jl6s96vwc7bhi70h9imlyx"))

(define rust-alloca-0.4.0
  (crate-source "alloca" "0.4.0"
                "1x6p4387rz6j7h342kp3b7bgvqzyl9mibf959pkfk9xflrgd19z5"))

(define rust-android-system-properties-0.1.5
  (crate-source "android_system_properties" "0.1.5"
                "04b3wrz12837j7mdczqd95b732gw5q7q66cv4yn4646lvccp57l1"))

(define rust-anes-0.1.6
  (crate-source "anes" "0.1.6"
                "16bj1ww1xkwzbckk32j2pnbn5vk6wgsl3q4p3j9551xbcarwnijb"))

(define rust-anstream-1.0.0
  (crate-source "anstream" "1.0.0"
                "13d2bj0xfg012s4rmq44zc8zgy1q8k9yp7yhvfnarscnmwpj2jl2"))

(define rust-anstyle-1.0.14
  (crate-source "anstyle" "1.0.14"
                "0030szmgj51fxkic1hpakxxgappxzwm6m154a3gfml83lq63l2wl"))

(define rust-anstyle-parse-1.0.0
  (crate-source "anstyle-parse" "1.0.0"
                "03hkv2690s0crssbnmfkr76kw1k7ah2i6s5amdy9yca2n8w7zkjj"))

(define rust-anstyle-query-1.1.5
  (crate-source "anstyle-query" "1.1.5"
                "1p6shfpnbghs6jsa0vnqd8bb8gd7pjd0jr7w0j8jikakzmr8zi20"))

(define rust-anstyle-wincon-3.0.11
  (crate-source "anstyle-wincon" "3.0.11"
                "0zblannm70sk3xny337mz7c6d8q8i24vhbqi42ld8v7q1wjnl7i9"))

(define rust-anyhow-1.0.102
  (crate-source "anyhow" "1.0.102"
                "0b447dra1v12z474c6z4jmicdmc5yxz5bakympdnij44ckw2s83z"))

(define rust-async-compression-0.4.42
  (crate-source "async-compression" "0.4.42"
                "1b59jb3y26pmxdshyjb7slxrp184ydlzq80ryfc2ik6cg653z6z7"))

(define rust-async-recursion-1.1.1
  (crate-source "async-recursion" "1.1.1"
                "04ac4zh8qz2xjc79lmfi4jlqj5f92xjvfaqvbzwkizyqd4pl4hrv"))

(define rust-async-trait-0.1.89
  (crate-source "async-trait" "0.1.89"
                "1fsxxmz3rzx1prn1h3rs7kyjhkap60i7xvi0ldapkvbb14nssdch"))

(define rust-atomic-waker-1.1.2
  (crate-source "atomic-waker" "1.1.2"
                "1h5av1lw56m0jf0fd3bchxq8a30xv0b4wv8s4zkp4s0i7mfvs18m"))

(define rust-autocfg-1.5.0
  (crate-source "autocfg" "1.5.0"
                "1s77f98id9l4af4alklmzq46f21c980v13z2r1pcxx6bqgw0d1n0"))

(define rust-aws-lc-rs-1.16.3
  (crate-source "aws-lc-rs" "1.16.3"
                "13q3i8j2nfykpw0yln0n21m70nfgls5b9gz1lxgsf94hwqzzpihf"))

(define rust-aws-lc-sys-0.40.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "aws-lc-sys" "0.40.0"
                "1rrghm82i50zz40ykizqnrn65lavf856hqfiz6wffh8ybvp3f07m"))

(define rust-base64-0.22.1
  (crate-source "base64" "0.22.1"
                "1imqzgh7bxcikp5vx3shqvw9j09g9ly0xr0jma0q66i52r7jbcvj"))

(define rust-bindgen-0.72.1
  (crate-source "bindgen" "0.72.1"
                "15bq73y3wd3x3vxh3z3g72hy08zs8rxg1f0i1xsrrd6g16spcdwr"))

(define rust-bitflags-2.11.1
  (crate-source "bitflags" "2.11.1"
                "1cvqijg3rvwgis20a66vfdxannjsxfy5fgjqkaq3l13gyfcj4lf4"))

(define rust-bumpalo-3.20.2
  (crate-source "bumpalo" "3.20.2"
                "1jrgxlff76k9glam0akhwpil2fr1w32gbjdf5hpipc7ld2c7h82x"))

(define rust-bytes-1.11.1
  (crate-source "bytes" "1.11.1"
                "0czwlhbq8z29wq0ia87yass2mzy1y0jcasjb8ghriiybnwrqfx0y"))

(define rust-cast-0.3.0
  (crate-source "cast" "0.3.0"
                "1dbyngbyz2qkk0jn2sxil8vrz3rnpcj142y184p9l4nbl9radcip"))

(define rust-cc-1.2.61
  (crate-source "cc" "1.2.61"
                "0vawvnrrsmi8dygavq3wx085cmlp10sp3fhld5842rlqkqsr0vfi"))

(define rust-cexpr-0.6.0
  (crate-source "cexpr" "0.6.0"
                "0rl77bwhs5p979ih4r0202cn5jrfsrbgrksp40lkfz5vk1x3ib3g"))

(define rust-cfg-aliases-0.2.1
  (crate-source "cfg_aliases" "0.2.1"
                "092pxdc1dbgjb6qvh83gk56rkic2n2ybm4yvy76cgynmzi3zwfk1"))

(define rust-cfg-if-1.0.4
  (crate-source "cfg-if" "1.0.4"
                "008q28ajc546z5p2hcwdnckmg0hia7rnx52fni04bwqkzyrghc4k"))

(define rust-chacha20-0.10.0
  (crate-source "chacha20" "0.10.0"
                "00bn2rn8l68qvlq93mhq7b4ns4zy9qbjsyjbb9kljgl4hqr9i3bg"))

(define rust-chrono-0.4.44
  (crate-source "chrono" "0.4.44"
                "1c64mk9a235271j5g3v4zrzqqmd43vp9vki7vqfllpqf5rd0fwy6"))

(define rust-ciborium-0.2.2
  (crate-source "ciborium" "0.2.2"
                "03hgfw4674im1pdqblcp77m7rc8x2v828si5570ga5q9dzyrzrj2"))

(define rust-ciborium-io-0.2.2
  (crate-source "ciborium-io" "0.2.2"
                "0my7s5g24hvp1rs1zd1cxapz94inrvqpdf1rslrvxj8618gfmbq5"))

(define rust-ciborium-ll-0.2.2
  (crate-source "ciborium-ll" "0.2.2"
                "1n8g4j5rwkfs3rzfi6g1p7ngmz6m5yxsksryzf5k72ll7mjknrjp"))

(define rust-clang-sys-1.8.1
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "clang-sys" "1.8.1"
                "1x1r9yqss76z8xwpdanw313ss6fniwc1r7dzb5ycjn0ph53kj0hb"))

(define rust-clap-4.6.1
  (crate-source "clap" "4.6.1"
                "0lcf88l7vlg796rrqr7wipbbmfa5sgsgx4211b7xmxxv8dz13nqx"))

(define rust-clap-builder-4.6.0
  (crate-source "clap_builder" "4.6.0"
                "17q6np22yxhh5y5v53y4l31ps3hlaz45mvz2n2nicr7n3c056jki"))

(define rust-clap-derive-4.6.1
  (crate-source "clap_derive" "4.6.1"
                "1acpz49hi00iv9jkapixjzcv7s51x8qkfaqscjm36rqgf428dkpj"))

(define rust-clap-lex-1.1.0
  (crate-source "clap_lex" "1.1.0"
                "1ycqkpygnlqnndghhcxjb44lzl0nmgsia64x9581030yifxs7m68"))

(define rust-cmake-0.1.58
  (crate-source "cmake" "0.1.58"
                "0y06zxw5sv1p5vvpp5rz1qwbrq7ccawrl09nqy5ahx1a5418mxy0"))

(define rust-colorchoice-1.0.5
  (crate-source "colorchoice" "1.0.5"
                "0w75k89hw39p0mnnhlrwr23q50rza1yjki44qvh2mgrnj065a1qx"))

(define rust-combine-4.6.7
  (crate-source "combine" "4.6.7"
                "1z8rh8wp59gf8k23ar010phgs0wgf5i8cx4fg01gwcnzfn5k0nms"))

(define rust-compression-codecs-0.4.38
  (crate-source "compression-codecs" "0.4.38"
                "1kqq2b8hpv7y3jnakkp66cdlrzl6my02dapn3g12j6cw3qwlh9ff"))

(define rust-compression-core-0.4.32
  (crate-source "compression-core" "0.4.32"
                "12bp209x76flr67jm5fql4hq8d14nkjzkk24g9gi0yh2rxjza56c"))

(define rust-console-0.16.3
  (crate-source "console" "0.16.3"
                "11zwz1vnfr0nx6dyjx0gjymp8864y5hxwf01ynfd2s8kapsqlknn"))

(define rust-core-foundation-0.10.1
  (crate-source "core-foundation" "0.10.1"
                "1xjns6dqf36rni2x9f47b65grxwdm20kwdg9lhmzdrrkwadcv9mj"))

(define rust-core-foundation-0.9.4
  (crate-source "core-foundation" "0.9.4"
                "13zvbbj07yk3b61b8fhwfzhy35535a583irf23vlcg59j7h9bqci"))

(define rust-core-foundation-sys-0.8.7
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "core-foundation-sys" "0.8.7"
                "12w8j73lazxmr1z0h98hf3z623kl8ms7g07jch7n4p8f9nwlhdkp"))

(define rust-cpufeatures-0.3.0
  (crate-source "cpufeatures" "0.3.0"
                "00fjhygsqmh4kbxxlb99mcsbspxcai6hjydv4c46pwb67wwl2alb"))

(define rust-crc32fast-1.5.0
  (crate-source "crc32fast" "1.5.0"
                "04d51liy8rbssra92p0qnwjw8i9rm9c4m3bwy19wjamz1k4w30cl"))

(define rust-criterion-0.8.2
  (crate-source "criterion" "0.8.2"
                "1wwq9pfildrkqgb5pq3mwmv297kvvsizkx7m6sjzk4i4mar4c04m"))

(define rust-criterion-plot-0.8.2
  (crate-source "criterion-plot" "0.8.2"
                "1si9mrnzgs0123mr6d5pmhxq29rxph2q6pbvwjal6mav9wphmn6q"))

(define rust-critical-section-1.2.0
  (crate-source "critical-section" "1.2.0"
                "02ylhcykxjc40xrfhk1lwc21jqgz4dbwv3jr49ymw733c51yl3kr"))

(define rust-crossbeam-channel-0.5.15
  (crate-source "crossbeam-channel" "0.5.15"
                "1cicd9ins0fkpfgvz9vhz3m9rpkh6n8d3437c3wnfsdkd3wgif42"))

(define rust-crossbeam-deque-0.8.6
  (crate-source "crossbeam-deque" "0.8.6"
                "0l9f1saqp1gn5qy0rxvkmz4m6n7fc0b3dbm6q1r5pmgpnyvi3lcx"))

(define rust-crossbeam-epoch-0.9.18
  (crate-source "crossbeam-epoch" "0.9.18"
                "03j2np8llwf376m3fxqx859mgp9f83hj1w34153c7a9c7i5ar0jv"))

(define rust-crossbeam-utils-0.8.21
  (crate-source "crossbeam-utils" "0.8.21"
                "0a3aa2bmc8q35fb67432w16wvi54sfmb69rk9h5bhd18vw0c99fh"))

(define rust-crunchy-0.2.4
  (crate-source "crunchy" "0.2.4"
                "1mbp5navim2qr3x48lyvadqblcxc1dm0lqr0swrkkwy2qblvw3s6"))

(define rust-data-encoding-2.11.0
  (crate-source "data-encoding" "2.11.0"
                "1j00wfmk4dzn4bnib07qlhylmd6a3kizwjz8mp00iix3vlamzbm4"))

(define rust-deranged-0.5.8
  (crate-source "deranged" "0.5.8"
                "0711df3w16vx80k55ivkwzwswziinj4dz05xci3rvmn15g615n3w"))

(define rust-diff-0.1.13
  (crate-source "diff" "0.1.13"
                "1j0nzjxci2zqx63hdcihkp0a4dkdmzxd7my4m7zk6cjyfy34j9an"))

(define rust-displaydoc-0.2.5
  (crate-source "displaydoc" "0.2.5"
                "1q0alair462j21iiqwrr21iabkfnb13d6x5w95lkdg21q2xrqdlp"))

(define rust-dunce-1.0.5
  (crate-source "dunce" "1.0.5"
                "04y8wwv3vvcqaqmqzssi6k0ii9gs6fpz96j5w9nky2ccsl23axwj"))

(define rust-either-1.15.0
  (crate-source "either" "1.15.0"
                "069p1fknsmzn9llaizh77kip0pqmcwpdsykv2x30xpjyija5gis8"))

(define rust-encode-unicode-1.0.0
  (crate-source "encode_unicode" "1.0.0"
                "1h5j7j7byi289by63s3w4a8b3g6l5ccdrws7a67nn07vdxj77ail"))

(define rust-equivalent-1.0.2
  (crate-source "equivalent" "1.0.2"
                "03swzqznragy8n0x31lqc78g2af054jwivp7lkrbrc0khz74lyl7"))

(define rust-errno-0.3.14
  (crate-source "errno" "0.3.14"
                "1szgccmh8vgryqyadg8xd58mnwwicf39zmin3bsn63df2wbbgjir"))

(define rust-fallible-iterator-0.3.0
  (crate-source "fallible-iterator" "0.3.0"
                "0ja6l56yka5vn4y4pk6hn88z0bpny7a8k1919aqjzp0j1yhy9k1a"))

(define rust-fallible-streaming-iterator-0.1.9
  (crate-source "fallible-streaming-iterator" "0.1.9"
                "0nj6j26p71bjy8h42x6jahx1hn0ng6mc2miwpgwnp8vnwqf4jq3k"))

(define rust-fastrand-2.4.1
  (crate-source "fastrand" "2.4.1"
                "1mnqxxnxvd69ma9mczabpbbsgwlhd6l78yv3vd681453a9s247wz"))

(define rust-find-msvc-tools-0.1.9
  (crate-source "find-msvc-tools" "0.1.9"
                "10nmi0qdskq6l7zwxw5g56xny7hb624iki1c39d907qmfh3vrbjv"))

(define rust-flate2-1.1.9
  (crate-source "flate2" "1.1.9"
                "0g2pb7cxnzcbzrj8bw4v6gpqqp21aycmf6d84rzb6j748qkvlgw4"))

(define rust-fnv-1.0.7
  (crate-source "fnv" "1.0.7"
                "1hc2mcqha06aibcaza94vbi81j6pr9a1bbxrxjfhc91zin8yr7iz"))

(define rust-foldhash-0.1.5
  (crate-source "foldhash" "0.1.5"
                "1wisr1xlc2bj7hk4rgkcjkz3j2x4dhd1h9lwk7mj8p71qpdgbi6r"))

(define rust-foldhash-0.2.0
  (crate-source "foldhash" "0.2.0"
                "1nvgylb099s11xpfm1kn2wcsql080nqmnhj1l25bp3r2b35j9kkp"))

(define rust-form-urlencoded-1.2.2
  (crate-source "form_urlencoded" "1.2.2"
                "1kqzb2qn608rxl3dws04zahcklpplkd5r1vpabwga5l50d2v4k6b"))

(define rust-fs-extra-1.3.0
  (crate-source "fs_extra" "1.3.0"
                "075i25z70j2mz9r7i9p9r521y8xdj81q7skslyb7zhqnnw33fw22"))

(define rust-futures-0.3.32
  (crate-source "futures" "0.3.32"
                "0b9q86r5ar18v5xjiyqn7sb8sa32xv98qqnfz779gl7ns7lpw54b"))

(define rust-futures-channel-0.3.32
  (crate-source "futures-channel" "0.3.32"
                "07fcyzrmbmh7fh4ainilf1s7gnwvnk07phdq77jkb9fpa2ffifq7"))

(define rust-futures-core-0.3.32
  (crate-source "futures-core" "0.3.32"
                "07bbvwjbm5g2i330nyr1kcvjapkmdqzl4r6mqv75ivvjaa0m0d3y"))

(define rust-futures-executor-0.3.32
  (crate-source "futures-executor" "0.3.32"
                "17aplz3ns74qn7a04qg7qlgsdx5iwwwkd4jvdfra6hl3h4w9rwms"))

(define rust-futures-io-0.3.32
  (crate-source "futures-io" "0.3.32"
                "063pf5m6vfmyxj74447x8kx9q8zj6m9daamj4hvf49yrg9fs7jyf"))

(define rust-futures-macro-0.3.32
  (crate-source "futures-macro" "0.3.32"
                "0ys4b1lk7s0bsj29pv42bxsaavalch35rprp64s964p40c1bfdg8"))

(define rust-futures-sink-0.3.32
  (crate-source "futures-sink" "0.3.32"
                "14q8ml7hn5a6gyy9ri236j28kh0svqmrk4gcg0wh26rkazhm95y3"))

(define rust-futures-task-0.3.32
  (crate-source "futures-task" "0.3.32"
                "14s3vqf8llz3kjza33vn4ixg6kwxp61xrysn716h0cwwsnri2xq3"))

(define rust-futures-util-0.3.32
  (crate-source "futures-util" "0.3.32"
                "1mn60lw5kh32hz9isinjlpw34zx708fk5q1x0m40n6g6jq9a971q"))

(define rust-getrandom-0.2.17
  (crate-source "getrandom" "0.2.17"
                "1l2ac6jfj9xhpjjgmcx6s1x89bbnw9x6j9258yy6xjkzpq0bqapz"))

(define rust-getrandom-0.3.4
  (crate-source "getrandom" "0.3.4"
                "1zbpvpicry9lrbjmkd4msgj3ihff1q92i334chk7pzf46xffz7c9"))

(define rust-getrandom-0.4.2
  (crate-source "getrandom" "0.4.2"
                "0mb5833hf9pvn9dhvxjgfg5dx0m77g8wavvjdpvpnkp9fil1xr8d"))

(define rust-glob-0.3.3
  (crate-source "glob" "0.3.3"
                "106jpd3syfzjfj2k70mwm0v436qbx96wig98m4q8x071yrq35hhc"))

(define rust-h2-0.4.13
  (crate-source "h2" "0.4.13"
                "0m6w5gg0n0m1m5915bxrv8n4rlazhx5icknkslz719jhh4xdli1g"))

(define rust-h3-0.0.8
  (crate-source "h3" "0.0.8"
                "1gmkarh037aaxhmncycsxcjszmkidbfghz6wd4dq4amhrxajp1qh"))

(define rust-h3-quinn-0.0.10
  (crate-source "h3-quinn" "0.0.10"
                "1d7qqjzvqzxb2dr216kvajzjy105nnd4gj1scqqlg9wiiln76blb"))

(define rust-half-2.7.1
  (crate-source "half" "2.7.1"
                "0jyq42xfa6sghc397mx84av7fayd4xfxr4jahsqv90lmjr5xi8kf"))

(define rust-hashbrown-0.15.5
  (crate-source "hashbrown" "0.15.5"
                "189qaczmjxnikm9db748xyhiw04kpmhm9xj9k9hg0sgx7pjwyacj"))

(define rust-hashbrown-0.16.1
  (crate-source "hashbrown" "0.16.1"
                "004i3njw38ji3bzdp9z178ba9x3k0c1pgy8x69pj7yfppv4iq7c4"))

(define rust-hashbrown-0.17.0
  (crate-source "hashbrown" "0.17.0"
                "0l8gvcz80lvinb7x22h53cqbi2y1fm603y2jhhh9qwygvkb7sijg"))

(define rust-hashlink-0.11.0
  (crate-source "hashlink" "0.11.0"
                "0c6jpsyb9f3j5yrlbw8rnr5kpkar08z02b1h3b5sf14w39b242za"))

(define rust-heck-0.5.0
  (crate-source "heck" "0.5.0"
                "1sjmpsdl8czyh9ywl3qcsfsq9a307dg4ni2vnlwgnzzqhc4y0113"))

(define rust-hex-0.4.3
  (crate-source "hex" "0.4.3"
                "0w1a4davm1lgzpamwnba907aysmlrnygbqmfis2mqjx5m552a93z"))

(define rust-hickory-net-0.26.0
  (crate-source "hickory-net" "0.26.0"
                "19p9wqg2viwfkk7wjbigwbxsqhkmv25p98pjz2liprgs8zdwhq8c"))

(define rust-hickory-proto-0.26.0
  (crate-source "hickory-proto" "0.26.0"
                "1k0zmhrsflwk286azwg8b7jlsz6rg9ksppxa2p5rxn808r4x05m9"))

(define rust-hickory-resolver-0.26.0
  (crate-source "hickory-resolver" "0.26.0"
                "0i752xhdrrd5575wz442zdaljbki63i8lp724753hk8bjm6xc2x1"))

(define rust-hickory-server-0.26.0
  (crate-source "hickory-server" "0.26.0"
                "00lzji0p19kdj6k7v0dfd07hbw8lazqnry6ld17grcg6x1b5ywli"))

(define rust-hostname-0.4.2
  (crate-source "hostname" "0.4.2"
                "1g8cfg0a1v8y5a0zkncbns8hh24amjgskl39cc583wxfawsslyk1"))

(define rust-http-1.4.0
  (crate-source "http" "1.4.0"
                "06iind4cwsj1d6q8c2xgq8i2wka4ps74kmws24gsi1bzdlw2mfp3"))

(define rust-http-body-1.0.1
  (crate-source "http-body" "1.0.1"
                "111ir5k2b9ihz5nr9cz7cwm7fnydca7dx4hc7vr16scfzghxrzhy"))

(define rust-http-body-util-0.1.3
  (crate-source "http-body-util" "0.1.3"
                "0jm6jv4gxsnlsi1kzdyffjrj8cfr3zninnxpw73mvkxy4qzdj8dh"))

(define rust-httparse-1.10.1
  (crate-source "httparse" "1.10.1"
                "11ycd554bw2dkgw0q61xsa7a4jn1wb1xbfacmf3dbwsikvkkvgvd"))

(define rust-httpdate-1.0.3
  (crate-source "httpdate" "1.0.3"
                "1aa9rd2sac0zhjqh24c9xvir96g188zldkx0hr6dnnlx5904cfyz"))

(define rust-hyper-1.9.0
  (crate-source "hyper" "1.9.0"
                "1jmwbwqcaficskg76kq402gbymbnh2z4v99xwq3l5aa6n8bg16b2"))

(define rust-hyper-util-0.1.20
  (crate-source "hyper-util" "0.1.20"
                "186zdc58hmm663csmjvrzgkr6jdh93sfmi3q2pxi57gcaqjpqm4n"))

(define rust-iana-time-zone-0.1.65
  (crate-source "iana-time-zone" "0.1.65"
                "0w64khw5p8s4nzwcf36bwnsmqzf61vpwk9ca1920x82bk6nwj6z3"))

(define rust-iana-time-zone-haiku-0.1.2
  (crate-source "iana-time-zone-haiku" "0.1.2"
                "17r6jmj31chn7xs9698r122mapq85mfnv98bb4pg6spm0si2f67k"))

(define rust-icu-collections-2.2.0
  (crate-source "icu_collections" "2.2.0"
                "070r7xd0pynm0hnc1v2jzlbxka6wf50f81wybf9xg0y82v6x3119"))

(define rust-icu-locale-core-2.2.0
  (crate-source "icu_locale_core" "2.2.0"
                "0a9cmin5w1x3bg941dlmgszn33qgq428k7qiqn5did72ndi9n8cj"))

(define rust-icu-normalizer-2.2.0
  (crate-source "icu_normalizer" "2.2.0"
                "1d7krxr0xpc4x9635k1100a24nh0nrc59n65j6yk6gbfkplmwvn5"))

(define rust-icu-normalizer-data-2.2.0
  (crate-source "icu_normalizer_data" "2.2.0"
                "0f5d5d5fhhr9937m2z6z38fzh6agf14z24kwlr6lyczafypf0fys"))

(define rust-icu-properties-2.2.0
  (crate-source "icu_properties" "2.2.0"
                "1pkh3s837808cbwxvfagwc28cvwrz2d9h5rl02jwrhm51ryvdqxy"))

(define rust-icu-properties-data-2.2.0
  (crate-source "icu_properties_data" "2.2.0"
                "052awny0qwkbcbpd5jg2cd7vl5ry26pq4hz1nfsgf10c3qhbnawf"))

(define rust-icu-provider-2.2.0
  (crate-source "icu_provider" "2.2.0"
                "08dl8pxbwr8zsz4c5vphqb7xw0hykkznwi4rw7bk6pwb3krlr70k"))

(define rust-id-arena-2.3.0
  (crate-source "id-arena" "2.3.0"
                "0m6rs0jcaj4mg33gkv98d71w3hridghp5c4yr928hplpkgbnfc1x"))

(define rust-idna-1.1.0
  (crate-source "idna" "1.1.0"
                "1pp4n7hppm480zcx411dsv9wfibai00wbpgnjj4qj0xa7kr7a21v"))

(define rust-idna-adapter-1.2.1
  (crate-source "idna_adapter" "1.2.1"
                "0i0339pxig6mv786nkqcxnwqa87v4m94b2653f6k3aj0jmhfkjis"))

(define rust-indexmap-2.14.0
  (crate-source "indexmap" "2.14.0"
                "1na9z6f0d5pkjr1lgsni470v98gv2r7c41j8w48skr089x2yjrnl"))

(define rust-ipconfig-0.3.4
  (crate-source "ipconfig" "0.3.4"
                "08l2nk7q2kasbsixpdj83jb62rixys7xc2k3n3j6qgg31h64ch2d"))

(define rust-ipnet-2.12.0
  (crate-source "ipnet" "2.12.0"
                "1qpq2y0asyv0jppw7zww9y96fpnpinwap8a0phhqqgyy3znnz3yr"))

(define rust-iri-string-0.7.12
  (crate-source "iri-string" "0.7.12"
                "082fpx6c5ghvmqpwxaf2b268m47z2ic3prajqbmi1s1qpfj5kri5"))

(define rust-is-terminal-polyfill-1.70.2
  (crate-source "is_terminal_polyfill" "1.70.2"
                "15anlc47sbz0jfs9q8fhwf0h3vs2w4imc030shdnq54sny5i7jx6"))

(define rust-itertools-0.12.1
  (crate-source "itertools" "0.12.1"
                "0s95jbb3ndj1lvfxyq5wanc0fm0r6hg6q4ngb92qlfdxvci10ads"))

(define rust-itertools-0.13.0
  (crate-source "itertools" "0.13.0"
                "11hiy3qzl643zcigknclh446qb9zlg4dpdzfkjaa9q9fqpgyfgj1"))

(define rust-itoa-1.0.18
  (crate-source "itoa" "1.0.18"
                "10jnd1vpfkb8kj38rlkn2a6k02afvj3qmw054dfpzagrpl6achlg"))

(define rust-jni-0.22.4
  (crate-source "jni" "0.22.4"
                "161lza8gz071h22pgyqyx4n91ixd691z2dbb1pq2g97k5i49mzay"))

(define rust-jni-macros-0.22.4
  (crate-source "jni-macros" "0.22.4"
                "18v02mcn5c7mb2yw6r930xg6ynsn7hwkxv8z2kdhn3qprjn0j0d0"))

(define rust-jni-sys-0.4.1
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "jni-sys" "0.4.1"
                "1wlahx6f2zhczdjqyn8mk7kshb8x5vsd927sn3lvw41rrf47ldy6"))

(define rust-jni-sys-macros-0.4.1
  (crate-source "jni-sys-macros" "0.4.1"
                "0r32gbabrak15a7p487765b5wc0jcna2yv88mk6m1zjqyi1bkh1q"))

(define rust-jobserver-0.1.34
  (crate-source "jobserver" "0.1.34"
                "0cwx0fllqzdycqn4d6nb277qx5qwnmjdxdl0lxkkwssx77j3vyws"))

(define rust-js-sys-0.3.95
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "js-sys" "0.3.95"
                "1jhj3kgxxgwm0cpdjiz7i2qapqr7ya9qswadmr63dhwx3lnyjr19"))

(define rust-lazy-static-1.5.0
  (crate-source "lazy_static" "1.5.0"
                "1zk6dqqni0193xg6iijh7i3i44sryglwgvx20spdvwk3r6sbrlmv"))

(define rust-leb128fmt-0.1.0
  (crate-source "leb128fmt" "0.1.0"
                "1chxm1484a0bly6anh6bd7a99sn355ymlagnwj3yajafnpldkv89"))

(define rust-libc-0.2.186
  (crate-source "libc" "0.2.186"
                "0rnyhzjyqq9x56skkllbjzzzwym3r61lq3l4hqj64v71gw0r3av8"))

(define rust-libloading-0.8.9
  (crate-source "libloading" "0.8.9"
                "0mfwxwjwi2cf0plxcd685yxzavlslz7xirss3b9cbrzyk4hv1i6p"))

(define rust-libproc-0.14.11
  (crate-source "libproc" "0.14.11"
                "0mq7k52kc1m43sbnragb3ybynkq03hjr8apxbwfk1icbickxfjm5"))

(define rust-libsqlite3-sys-0.37.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "libsqlite3-sys" "0.37.0"
                "1cdrrwqarq4rq873ni5645r9cqllc73l8knkkjj62z0yqk413wdi"))

(define rust-linked-hash-map-0.5.6
  (crate-source "linked-hash-map" "0.5.6"
                "03vpgw7x507g524nx5i1jf5dl8k3kv0fzg8v3ip6qqwbpkqww5q7"))

(define rust-linux-raw-sys-0.12.1
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "linux-raw-sys" "0.12.1"
                "0lwasljrqxjjfk9l2j8lyib1babh2qjlnhylqzl01nihw14nk9ij"))

(define rust-litemap-0.8.2
  (crate-source "litemap" "0.8.2"
                "1w7628bc7wwcxc4n4s5kw0610xk06710nh2hn5kwwk2wa91z9nlj"))

(define rust-lock-api-0.4.14
  (crate-source "lock_api" "0.4.14"
                "0rg9mhx7vdpajfxvdjmgmlyrn20ligzqvn8ifmaz7dc79gkrjhr2"))

(define rust-log-0.4.29
  (crate-source "log" "0.4.29"
                "15q8j9c8g5zpkcw0hnd6cf2z7fxqnvsjh3rw5mv5q10r83i34l2y"))

(define rust-lru-cache-0.1.2
  (crate-source "lru-cache" "0.1.2"
                "071viv6g2p3akwqmfb3c8vsycs5n7kr17b70l7la071jv0d4zqii"))

(define rust-lru-slab-0.1.2
  (crate-source "lru-slab" "0.1.2"
                "0m2139k466qj3bnpk66bwivgcx3z88qkxvlzk70vd65jq373jaqi"))

(define rust-mach2-0.6.0
  (crate-source "mach2" "0.6.0"
                "0asmmmvsvf9ipn2jszazhhlrqv8qgcglwdh0n3r470pna70hirns"))

(define rust-matchers-0.2.0
  (crate-source "matchers" "0.2.0"
                "1sasssspdj2vwcwmbq3ra18d3qniapkimfcbr47zmx6750m5llni"))

(define rust-memchr-2.8.0
  (crate-source "memchr" "2.8.0"
                "0y9zzxcqxvdqg6wyag7vc3h0blhdn7hkq164bxyx2vph8zs5ijpq"))

(define rust-metrics-0.24.3
  (crate-source "metrics" "0.24.3"
                "1s3p28qdd4x058jxkvm3a34p5ng32n1751dmc6lwyw9ppbli4lsx"))

(define rust-metrics-exporter-prometheus-0.18.1
  (crate-source "metrics-exporter-prometheus" "0.18.1"
                "1nmwkpwm6hzg90dvb0v5fkc7rf0m21cmij3fab2psk608fanb29m"))

(define rust-metrics-process-2.4.3
  (crate-source "metrics-process" "2.4.3"
                "1b1w2rwlzmx43dr3xsh1azk0p8ady21wckria6kgalm7cizxhs22"))

(define rust-metrics-util-0.20.1
  (crate-source "metrics-util" "0.20.1"
                "1r3b15gn6fg9v8wxcfjk2ilwi2qrf3sikg0xvkcnszm2zrji7yyd"))

(define rust-minimal-lexical-0.2.1
  (crate-source "minimal-lexical" "0.2.1"
                "16ppc5g84aijpri4jzv14rvcnslvlpphbszc7zzp6vfkddf4qdb8"))

(define rust-miniz-oxide-0.8.9
  (crate-source "miniz_oxide" "0.8.9"
                "05k3pdg8bjjzayq3rf0qhpirq9k37pxnasfn4arbs17phqn6m9qz"))

(define rust-mio-1.2.0
  (crate-source "mio" "1.2.0"
                "1hanrh4fwsfkdqdaqfidz48zz1wdix23zwn3r2x78am0garfbdsh"))

(define rust-moka-0.12.15
  (crate-source "moka" "0.12.15"
                "0ijhgjfprcjkvrhgmm71m9gaph5lc9xjb3rwz4wyhbh42anjhwlm"))

(define rust-ndk-context-0.1.1
  (crate-source "ndk-context" "0.1.1"
                "12sai3dqsblsvfd1l1zab0z6xsnlha3xsfl7kagdnmj3an3jvc17"))

(define rust-nom-7.1.3
  (crate-source "nom" "7.1.3"
                "0jha9901wxam390jcf5pfa0qqfrgh8li787jx2ip0yk5b8y9hwyj"))

(define rust-num-conv-0.2.1
  (crate-source "num-conv" "0.2.1"
                "0rqrr29brafaa2za352pbmhkk556n7f8z9rrkgmjp1idvdl3fry6"))

(define rust-num-traits-0.2.19
  (crate-source "num-traits" "0.2.19"
                "0h984rhdkkqd4ny9cif7y2azl3xdfb7768hb9irhpsch4q3gq787"))

(define rust-once-cell-1.21.4
  (crate-source "once_cell" "1.21.4"
                "0l1v676wf71kjg2khch4dphwh1jp3291ffiymr2mvy1kxd5kwz4z"))

(define rust-once-cell-polyfill-1.70.2
  (crate-source "once_cell_polyfill" "1.70.2"
                "1zmla628f0sk3fhjdjqzgxhalr2xrfna958s632z65bjsfv8ljrq"))

(define rust-oorandom-11.1.5
  (crate-source "oorandom" "11.1.5"
                "07mlf13z453fq01qff38big1lh83j8l6aaglf63ksqzzqxc0yyfn"))

(define rust-openssl-probe-0.2.1
  (crate-source "openssl-probe" "0.2.1"
                "1gpwpb7smfhkscwvbri8xzbab39wcnby1jgz1s49vf1aqgsdx1vw"))

(define rust-ordered-float-5.3.0
  (crate-source "ordered-float" "5.3.0"
                "03mx5yg3ncp0g524y7zbyvhwcxpd8l9v30lgybm5bhqx2v551ndp"))

(define rust-page-size-0.6.0
  (crate-source "page_size" "0.6.0"
                "1nj0rrwpvagagssljbm29ww1iyrrg15p1q4sk70r2cfi9qcv5m9h"))

(define rust-parking-lot-0.12.5
  (crate-source "parking_lot" "0.12.5"
                "06jsqh9aqmc94j2rlm8gpccilqm6bskbd67zf6ypfc0f4m9p91ck"))

(define rust-parking-lot-core-0.9.12
  (crate-source "parking_lot_core" "0.9.12"
                "1hb4rggy70fwa1w9nb0svbyflzdc69h047482v2z3sx2hmcnh896"))

(define rust-percent-encoding-2.3.2
  (crate-source "percent-encoding" "2.3.2"
                "083jv1ai930azvawz2khv7w73xh8mnylk7i578cifndjn5y64kwv"))

(define rust-pin-project-lite-0.2.17
  (crate-source "pin-project-lite" "0.2.17"
                "1kfmwvs271si96zay4mm8887v5khw0c27jc9srw1a75ykvgj54x8"))

(define rust-pkg-config-0.3.33
  (crate-source "pkg-config" "0.3.33"
                "17jnqmcbxsnwhg9gjf0nh6dj5k0x3hgwi3mb9krjnmfa9v435w8r"))

(define rust-plotters-0.3.7
  (crate-source "plotters" "0.3.7"
                "0ixpy9svpmr2rkzkxvvdpysjjky4gw104d73n7pi2jbs7m06zsss"))

(define rust-plotters-backend-0.3.7
  (crate-source "plotters-backend" "0.3.7"
                "0ahpliim4hrrf7d4ispc2hwr7rzkn6d6nf7lyyrid2lm28yf2hnz"))

(define rust-plotters-svg-0.3.7
  (crate-source "plotters-svg" "0.3.7"
                "0w56sxaa2crpasa1zj0bhxzihlapqfkncggavyngg0w86anf5fji"))

(define rust-portable-atomic-1.13.1
  (crate-source "portable-atomic" "1.13.1"
                "0j8vlar3n5acyigq8q6f4wjx3k3s5yz0rlpqrv76j73gi5qr8fn3"))

(define rust-potential-utf-0.1.5
  (crate-source "potential_utf" "0.1.5"
                "0r0518fr32xbkgzqap509s3r60cr0iancsg9j1jgf37cyz7b20q1"))

(define rust-powerfmt-0.2.0
  (crate-source "powerfmt" "0.2.0"
                "14ckj2xdpkhv3h6l5sdmb9f1d57z8hbfpdldjc2vl5givq2y77j3"))

(define rust-ppv-lite86-0.2.21
  (crate-source "ppv-lite86" "0.2.21"
                "1abxx6qz5qnd43br1dd9b2savpihzjza8gb4fbzdql1gxp2f7sl5"))

(define rust-prefix-trie-0.8.2
  (crate-source "prefix-trie" "0.8.2"
                "00rmm0j1qprc9k8am3f7jfk7j0h4xd3j185lraqcnnvyigkhndr3"))

(define rust-pretty-assertions-1.4.1
  (crate-source "pretty_assertions" "1.4.1"
                "0v8iq35ca4rw3rza5is3wjxwsf88303ivys07anc5yviybi31q9s"))

(define rust-prettyplease-0.2.37
  (crate-source "prettyplease" "0.2.37"
                "0azn11i1kh0byabhsgab6kqs74zyrg69xkirzgqyhz6xmjnsi727"))

(define rust-proc-macro2-1.0.106
  (crate-source "proc-macro2" "1.0.106"
                "0d09nczyaj67x4ihqr5p7gxbkz38gxhk4asc0k8q23g9n85hzl4g"))

(define rust-procfs-0.18.0
  (crate-source "procfs" "0.18.0"
                "1xw25dx4cfc2z745w0dz4vhv24z7dprcxyk0km1n2s2dlmh56j15"))

(define rust-procfs-core-0.18.0
  (crate-source "procfs-core" "0.18.0"
                "01g4lil280nacsd196xpfmvz5bp949dd2r9nas5zf8mgnvvinh76"))

(define rust-prometheus-parse-0.2.5
  (crate-source "prometheus-parse" "0.2.5"
                "19bq7g8m54qqlc4khimc0ki02rna5j07vwz1n8gl0njylsz32441"))

(define rust-quanta-0.12.6
  (crate-source "quanta" "0.12.6"
                "1iq6iz61rf76vmj7bvjhvsfcz6509qpbs6chr2yrf3bgfnfmmazk"))

(define rust-quinn-0.11.9
  (crate-source "quinn" "0.11.9"
                "086gzj666dr3slmlynkvxlndy28hahgl361d6bf93hk3i6ahmqmr"))

(define rust-quinn-proto-0.11.14
  (crate-source "quinn-proto" "0.11.14"
                "1660jkxhzi1pnywzs13ifczwrlv6ds9qds111vsnxjciqpz44js3"))

(define rust-quinn-udp-0.5.14
  (crate-source "quinn-udp" "0.5.14"
                "1gacawr17a2zkyri0r3m0lc9spzmxbq1by3ilyb8v2mdvjhcdpmd"))

(define rust-quote-1.0.45
  (crate-source "quote" "1.0.45"
                "095rb5rg7pbnwdp6v8w5jw93wndwyijgci1b5lw8j1h5cscn3wj1"))

(define rust-r-efi-5.3.0
  (crate-source "r-efi" "5.3.0"
                "03sbfm3g7myvzyylff6qaxk4z6fy76yv860yy66jiswc2m6b7kb9"))

(define rust-r-efi-6.0.0
  (crate-source "r-efi" "6.0.0"
                "1gyrl2k5fyzj9k7kchg2n296z5881lg7070msabid09asp3wkp7q"))

(define rust-rand-0.10.1
  (crate-source "rand" "0.10.1"
                "01r22vdpw6z69jzy6khnyr0ljq9im337h4j0mkyz26lnqyyfis6j"))

(define rust-rand-0.9.4
  (crate-source "rand" "0.9.4"
                "1sknbxgs6nfg0nxdd7689lwbyr2i4vaswchrv4b34z8vpc3azia4"))

(define rust-rand-chacha-0.9.0
  (crate-source "rand_chacha" "0.9.0"
                "1jr5ygix7r60pz0s1cv3ms1f6pd1i9pcdmnxzzhjc3zn3mgjn0nk"))

(define rust-rand-core-0.10.1
  (crate-source "rand_core" "0.10.1"
                "0s9wiacxrr100icl7i41308gcj85nlcclrc5jx1jd6p10dhigf33"))

(define rust-rand-core-0.9.5
  (crate-source "rand_core" "0.9.5"
                "0g6qc5r3f0hdmz9b11nripyp9qqrzb0xqk9piip8w8qlvqkcibvn"))

(define rust-rand-xoshiro-0.7.0
  (crate-source "rand_xoshiro" "0.7.0"
                "0h9dv9mn703zb2z5dys7vc4rzy3az8xg99fc5m8zbnh0axkg80zp"))

(define rust-raw-cpuid-11.6.0
  (crate-source "raw-cpuid" "11.6.0"
                "11j1lmrjqqnc43bxkrz0xai1g9piw3z9aap53qsj8cnpb7fd1329"))

(define rust-rayon-1.12.0
  (crate-source "rayon" "1.12.0"
                "0vcj63xgnk72c30vdrak7dhl53snnaqv9x2faf1d94hzg1kb2fgv"))

(define rust-rayon-core-1.13.0
  (crate-source "rayon-core" "1.13.0"
                "14dbr0sq83a6lf1rfjq5xdpk5r6zgzvmzs5j6110vlv2007qpq92"))

(define rust-redox-syscall-0.5.18
  (crate-source "redox_syscall" "0.5.18"
                "0b9n38zsxylql36vybw18if68yc9jczxmbyzdwyhb9sifmag4azd"))

(define rust-regex-1.12.3
  (crate-source "regex" "1.12.3"
                "0xp2q0x7ybmpa5zlgaz00p8zswcirj9h8nry3rxxsdwi9fhm81z1"))

(define rust-regex-automata-0.4.14
  (crate-source "regex-automata" "0.4.14"
                "13xf7hhn4qmgfh784llcp2kzrvljd13lb2b1ca0mwnf15w9d87bf"))

(define rust-regex-syntax-0.8.10
  (crate-source "regex-syntax" "0.8.10"
                "02jx311ka0daxxc7v45ikzhcl3iydjbbb0mdrpc1xgg8v7c7v2fw"))

(define rust-reqwest-0.13.2
  (crate-source "reqwest" "0.13.2"
                "00d8xyrbcp0519rr9rhl685ymb6hi3lv0i2bca5lic9s53il6gxb"))

(define rust-resolv-conf-0.7.6
  (crate-source "resolv-conf" "0.7.6"
                "1ivhckfhn7zksvid506w8dhrs001cix0mbp45l23i3fb90dis1hy"))

(define rust-ring-0.17.14
  (crate-source "ring" "0.17.14"
                "1dw32gv19ccq4hsx3ribhpdzri1vnrlcfqb2vj41xn4l49n9ws54"))

(define rust-rlimit-0.11.0
  (crate-source "rlimit" "0.11.0"
                "1hwcp4z2snw1xkigmprv6yvjixrmh7vnnhxsdl7n3fsnkirf4ppk"))

(define rust-rsqlite-vfs-0.1.0
  (crate-source "rsqlite-vfs" "0.1.0"
                "0kap86yzwl355byfs891185h723nxvl746fdp8gnpvrna0qz58d8"))

(define rust-rusqlite-0.39.0
  (crate-source "rusqlite" "0.39.0"
                "0knd7cqpz58v2lac6gzbdrals1jm5axw01xiggv1nrnrdlab1lm0"))

(define rust-rustc-hash-2.1.2
  (crate-source "rustc-hash" "2.1.2"
                "1gjdc5bw9982cj176jvgz9rrqf9xvr1q1ddpzywf5qhs7yzhlc4l"))

(define rust-rustc-version-0.4.1
  (crate-source "rustc_version" "0.4.1"
                "14lvdsmr5si5qbqzrajgb6vfn69k0sfygrvfvr2mps26xwi3mjyg"))

(define rust-rustix-1.1.4
  (crate-source "rustix" "1.1.4"
                "14511f9yjqh0ix07xjrjpllah3325774gfwi9zpq72sip5jlbzmn"))

(define rust-rustls-0.23.39
  (crate-source "rustls" "0.23.39"
                "03p6fkdwbdpp93dfidc4nzgmalwp3gxnv0rk421a5k3pn2612b3w"))

(define rust-rustls-native-certs-0.8.3
  (crate-source "rustls-native-certs" "0.8.3"
                "0qrajg2n90bcr3bcq6j95gjm7a9lirfkkdmjj32419dyyzan0931"))

(define rust-rustls-pki-types-1.14.1
  (crate-source "rustls-pki-types" "1.14.1"
                "1a9pr54y0f3qr97bxpd3ahjldq0gqdld0h799xbnwdzbwxx1k9rh"))

(define rust-rustls-platform-verifier-0.7.0
  (crate-source "rustls-platform-verifier" "0.7.0"
                "181v4d0vl53vdh2wq56vghal1zyhdgqvy4xa8r45zwz4di9y5l96"))

(define rust-rustls-platform-verifier-android-0.1.1
  (crate-source "rustls-platform-verifier-android" "0.1.1"
                "13vq6sxsgz9547xm2zbdxiw8x7ad1g8n8ax6xvxsjqszk7q6awgq"))

(define rust-rustls-webpki-0.103.13
  (crate-source "rustls-webpki" "0.103.13"
                "0vkm7z9pnxz5qz66p2kmyy2pwx0g4jnsbqk5xzfhs4czcjl2ki31"))

(define rust-rustversion-1.0.22
  (crate-source "rustversion" "1.0.22"
                "0vfl70jhv72scd9rfqgr2n11m5i9l1acnk684m2w83w0zbqdx75k"))

(define rust-same-file-1.0.6
  (crate-source "same-file" "1.0.6"
                "00h5j1w87dmhnvbv9l8bic3y7xxsnjmssvifw2ayvgx9mb1ivz4k"))

(define rust-schannel-0.1.29
  (crate-source "schannel" "0.1.29"
                "0ffrzz5vf2s3gnzvphgb5gg8fqifvryl07qcf7q3x1scj3jbghci"))

(define rust-scopeguard-1.2.0
  (crate-source "scopeguard" "1.2.0"
                "0jcz9sd47zlsgcnm1hdw0664krxwb5gczlif4qngj2aif8vky54l"))

(define rust-sd-notify-0.5.0
  (crate-source "sd-notify" "0.5.0"
                "0xpy528vqfasq389pwg9z86w0m0bfsfhz8r7vpqzljv9kqszfkiy"))

(define rust-security-framework-3.7.0
  (crate-source "security-framework" "3.7.0"
                "07fd0j29j8yczb3hd430vwz784lx9knb5xwbvqna1nbkbivvrx5p"))

(define rust-security-framework-sys-2.17.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "security-framework-sys" "2.17.0"
                "1qr0w0y9iwvmv3hwg653q1igngnc5b74xcf0679cbv23z0fnkqkc"))

(define rust-semver-1.0.28
  (crate-source "semver" "1.0.28"
                "1kaimrpy876bcgi8bfj0qqfxk77zm9iz2zhn1hp9hj685z854y4a"))

(define rust-serde-1.0.228
  (crate-source "serde" "1.0.228"
                "17mf4hhjxv5m90g42wmlbc61hdhlm6j9hwfkpcnd72rpgzm993ls"))

(define rust-serde-core-1.0.228
  (crate-source "serde_core" "1.0.228"
                "1bb7id2xwx8izq50098s5j2sqrrvk31jbbrjqygyan6ask3qbls1"))

(define rust-serde-derive-1.0.228
  (crate-source "serde_derive" "1.0.228"
                "0y8xm7fvmr2kjcd029g9fijpndh8csv5m20g4bd76w8qschg4h6m"))

(define rust-serde-json-1.0.149
  (crate-source "serde_json" "1.0.149"
                "11jdx4vilzrjjd1dpgy67x5lgzr0laplz30dhv75lnf5ffa07z43"))

(define rust-serde-spanned-1.1.1
  (crate-source "serde_spanned" "1.1.1"
                "09jzk7i6wihn3d8i3wi4j4n98ghi93c3b8m8k64nxq0ijn3vaqk6"))

(define rust-sharded-slab-0.1.7
  (crate-source "sharded-slab" "0.1.7"
                "1xipjr4nqsgw34k7a2cgj9zaasl2ds6jwn89886kww93d32a637l"))

(define rust-shlex-1.3.0
  (crate-source "shlex" "1.3.0"
                "0r1y6bv26c1scpxvhg2cabimrmwgbp4p3wy6syj9n0c4s3q2znhg"))

(define rust-signal-hook-registry-1.4.8
  (crate-source "signal-hook-registry" "1.4.8"
                "06vc7pmnki6lmxar3z31gkyg9cw7py5x9g7px70gy2hil75nkny4"))

(define rust-simd-adler32-0.3.9
  (crate-source "simd-adler32" "0.3.9"
                "0532ysdwcvzyp2bwpk8qz0hijplcdwpssr5gy5r7qwqqy5z5qgbh"))

(define rust-simd-cesu8-1.1.1
  (crate-source "simd_cesu8" "1.1.1"
                "0crcbgvyycmazji2vqj9vxn2czdyl3gxmicp4xqdzkc7pdbh3ycl"))

(define rust-simdutf8-0.1.5
  (crate-source "simdutf8" "0.1.5"
                "0vmpf7xaa0dnaikib5jlx6y4dxd3hxqz6l830qb079g7wcsgxag3"))

(define rust-sketches-ddsketch-0.3.1
  (crate-source "sketches-ddsketch" "0.3.1"
                "0asak4kg6hz7kv4infbmqf3n7srdkgjng8fwqh61wrrdp6p76vqc"))

(define rust-slab-0.4.12
  (crate-source "slab" "0.4.12"
                "1xcwik6s6zbd3lf51kkrcicdq2j4c1fw0yjdai2apy9467i0sy8c"))

(define rust-smallvec-1.15.1
  (crate-source "smallvec" "1.15.1"
                "00xxdxxpgyq5vjnpljvkmy99xij5rxgh913ii1v16kzynnivgcb7"))

(define rust-socket2-0.6.3
  (crate-source "socket2" "0.6.3"
                "0gkjjcyn69hqhhlh5kl8byk5m0d7hyrp2aqwzbs3d33q208nwxis"))

(define rust-sqlite-wasm-rs-0.5.3
  (crate-source "sqlite-wasm-rs" "0.5.3"
                "0disglizpgix60hm9iq8f4dnd5f7537qllgfxbfhf11h0w37cb0v"))

(define rust-stable-deref-trait-1.2.1
  (crate-source "stable_deref_trait" "1.2.1"
                "15h5h73ppqyhdhx6ywxfj88azmrpml9gl6zp3pwy2malqa6vxqkc"))

(define rust-strsim-0.11.1
  (crate-source "strsim" "0.11.1"
                "0kzvqlw8hxqb7y598w1s0hxlnmi84sg5vsipp3yg5na5d1rvba3x"))

(define rust-subtle-2.6.1
  (crate-source "subtle" "2.6.1"
                "14ijxaymghbl1p0wql9cib5zlwiina7kall6w7g89csprkgbvhhk"))

(define rust-syn-2.0.117
  (crate-source "syn" "2.0.117"
                "16cv7c0wbn8amxc54n4w15kxlx5ypdmla8s0gxr2l7bv7s0bhrg6"))

(define rust-sync-wrapper-1.0.2
  (crate-source "sync_wrapper" "1.0.2"
                "0qvjyasd6w18mjg5xlaq5jgy84jsjfsvmnn12c13gypxbv75dwhb"))

(define rust-synstructure-0.13.2
  (crate-source "synstructure" "0.13.2"
                "1lh9lx3r3jb18f8sbj29am5hm9jymvbwh6jb1izsnnxgvgrp12kj"))

(define rust-system-configuration-0.7.0
  (crate-source "system-configuration" "0.7.0"
                "12rwilylzc625qnxl30h5kf8wj5ka61zjrwpmb034cd0mc6ksgx1"))

(define rust-system-configuration-sys-0.6.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "system-configuration-sys" "0.6.0"
                "1i5sqrmgy58l4704hibjbl36hclddglh73fb3wx95jnmrq81n7cf"))

(define rust-tagptr-0.2.0
  (crate-source "tagptr" "0.2.0"
                "05r4mwvlsclx1ayj65hpzjv3dn4wpi8j4xm695vydccf9k7r683v"))

(define rust-thiserror-2.0.18
  (crate-source "thiserror" "2.0.18"
                "1i7vcmw9900bvsmay7mww04ahahab7wmr8s925xc083rpjybb222"))

(define rust-thiserror-impl-2.0.18
  (crate-source "thiserror-impl" "2.0.18"
                "1mf1vrbbimj1g6dvhdgzjmn6q09yflz2b92zs1j9n3k7cxzyxi7b"))

(define rust-thread-local-1.1.9
  (crate-source "thread_local" "1.1.9"
                "1191jvl8d63agnq06pcnarivf63qzgpws5xa33hgc92gjjj4c0pn"))

(define rust-tikv-jemalloc-sys-0.6.1+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "tikv-jemalloc-sys"
                "0.6.1+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7"
                "0frahmfl05hppiy1sz9g14qb5jv2q4wr323d83xcx8l6mfrab2nd"))

(define rust-tikv-jemallocator-0.6.1
  (crate-source "tikv-jemallocator" "0.6.1"
                "0fh55m13396lii5wj69qh547fq9n2k7r3cczwrkhaklmgwrb8n83"))

(define rust-time-0.3.47
  (crate-source "time" "0.3.47"
                "0b7g9ly2iabrlgizliz6v5x23yq5d6bpp0mqz6407z1s526d8fvl"))

(define rust-time-core-0.1.8
  (crate-source "time-core" "0.1.8"
                "1jidl426mw48i7hjj4hs9vxgd9lwqq4vyalm4q8d7y4iwz7y353n"))

(define rust-time-macros-0.2.27
  (crate-source "time-macros" "0.2.27"
                "058ja265waq275wxvnfwavbz9r1hd4dgwpfn7a1a9a70l32y8w1f"))

(define rust-tinystr-0.8.3
  (crate-source "tinystr" "0.8.3"
                "0vfr8x285w6zsqhna0a9jyhylwiafb2kc8pj2qaqaahw48236cn8"))

(define rust-tinytemplate-1.2.1
  (crate-source "tinytemplate" "1.2.1"
                "1g5n77cqkdh9hy75zdb01adxn45mkh9y40wdr7l68xpz35gnnkdy"))

(define rust-tinyvec-1.11.0
  (crate-source "tinyvec" "1.11.0"
                "1wvycrghzmaysnw34kzwnf0mfx6r75045s24r214wnnjadqfcq9y"))

(define rust-tinyvec-macros-0.1.1
  (crate-source "tinyvec_macros" "0.1.1"
                "081gag86208sc3y6sdkshgw3vysm5d34p431dzw0bshz66ncng0z"))

(define rust-tokio-1.52.1
  (crate-source "tokio" "1.52.1"
                "1imw1dkkv38p66i33m5hsyk3d6prsbyrayjvqhndjvz89ybywzdn"))

(define rust-tokio-macros-2.7.0
  (crate-source "tokio-macros" "2.7.0"
                "15m4f37mdafs0gg36sh0rskm1i768lb7zmp8bw67kaxr3avnqniq"))

(define rust-tokio-rustls-0.26.4
  (crate-source "tokio-rustls" "0.26.4"
                "0qggwknz9w4bbsv1z158hlnpkm97j3w8v31586jipn99byaala8p"))

(define rust-tokio-util-0.7.18
  (crate-source "tokio-util" "0.7.18"
                "1600rd47pylwn7cap1k7s5nvdaa9j7w8kqigzp1qy7mh0p4cxscs"))

(define rust-toml-1.1.2+spec-1.1.0
  (crate-source "toml" "1.1.2+spec-1.1.0"
                "1vpggpamqhw4852kic7465zsidczsla06wz6friqkkfbhigd3ww1"))

(define rust-toml-datetime-1.1.1+spec-1.1.0
  (crate-source "toml_datetime" "1.1.1+spec-1.1.0"
                "1mws2mkkf46l7inn77azhm0vdwxngv9vsbhbl0ah33p2c9gzcr9i"))

(define rust-toml-parser-1.1.2+spec-1.1.0
  (crate-source "toml_parser" "1.1.2+spec-1.1.0"
                "09kmzc55a0j21whm290wlf5a8b18a0qc87a1s8sncrckc6wfkax2"))

(define rust-toml-writer-1.1.1+spec-1.1.0
  (crate-source "toml_writer" "1.1.1+spec-1.1.0"
                "1nwjhvvrxz8f4ck1qi4xcz2x9qhpci37nrknhxxf9sqk22dsyvbm"))

(define rust-tower-0.5.3
  (crate-source "tower" "0.5.3"
                "1m5i3a2z1sgs8nnz1hgfq2nr4clpdmizlp1d9qsg358ma5iyzrgb"))

(define rust-tower-http-0.6.8
  (crate-source "tower-http" "0.6.8"
                "1y514jwzbyrmrkbaajpwmss4rg0mak82k16d6588w9ncaffmbrnl"))

(define rust-tower-layer-0.3.3
  (crate-source "tower-layer" "0.3.3"
                "03kq92fdzxin51w8iqix06dcfgydyvx7yr6izjq0p626v9n2l70j"))

(define rust-tower-service-0.3.3
  (crate-source "tower-service" "0.3.3"
                "1hzfkvkci33ra94xjx64vv3pp0sq346w06fpkcdwjcid7zhvdycd"))

(define rust-tracing-0.1.44
  (crate-source "tracing" "0.1.44"
                "006ilqkg1lmfdh3xhg3z762izfwmxcvz0w7m4qx2qajbz9i1drv3"))

(define rust-tracing-core-0.1.36
  (crate-source "tracing-core" "0.1.36"
                "16mpbz6p8vd6j7sf925k9k8wzvm9vdfsjbynbmaxxyq6v7wwm5yv"))

(define rust-tracing-subscriber-0.3.23
  (crate-source "tracing-subscriber" "0.3.23"
                "06fkr0qhggvrs861d7f74pn3i3a10h5jsp4n70jj9ys5b675fzyb"))

(define rust-try-lock-0.2.5
  (crate-source "try-lock" "0.2.5"
                "0jqijrrvm1pyq34zn1jmy2vihd4jcrjlvsh4alkjahhssjnsn8g4"))

(define rust-unicode-ident-1.0.24
  (crate-source "unicode-ident" "1.0.24"
                "0xfs8y1g7syl2iykji8zk5hgfi5jw819f5zsrbaxmlzwsly33r76"))

(define rust-unicode-width-0.2.2
  (crate-source "unicode-width" "0.2.2"
                "0m7jjzlcccw716dy9423xxh0clys8pfpllc5smvfxrzdf66h9b5l"))

(define rust-unicode-xid-0.2.6
  (crate-source "unicode-xid" "0.2.6"
                "0lzqaky89fq0bcrh6jj6bhlz37scfd8c7dsj5dq7y32if56c1hgb"))

(define rust-untrusted-0.7.1
  (crate-source "untrusted" "0.7.1"
                "0jkbqaj9d3v5a91pp3wp9mffvng1nhycx6sh4qkdd9qyr62ccmm1"))

(define rust-untrusted-0.9.0
  (crate-source "untrusted" "0.9.0"
                "1ha7ib98vkc538x0z60gfn0fc5whqdd85mb87dvisdcaifi6vjwf"))

(define rust-url-2.5.8
  (crate-source "url" "2.5.8"
                "1v8f7nx3hpr1qh76if0a04sj08k86amsq4h8cvpw6wvk76jahrzz"))

(define rust-utf8-iter-1.0.4
  (crate-source "utf8_iter" "1.0.4"
                "1gmna9flnj8dbyd8ba17zigrp9c4c3zclngf5lnb5yvz1ri41hdn"))

(define rust-utf8parse-0.2.2
  (crate-source "utf8parse" "0.2.2"
                "088807qwjq46azicqwbhlmzwrbkz7l4hpw43sdkdyyk524vdxaq6"))

(define rust-uuid-1.23.1
  (crate-source "uuid" "1.23.1"
                "0xlwg23rmsfl3gx98qsyzpl24pf4bs9wi3mqx5c6i319hyb4mmyx"))

(define rust-vcpkg-0.2.15
  (crate-source "vcpkg" "0.2.15"
                "09i4nf5y8lig6xgj3f7fyrvzd3nlaw4znrihw8psidvv5yk4xkdc"))

(define rust-version-check-0.9.5
  (crate-source "version_check" "0.9.5"
                "0nhhi4i5x89gm911azqbn7avs9mdacw2i3vcz3cnmz3mv4rqz4hb"))

(define rust-walkdir-2.5.0
  (crate-source "walkdir" "2.5.0"
                "0jsy7a710qv8gld5957ybrnc07gavppp963gs32xk4ag8130jy99"))

(define rust-want-0.3.1
  (crate-source "want" "0.3.1"
                "03hbfrnvqqdchb5kgxyavb9jabwza0dmh2vw5kg0dq8rxl57d9xz"))

(define rust-wasi-0.11.1+wasi-snapshot-preview1
  (crate-source "wasi" "0.11.1+wasi-snapshot-preview1"
                "0jx49r7nbkbhyfrfyhz0bm4817yrnxgd3jiwwwfv0zl439jyrwyc"))

(define rust-wasip2-1.0.3+wasi-0.2.9
  (crate-source "wasip2" "1.0.3+wasi-0.2.9"
                "1mi3w855dz99xzjqc4aa8c9q5b6z1y5c963pkk4cvmr6vdr4c1i0"))

(define rust-wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
  (crate-source "wasip3" "0.4.0+wasi-0.3.0-rc-2026-01-06"
                "19dc8p0y2mfrvgk3qw3c3240nfbylv22mvyxz84dqpgai2zzha2l"))

(define rust-wasm-bindgen-0.2.118
  (crate-source "wasm-bindgen" "0.2.118"
                "129s5r14fx4v4xrzpx2c6l860nkxpl48j50y7kl6j16bpah3iy8b"))

(define rust-wasm-bindgen-futures-0.4.68
  (crate-source "wasm-bindgen-futures" "0.4.68"
                "1y7bq5d9fk7s9xaayx38bgs9ns35na0kpb5zw19944zvya1x6wgk"))

(define rust-wasm-bindgen-macro-0.2.118
  (crate-source "wasm-bindgen-macro" "0.2.118"
                "1v98r8vs17cj8918qsg0xx4nlg4nxk1g0jd4nwnyrh1687w29zzf"))

(define rust-wasm-bindgen-macro-support-0.2.118
  (crate-source "wasm-bindgen-macro-support" "0.2.118"
                "0169jr0q469hfx5zqxfyywf2h2f4aj17vn4zly02nfwqmxghc24x"))

(define rust-wasm-bindgen-shared-0.2.118
  (crate-source "wasm-bindgen-shared" "0.2.118"
                "0ag1vvdzi4334jlzilsy14y3nyzwddf1ndn62fyhf6bg62g4vl2z"))

(define rust-wasm-encoder-0.244.0
  (crate-source "wasm-encoder" "0.244.0"
                "06c35kv4h42vk3k51xjz1x6hn3mqwfswycmr6ziky033zvr6a04r"))

(define rust-wasm-metadata-0.244.0
  (crate-source "wasm-metadata" "0.244.0"
                "02f9dhlnryd2l7zf03whlxai5sv26x4spfibjdvc3g9gd8z3a3mv"))

(define rust-wasmparser-0.244.0
  (crate-source "wasmparser" "0.244.0"
                "1zi821hrlsxfhn39nqpmgzc0wk7ax3dv6vrs5cw6kb0v5v3hgf27"))

(define rust-web-sys-0.3.95
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "web-sys" "0.3.95"
                "0zfr2jy5bpkkggl88i43yy37p538hg20i56kwn421yj9g6qznbag"))

(define rust-web-time-1.1.0
  (crate-source "web-time" "1.1.0"
                "1fx05yqx83dhx628wb70fyy10yjfq1jpl20qfqhdkymi13rq0ras"))

(define rust-webpki-root-certs-1.0.7
  (crate-source "webpki-root-certs" "1.0.7"
                "0b59x5mzsilk42w59nif3lfhc24pgzb0v35pi6p01qy37z7424gk"))

(define rust-webpki-roots-1.0.7
  (crate-source "webpki-roots" "1.0.7"
                "17gblaqmp51znxd2c18c04k8yfnf7s77c04n6hdmzxbcr52fxxaj"))

(define rust-widestring-1.2.1
  (crate-source "widestring" "1.2.1"
                "0wg4qdbs70xqnlbm8wb0bs4idm2mxk3b6kaqwllsncmb2cqrq1kj"))

(define rust-winapi-0.3.9
  (crate-source "winapi" "0.3.9"
                "06gl025x418lchw1wxj64ycr7gha83m44cjr5sarhynd9xkrm0sw"))

(define rust-winapi-i686-pc-windows-gnu-0.4.0
  (crate-source "winapi-i686-pc-windows-gnu" "0.4.0"
                "1dmpa6mvcvzz16zg6d5vrfy4bxgg541wxrcip7cnshi06v38ffxc"))

(define rust-winapi-util-0.1.11
  (crate-source "winapi-util" "0.1.11"
                "08hdl7mkll7pz8whg869h58c1r9y7in0w0pk8fm24qc77k0b39y2"))

(define rust-winapi-x86-64-pc-windows-gnu-0.4.0
  (crate-source "winapi-x86_64-pc-windows-gnu" "0.4.0"
                "0gqq64czqb64kskjryj8isp62m2sgvx25yyj3kpc2myh85w24bki"))

(define rust-windows-0.62.2
  (crate-source "windows" "0.62.2"
                "10457l9ihrbw8j79z2v4plyjxkf6xvb5npd0lqwmkh702gpaszsj"))

(define rust-windows-aarch64-gnullvm-0.52.6
  (crate-source "windows_aarch64_gnullvm" "0.52.6"
                "1lrcq38cr2arvmz19v32qaggvj8bh1640mdm9c2fr877h0hn591j"))

(define rust-windows-aarch64-gnullvm-0.53.1
  (crate-source "windows_aarch64_gnullvm" "0.53.1"
                "0lqvdm510mka9w26vmga7hbkmrw9glzc90l4gya5qbxlm1pl3n59"))

(define rust-windows-aarch64-msvc-0.52.6
  (crate-source "windows_aarch64_msvc" "0.52.6"
                "0sfl0nysnz32yyfh773hpi49b1q700ah6y7sacmjbqjjn5xjmv09"))

(define rust-windows-aarch64-msvc-0.53.1
  (crate-source "windows_aarch64_msvc" "0.53.1"
                "01jh2adlwx043rji888b22whx4bm8alrk3khjpik5xn20kl85mxr"))

(define rust-windows-collections-0.3.2
  (crate-source "windows-collections" "0.3.2"
                "0436rjbkqn3j9m2v2lcmwwk0l3n2r57yvqb7fcy4m8d8y5ddkci3"))

(define rust-windows-core-0.62.2
  (crate-source "windows-core" "0.62.2"
                "1swxpv1a8qvn3bkxv8cn663238h2jccq35ff3nsj61jdsca3ms5q"))

(define rust-windows-future-0.3.2
  (crate-source "windows-future" "0.3.2"
                "1jq5qs2dwzf6rl60f8gr49z2mifxsrdh4y4yfdws467ya41gkmp1"))

(define rust-windows-i686-gnu-0.52.6
  (crate-source "windows_i686_gnu" "0.52.6"
                "02zspglbykh1jh9pi7gn8g1f97jh1rrccni9ivmrfbl0mgamm6wf"))

(define rust-windows-i686-gnu-0.53.1
  (crate-source "windows_i686_gnu" "0.53.1"
                "18wkcm82ldyg4figcsidzwbg1pqd49jpm98crfz0j7nqd6h6s3ln"))

(define rust-windows-i686-gnullvm-0.52.6
  (crate-source "windows_i686_gnullvm" "0.52.6"
                "0rpdx1537mw6slcpqa0rm3qixmsb79nbhqy5fsm3q2q9ik9m5vhf"))

(define rust-windows-i686-gnullvm-0.53.1
  (crate-source "windows_i686_gnullvm" "0.53.1"
                "030qaxqc4salz6l4immfb6sykc6gmhyir9wzn2w8mxj8038mjwzs"))

(define rust-windows-i686-msvc-0.52.6
  (crate-source "windows_i686_msvc" "0.52.6"
                "0rkcqmp4zzmfvrrrx01260q3xkpzi6fzi2x2pgdcdry50ny4h294"))

(define rust-windows-i686-msvc-0.53.1
  (crate-source "windows_i686_msvc" "0.53.1"
                "1hi6scw3mn2pbdl30ji5i4y8vvspb9b66l98kkz350pig58wfyhy"))

(define rust-windows-implement-0.60.2
  (crate-source "windows-implement" "0.60.2"
                "1psxhmklzcf3wjs4b8qb42qb6znvc142cb5pa74rsyxm1822wgh5"))

(define rust-windows-interface-0.59.3
  (crate-source "windows-interface" "0.59.3"
                "0n73cwrn4247d0axrk7gjp08p34x1723483jxjxjdfkh4m56qc9z"))

(define rust-windows-link-0.2.1
  (crate-source "windows-link" "0.2.1"
                "1rag186yfr3xx7piv5rg8b6im2dwcf8zldiflvb22xbzwli5507h"))

(define rust-windows-numerics-0.3.1
  (crate-source "windows-numerics" "0.3.1"
                "09hgbg8pf89r4090yyhh9q29ppi7yyxkgmga9ascshy19a240bkf"))

(define rust-windows-registry-0.6.1
  (crate-source "windows-registry" "0.6.1"
                "082p7l615qk8a4g8g15yipc5lghga6cgfhm74wm7zknwzgvjnx82"))

(define rust-windows-result-0.4.1
  (crate-source "windows-result" "0.4.1"
                "1d9yhmrmmfqh56zlj751s5wfm9a2aa7az9rd7nn5027nxa4zm0bp"))

(define rust-windows-strings-0.5.1
  (crate-source "windows-strings" "0.5.1"
                "14bhng9jqv4fyl7lqjz3az7vzh8pw0w4am49fsqgcz67d67x0dvq"))

(define rust-windows-sys-0.52.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "windows-sys" "0.52.0"
                "0gd3v4ji88490zgb6b5mq5zgbvwv7zx1ibn8v3x83rwcdbryaar8"))

(define rust-windows-sys-0.60.2
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "windows-sys" "0.60.2"
                "1jrbc615ihqnhjhxplr2kw7rasrskv9wj3lr80hgfd42sbj01xgj"))

(define rust-windows-sys-0.61.2
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "windows-sys" "0.61.2"
                "1z7k3y9b6b5h52kid57lvmvm05362zv1v8w0gc7xyv5xphlp44xf"))

(define rust-windows-targets-0.52.6
  (crate-source "windows-targets" "0.52.6"
                "0wwrx625nwlfp7k93r2rra568gad1mwd888h1jwnl0vfg5r4ywlv"))

(define rust-windows-targets-0.53.5
  (crate-source "windows-targets" "0.53.5"
                "1wv9j2gv3l6wj3gkw5j1kr6ymb5q6dfc42yvydjhv3mqa7szjia9"))

(define rust-windows-threading-0.2.1
  (crate-source "windows-threading" "0.2.1"
                "0dsvsy33vxs0153z4n39sqkzx382cjjkrd46rb3z3zfak5dvsj9r"))

(define rust-windows-x86-64-gnu-0.52.6
  (crate-source "windows_x86_64_gnu" "0.52.6"
                "0y0sifqcb56a56mvn7xjgs8g43p33mfqkd8wj1yhrgxzma05qyhl"))

(define rust-windows-x86-64-gnu-0.53.1
  (crate-source "windows_x86_64_gnu" "0.53.1"
                "16d4yiysmfdlsrghndr97y57gh3kljkwhfdbcs05m1jasz6l4f4w"))

(define rust-windows-x86-64-gnullvm-0.52.6
  (crate-source "windows_x86_64_gnullvm" "0.52.6"
                "03gda7zjx1qh8k9nnlgb7m3w3s1xkysg55hkd1wjch8pqhyv5m94"))

(define rust-windows-x86-64-gnullvm-0.53.1
  (crate-source "windows_x86_64_gnullvm" "0.53.1"
                "1qbspgv4g3q0vygkg8rnql5c6z3caqv38japiynyivh75ng1gyhg"))

(define rust-windows-x86-64-msvc-0.52.6
  (crate-source "windows_x86_64_msvc" "0.52.6"
                "1v7rb5cibyzx8vak29pdrk8nx9hycsjs4w0jgms08qk49jl6v7sq"))

(define rust-windows-x86-64-msvc-0.53.1
  (crate-source "windows_x86_64_msvc" "0.53.1"
                "0l6npq76vlq4ksn4bwsncpr8508mk0gmznm6wnhjg95d19gzzfyn"))

(define rust-winnow-1.0.2
  (crate-source "winnow" "1.0.2"
                "1l7xnfvlgy4da6gq5ip2bgcm8i9d0rwzaxg1p88nlw8lxy5p1q9f"))

(define rust-wit-bindgen-0.51.0
  (crate-source "wit-bindgen" "0.51.0"
                "19fazgch8sq5cvjv3ynhhfh5d5x08jq2pkw8jfb05vbcyqcr496p"))

(define rust-wit-bindgen-0.57.1
  (crate-source "wit-bindgen" "0.57.1"
                "0vjk2jb593ri9k1aq4iqs2si9mrw5q46wxnn78im7hm7hx799gqy"))

(define rust-wit-bindgen-core-0.51.0
  (crate-source "wit-bindgen-core" "0.51.0"
                "1p2jszqsqbx8k7y8nwvxg65wqzxjm048ba5phaq8r9iy9ildwqga"))

(define rust-wit-bindgen-rust-0.51.0
  (crate-source "wit-bindgen-rust" "0.51.0"
                "08bzn5fsvkb9x9wyvyx98qglknj2075xk1n7c5jxv15jykh6didp"))

(define rust-wit-bindgen-rust-macro-0.51.0
  (crate-source "wit-bindgen-rust-macro" "0.51.0"
                "0ymizapzv2id89igxsz2n587y2hlfypf6n8kyp68x976fzyrn3qc"))

(define rust-wit-component-0.244.0
  (crate-source "wit-component" "0.244.0"
                "1clwxgsgdns3zj2fqnrjcp8y5gazwfa1k0sy5cbk0fsmx4hflrlx"))

(define rust-wit-parser-0.244.0
  (crate-source "wit-parser" "0.244.0"
                "0dm7avvdxryxd5b02l0g5h6933z1cw5z0d4wynvq2cywq55srj7c"))

(define rust-writeable-0.6.3
  (crate-source "writeable" "0.6.3"
                "1i54d13h9bpap2hf13xcry1s4lxh7ap3923g8f3c0grd7c9fbyhz"))

(define rust-yansi-1.0.1
  (crate-source "yansi" "1.0.1"
                "0jdh55jyv0dpd38ij4qh60zglbw9aa8wafqai6m0wa7xaxk3mrfg"))

(define rust-yoke-0.8.2
  (crate-source "yoke" "0.8.2"
                "1jprcs7a98a5whvfs6r3jvfh1nnfp6zyijl7y4ywmn88lzywbs5b"))

(define rust-yoke-derive-0.8.2
  (crate-source "yoke-derive" "0.8.2"
                "13l5y5sz4lqm7rmyakjbh6vwgikxiql51xfff9hq2j485hk4r16y"))

(define rust-zerocopy-0.8.48
  (crate-source "zerocopy" "0.8.48"
                "1sb8plax8jbrsng1jdval7bdhk7hhrx40dz3hwh074k6knzkgm7f"))

(define rust-zerocopy-derive-0.8.48
  (crate-source "zerocopy-derive" "0.8.48"
                "1m5s0g92cxggqc74j83k1priz24k3z93sj5gadppd20p9c4cvqvh"))

(define rust-zerofrom-0.1.7
  (crate-source "zerofrom" "0.1.7"
                "1py40in4rirc9q8w36q67pld0zk8ssg024xhh0cncxgal7ra3yk9"))

(define rust-zerofrom-derive-0.1.7
  (crate-source "zerofrom-derive" "0.1.7"
                "18c4wsnznhdxx6m80piil1lbyszdiwsshgjrybqcm4b6qic22lqi"))

(define rust-zeroize-1.8.2
  (crate-source "zeroize" "1.8.2"
                "1l48zxgcv34d7kjskr610zqsm6j2b4fcr2vfh9jm9j1jgvk58wdr"))

(define rust-zerotrie-0.2.4
  (crate-source "zerotrie" "0.2.4"
                "1gr0pkcn3qsr6in6iixqyp0vbzwf2j1jzyvh7yl2yydh3p9m548g"))

(define rust-zerovec-0.11.6
  (crate-source "zerovec" "0.11.6"
                "0fdjsy6b31q9i0d73sl7xjd12xadbwi45lkpfgqnmasrqg5i3ych"))

(define rust-zerovec-derive-0.11.3
  (crate-source "zerovec-derive" "0.11.3"
                "0m85qj92mmfvhjra6ziqky5b1p4kcmp5069k7kfadp5hr8jw8pb2"))

(define rust-zmij-1.0.21
  (crate-source "zmij" "1.0.21"
                "1amb5i6gz7yjb0dnmz5y669674pqmwbj44p4yfxfv2ncgvk8x15q"))

(define-cargo-inputs lookup-cargo-inputs
                     (hickory-dns =>
                                  (list rust-adler2-2.0.1
                                   rust-ahash-0.8.12
                                   rust-aho-corasick-1.1.4
                                   rust-alloca-0.4.0
                                   rust-android-system-properties-0.1.5
                                   rust-anes-0.1.6
                                   rust-anstream-1.0.0
                                   rust-anstyle-1.0.14
                                   rust-anstyle-parse-1.0.0
                                   rust-anstyle-query-1.1.5
                                   rust-anstyle-wincon-3.0.11
                                   rust-anyhow-1.0.102
                                   rust-async-compression-0.4.42
                                   rust-async-recursion-1.1.1
                                   rust-async-trait-0.1.89
                                   rust-atomic-waker-1.1.2
                                   rust-autocfg-1.5.0
                                   rust-aws-lc-rs-1.16.3
                                   rust-aws-lc-sys-0.40.0
                                   rust-base64-0.22.1
                                   rust-bindgen-0.72.1
                                   rust-bitflags-2.11.1
                                   rust-bumpalo-3.20.2
                                   rust-bytes-1.11.1
                                   rust-cast-0.3.0
                                   rust-cc-1.2.61
                                   rust-cexpr-0.6.0
                                   rust-cfg-if-1.0.4
                                   rust-cfg-aliases-0.2.1
                                   rust-chacha20-0.10.0
                                   rust-chrono-0.4.44
                                   rust-ciborium-0.2.2
                                   rust-ciborium-io-0.2.2
                                   rust-ciborium-ll-0.2.2
                                   rust-clang-sys-1.8.1
                                   rust-clap-4.6.1
                                   rust-clap-builder-4.6.0
                                   rust-clap-derive-4.6.1
                                   rust-clap-lex-1.1.0
                                   rust-cmake-0.1.58
                                   rust-colorchoice-1.0.5
                                   rust-combine-4.6.7
                                   rust-compression-codecs-0.4.38
                                   rust-compression-core-0.4.32
                                   rust-console-0.16.3
                                   rust-core-foundation-0.9.4
                                   rust-core-foundation-0.10.1
                                   rust-core-foundation-sys-0.8.7
                                   rust-cpufeatures-0.3.0
                                   rust-crc32fast-1.5.0
                                   rust-criterion-0.8.2
                                   rust-criterion-plot-0.8.2
                                   rust-critical-section-1.2.0
                                   rust-crossbeam-channel-0.5.15
                                   rust-crossbeam-deque-0.8.6
                                   rust-crossbeam-epoch-0.9.18
                                   rust-crossbeam-utils-0.8.21
                                   rust-crunchy-0.2.4
                                   rust-data-encoding-2.11.0
                                   rust-deranged-0.5.8
                                   rust-diff-0.1.13
                                   rust-displaydoc-0.2.5
                                   rust-dunce-1.0.5
                                   rust-either-1.15.0
                                   rust-encode-unicode-1.0.0
                                   rust-equivalent-1.0.2
                                   rust-errno-0.3.14
                                   rust-fallible-iterator-0.3.0
                                   rust-fallible-streaming-iterator-0.1.9
                                   rust-fastrand-2.4.1
                                   rust-find-msvc-tools-0.1.9
                                   rust-flate2-1.1.9
                                   rust-fnv-1.0.7
                                   rust-foldhash-0.1.5
                                   rust-foldhash-0.2.0
                                   rust-form-urlencoded-1.2.2
                                   rust-fs-extra-1.3.0
                                   rust-futures-0.3.32
                                   rust-futures-channel-0.3.32
                                   rust-futures-core-0.3.32
                                   rust-futures-executor-0.3.32
                                   rust-futures-io-0.3.32
                                   rust-futures-macro-0.3.32
                                   rust-futures-sink-0.3.32
                                   rust-futures-task-0.3.32
                                   rust-futures-util-0.3.32
                                   rust-getrandom-0.2.17
                                   rust-getrandom-0.3.4
                                   rust-getrandom-0.4.2
                                   rust-glob-0.3.3
                                   rust-h2-0.4.13
                                   rust-h3-0.0.8
                                   rust-h3-quinn-0.0.10
                                   rust-half-2.7.1
                                   rust-hashbrown-0.15.5
                                   rust-hashbrown-0.16.1
                                   rust-hashbrown-0.17.0
                                   rust-hashlink-0.11.0
                                   rust-heck-0.5.0
                                   rust-hex-0.4.3
                                   rust-hostname-0.4.2
                                   rust-http-1.4.0
                                   rust-http-body-1.0.1
                                   rust-http-body-util-0.1.3
                                   rust-httparse-1.10.1
                                   rust-httpdate-1.0.3
                                   rust-hyper-1.9.0
                                   rust-hyper-util-0.1.20
                                   rust-iana-time-zone-0.1.65
                                   rust-iana-time-zone-haiku-0.1.2
                                   rust-icu-collections-2.2.0
                                   rust-icu-locale-core-2.2.0
                                   rust-icu-normalizer-2.2.0
                                   rust-icu-normalizer-data-2.2.0
                                   rust-icu-properties-2.2.0
                                   rust-icu-properties-data-2.2.0
                                   rust-icu-provider-2.2.0
                                   rust-id-arena-2.3.0
                                   rust-idna-1.1.0
                                   rust-idna-adapter-1.2.1
                                   rust-indexmap-2.14.0
                                   rust-ipconfig-0.3.4
                                   rust-ipnet-2.12.0
                                   rust-iri-string-0.7.12
                                   rust-is-terminal-polyfill-1.70.2
                                   rust-itertools-0.12.1
                                   rust-itertools-0.13.0
                                   rust-itoa-1.0.18
                                   rust-jni-0.22.4
                                   rust-jni-macros-0.22.4
                                   rust-jni-sys-0.4.1
                                   rust-jni-sys-macros-0.4.1
                                   rust-jobserver-0.1.34
                                   rust-js-sys-0.3.95
                                   rust-lazy-static-1.5.0
                                   rust-leb128fmt-0.1.0
                                   rust-libc-0.2.186
                                   rust-libloading-0.8.9
                                   rust-libproc-0.14.11
                                   rust-libsqlite3-sys-0.37.0
                                   rust-linked-hash-map-0.5.6
                                   rust-linux-raw-sys-0.12.1
                                   rust-litemap-0.8.2
                                   rust-lock-api-0.4.14
                                   rust-log-0.4.29
                                   rust-lru-cache-0.1.2
                                   rust-lru-slab-0.1.2
                                   rust-mach2-0.6.0
                                   rust-matchers-0.2.0
                                   rust-memchr-2.8.0
                                   rust-metrics-0.24.3
                                   rust-metrics-exporter-prometheus-0.18.1
                                   rust-metrics-process-2.4.3
                                   rust-metrics-util-0.20.1
                                   rust-minimal-lexical-0.2.1
                                   rust-miniz-oxide-0.8.9
                                   rust-mio-1.2.0
                                   rust-moka-0.12.15
                                   rust-ndk-context-0.1.1
                                   rust-nom-7.1.3
                                   rust-num-conv-0.2.1
                                   rust-num-traits-0.2.19
                                   rust-once-cell-1.21.4
                                   rust-once-cell-polyfill-1.70.2
                                   rust-oorandom-11.1.5
                                   rust-openssl-probe-0.2.1
                                   rust-ordered-float-5.3.0
                                   rust-page-size-0.6.0
                                   rust-parking-lot-0.12.5
                                   rust-parking-lot-core-0.9.12
                                   rust-percent-encoding-2.3.2
                                   rust-pin-project-lite-0.2.17
                                   rust-pkg-config-0.3.33
                                   rust-plotters-0.3.7
                                   rust-plotters-backend-0.3.7
                                   rust-plotters-svg-0.3.7
                                   rust-portable-atomic-1.13.1
                                   rust-potential-utf-0.1.5
                                   rust-powerfmt-0.2.0
                                   rust-ppv-lite86-0.2.21
                                   rust-prefix-trie-0.8.2
                                   rust-pretty-assertions-1.4.1
                                   rust-prettyplease-0.2.37
                                   rust-proc-macro2-1.0.106
                                   rust-procfs-0.18.0
                                   rust-procfs-core-0.18.0
                                   rust-prometheus-parse-0.2.5
                                   rust-quanta-0.12.6
                                   rust-quinn-0.11.9
                                   rust-quinn-proto-0.11.14
                                   rust-quinn-udp-0.5.14
                                   rust-quote-1.0.45
                                   rust-r-efi-5.3.0
                                   rust-r-efi-6.0.0
                                   rust-rand-0.9.4
                                   rust-rand-0.10.1
                                   rust-rand-chacha-0.9.0
                                   rust-rand-core-0.9.5
                                   rust-rand-core-0.10.1
                                   rust-rand-xoshiro-0.7.0
                                   rust-raw-cpuid-11.6.0
                                   rust-rayon-1.12.0
                                   rust-rayon-core-1.13.0
                                   rust-redox-syscall-0.5.18
                                   rust-regex-1.12.3
                                   rust-regex-automata-0.4.14
                                   rust-regex-syntax-0.8.10
                                   rust-reqwest-0.13.2
                                   rust-resolv-conf-0.7.6
                                   rust-ring-0.17.14
                                   rust-rlimit-0.11.0
                                   rust-rsqlite-vfs-0.1.0
                                   rust-rusqlite-0.39.0
                                   rust-rustc-hash-2.1.2
                                   rust-rustc-version-0.4.1
                                   rust-rustix-1.1.4
                                   rust-rustls-0.23.39
                                   rust-rustls-native-certs-0.8.3
                                   rust-rustls-pki-types-1.14.1
                                   rust-rustls-platform-verifier-0.7.0
                                   rust-rustls-platform-verifier-android-0.1.1
                                   rust-rustls-webpki-0.103.13
                                   rust-rustversion-1.0.22
                                   rust-same-file-1.0.6
                                   rust-schannel-0.1.29
                                   rust-scopeguard-1.2.0
                                   rust-sd-notify-0.5.0
                                   rust-security-framework-3.7.0
                                   rust-security-framework-sys-2.17.0
                                   rust-semver-1.0.28
                                   rust-serde-1.0.228
                                   rust-serde-core-1.0.228
                                   rust-serde-derive-1.0.228
                                   rust-serde-json-1.0.149
                                   rust-serde-spanned-1.1.1
                                   rust-sharded-slab-0.1.7
                                   rust-shlex-1.3.0
                                   rust-signal-hook-registry-1.4.8
                                   rust-simd-adler32-0.3.9
                                   rust-simd-cesu8-1.1.1
                                   rust-simdutf8-0.1.5
                                   rust-sketches-ddsketch-0.3.1
                                   rust-slab-0.4.12
                                   rust-smallvec-1.15.1
                                   rust-socket2-0.6.3
                                   rust-sqlite-wasm-rs-0.5.3
                                   rust-stable-deref-trait-1.2.1
                                   rust-strsim-0.11.1
                                   rust-subtle-2.6.1
                                   rust-syn-2.0.117
                                   rust-sync-wrapper-1.0.2
                                   rust-synstructure-0.13.2
                                   rust-system-configuration-0.7.0
                                   rust-system-configuration-sys-0.6.0
                                   rust-tagptr-0.2.0
                                   rust-thiserror-2.0.18
                                   rust-thiserror-impl-2.0.18
                                   rust-thread-local-1.1.9
                                   rust-tikv-jemalloc-sys-0.6.1+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7
                                   rust-tikv-jemallocator-0.6.1
                                   rust-time-0.3.47
                                   rust-time-core-0.1.8
                                   rust-time-macros-0.2.27
                                   rust-tinystr-0.8.3
                                   rust-tinytemplate-1.2.1
                                   rust-tinyvec-1.11.0
                                   rust-tinyvec-macros-0.1.1
                                   rust-tokio-1.52.1
                                   rust-tokio-macros-2.7.0
                                   rust-tokio-rustls-0.26.4
                                   rust-tokio-util-0.7.18
                                   rust-toml-1.1.2+spec-1.1.0
                                   rust-toml-datetime-1.1.1+spec-1.1.0
                                   rust-toml-parser-1.1.2+spec-1.1.0
                                   rust-toml-writer-1.1.1+spec-1.1.0
                                   rust-tower-0.5.3
                                   rust-tower-http-0.6.8
                                   rust-tower-layer-0.3.3
                                   rust-tower-service-0.3.3
                                   rust-tracing-0.1.44
                                   rust-tracing-core-0.1.36
                                   rust-tracing-subscriber-0.3.23
                                   rust-try-lock-0.2.5
                                   rust-unicode-ident-1.0.24
                                   rust-unicode-width-0.2.2
                                   rust-unicode-xid-0.2.6
                                   rust-untrusted-0.7.1
                                   rust-untrusted-0.9.0
                                   rust-url-2.5.8
                                   rust-utf8-iter-1.0.4
                                   rust-utf8parse-0.2.2
                                   rust-uuid-1.23.1
                                   rust-vcpkg-0.2.15
                                   rust-version-check-0.9.5
                                   rust-walkdir-2.5.0
                                   rust-want-0.3.1
                                   rust-wasi-0.11.1+wasi-snapshot-preview1
                                   rust-wasip2-1.0.3+wasi-0.2.9
                                   rust-wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
                                   rust-wasm-bindgen-0.2.118
                                   rust-wasm-bindgen-futures-0.4.68
                                   rust-wasm-bindgen-macro-0.2.118
                                   rust-wasm-bindgen-macro-support-0.2.118
                                   rust-wasm-bindgen-shared-0.2.118
                                   rust-wasm-encoder-0.244.0
                                   rust-wasm-metadata-0.244.0
                                   rust-wasmparser-0.244.0
                                   rust-web-sys-0.3.95
                                   rust-web-time-1.1.0
                                   rust-webpki-root-certs-1.0.7
                                   rust-webpki-roots-1.0.7
                                   rust-widestring-1.2.1
                                   rust-winapi-0.3.9
                                   rust-winapi-i686-pc-windows-gnu-0.4.0
                                   rust-winapi-util-0.1.11
                                   rust-winapi-x86-64-pc-windows-gnu-0.4.0
                                   rust-windows-0.62.2
                                   rust-windows-collections-0.3.2
                                   rust-windows-core-0.62.2
                                   rust-windows-future-0.3.2
                                   rust-windows-implement-0.60.2
                                   rust-windows-interface-0.59.3
                                   rust-windows-link-0.2.1
                                   rust-windows-numerics-0.3.1
                                   rust-windows-registry-0.6.1
                                   rust-windows-result-0.4.1
                                   rust-windows-strings-0.5.1
                                   rust-windows-sys-0.52.0
                                   rust-windows-sys-0.60.2
                                   rust-windows-sys-0.61.2
                                   rust-windows-targets-0.52.6
                                   rust-windows-targets-0.53.5
                                   rust-windows-threading-0.2.1
                                   rust-windows-aarch64-gnullvm-0.52.6
                                   rust-windows-aarch64-gnullvm-0.53.1
                                   rust-windows-aarch64-msvc-0.52.6
                                   rust-windows-aarch64-msvc-0.53.1
                                   rust-windows-i686-gnu-0.52.6
                                   rust-windows-i686-gnu-0.53.1
                                   rust-windows-i686-gnullvm-0.52.6
                                   rust-windows-i686-gnullvm-0.53.1
                                   rust-windows-i686-msvc-0.52.6
                                   rust-windows-i686-msvc-0.53.1
                                   rust-windows-x86-64-gnu-0.52.6
                                   rust-windows-x86-64-gnu-0.53.1
                                   rust-windows-x86-64-gnullvm-0.52.6
                                   rust-windows-x86-64-gnullvm-0.53.1
                                   rust-windows-x86-64-msvc-0.52.6
                                   rust-windows-x86-64-msvc-0.53.1
                                   rust-winnow-1.0.2
                                   rust-wit-bindgen-0.51.0
                                   rust-wit-bindgen-0.57.1
                                   rust-wit-bindgen-core-0.51.0
                                   rust-wit-bindgen-rust-0.51.0
                                   rust-wit-bindgen-rust-macro-0.51.0
                                   rust-wit-component-0.244.0
                                   rust-wit-parser-0.244.0
                                   rust-writeable-0.6.3
                                   rust-yansi-1.0.1
                                   rust-yoke-0.8.2
                                   rust-yoke-derive-0.8.2
                                   rust-zerocopy-0.8.48
                                   rust-zerocopy-derive-0.8.48
                                   rust-zerofrom-0.1.7
                                   rust-zerofrom-derive-0.1.7
                                   rust-zeroize-1.8.2
                                   rust-zerotrie-0.2.4
                                   rust-zerovec-0.11.6
                                   rust-zerovec-derive-0.11.3
                                   rust-zmij-1.0.21)))
