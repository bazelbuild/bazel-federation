load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def repositories():
    http_archive(
        name = "bazel_skylib",
        url = "https://github.com/bazelbuild/bazel-skylib/archive/0.6.0.tar.gz",
        sha256 = "eb5c57e4c12e68c0c20bc774bfbc60a568e800d025557bc4ea022c6479acc867",
        strip_prefix = "bazel-skylib-0.6.0",
    )

    http_archive(
        name = "io_bazel_rules_go",
        sha256 = "f87fa87475ea107b3c69196f39c82b7bbf58fe27c62a338684c20ca17d1d8613",
        urls = ["https://github.com/bazelbuild/rules_go/releases/download/0.16.2/rules_go-0.16.2.tar.gz"],
    )

    http_archive(
        name = "bazel_gazelle",
        sha256 = "6e875ab4b6bf64a38c352887760f21203ab054676d9c1b274963907e0768740d",
        urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/0.15.0/bazel-gazelle-0.15.0.tar.gz"],
    )

    http_archive(
        name = "com_github_bazelbuild_buildtools",
        strip_prefix = "buildtools-0.19.2.1",
        url = "https://github.com/bazelbuild/buildtools/archive/0.19.2.1.zip",
        sha256 = "9176a7df34dbed2cf5171eb56271868824560364e60644348219f852f593ae79",
    )

    http_archive(
        name = "io_bazel_rules_scala",
        strip_prefix = "rules_scala-3f430854319e871429074c6611ca4413657135f7",
        type = "zip",
        url = "https://github.com/bazelbuild/rules_scala/archive/3f430854319e871429074c6611ca4413657135f7.zip",
        sha256 = "424571b60f7ec8d77f8fc6ba07c4fb51856732d5cd4f3360a8e01ebb1b3be365",
    )

    http_archive(
        name = "io_bazel_rules_rust",
        sha256 = "500d06096a44ff6d77256635dbe6ab61b23c2be626e2acb08a4c060092e711d0",
        strip_prefix = "rules_rust-db81b42d98e1232e001e26a50c37f2097d61a207",
        urls = [
            "https://github.com/bazelbuild/rules_rust/archive/db81b42d98e1232e001e26a50c37f2097d61a207.tar.gz",
        ],
    )
