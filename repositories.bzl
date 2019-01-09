load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def bazel_skylib():
    http_archive(
        name = "bazel_skylib",
        url = "https://github.com/bazelbuild/bazel-skylib/archive/0.6.0.tar.gz",
        sha256 = "eb5c57e4c12e68c0c20bc774bfbc60a568e800d025557bc4ea022c6479acc867",
        strip_prefix = "bazel-skylib-0.6.0",
    )

def io_bazel_rules_go():
    http_archive(
        name = "io_bazel_rules_go",
        sha256 = "7be7dc01f1e0afdba6c8eb2b43d2fa01c743be1b9273ab1eaf6c233df078d705",
        urls = ["https://github.com/bazelbuild/rules_go/releases/download/0.16.5/rules_go-0.16.5.tar.gz"],
    )

def bazel_gazelle():
    http_archive(
        name = "bazel_gazelle",
        sha256 = "7949fc6cc17b5b191103e97481cf8889217263acf52e00b560683413af204fcb",
        urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/0.16.0/bazel-gazelle-0.16.0.tar.gz"],
    )

def com_github_bazelbuild_buildtools():
    http_archive(
        name = "com_github_bazelbuild_buildtools",
        strip_prefix = "buildtools-0.20.0",
        url = "https://github.com/bazelbuild/buildtools/archive/0.20.0.zip",
        sha256 = "7b46f95f1df24a62dbe1953cb7820f4170525f72b93a7f9fe414e027a3151128",
    )

def io_bazel_rules_scala():
    http_archive(
        name = "io_bazel_rules_scala",
        strip_prefix = "rules_scala-1354d935a74395b3f0870dd90a04e0376fe22587",
        type = "zip",
        url = "https://github.com/bazelbuild/rules_scala/archive/1354d935a74395b3f0870dd90a04e0376fe22587.zip",
        sha256 = "5a4b3265ab6b00a0437db958523c3efaf43e8506cce191fec89a19eb08f5b9ec",
    )

def io_bazel_rules_rust():
    http_archive(
        name = "io_bazel_rules_rust",
        strip_prefix = "rules_rust-f32695dcd02d9a19e42b9eb7f29a24a8ceb2b858",
        url = "https://github.com/bazelbuild/rules_rust/archive/f32695dcd02d9a19e42b9eb7f29a24a8ceb2b858.tar.gz",
        sha256 = "ed0c81084bcc2bdcc98cfe56f384b20856840825f5e413e2b71809b61809fc87",
    )

def repositories():
    bazel_skylib()
    io_bazel_rules_go()
    bazel_gazelle()
    com_github_bazelbuild_buildtools()
    io_bazel_rules_scala()
    io_bazel_rules_rust()
