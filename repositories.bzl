load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//:third_party_repositories.bzl", "zlib", "org_golang_x_tools", "org_golang_x_sys", "jinja2", "mistune", "markupsafe")

# WARNING: The following definitions are placeholders since none of the projects have been tested at the versions listed in this file.
# Please do not use them (yet). Future commits to this file will set the proper versions and ensure that all dependencies are correct.


def bazel():
    maybe(
        git_repository,
        name = "io_bazel",
        remote = "https://github.com/bazelbuild/bazel.git",
        commit = "c689bf93917ad0efa8100b3a0fe1b43f1f1a1cdf",  # Mar 19, 2019
    )

def bazel_buildtools_deps():
    bazel_skylib()
    rules_go()

def bazel_buildtools():
    bazel_buildtools_deps()
    maybe(
        http_archive,
        name = "com_github_bazelbuild_buildtools",
        strip_prefix = "buildtools-f27d1753c8b3210d9e87cdc9c45bc2739ae2c2db",
        url = "https://github.com/bazelbuild/buildtools/archive/f27d1753c8b3210d9e87cdc9c45bc2739ae2c2db.zip",
    )

def bazel_gazelle_deps():
    rules_go()
    # TODO(fweikert): add all gazelle dependencies to the federation

def bazel_gazelle():
    bazel_gazelle_deps()
    maybe(
        http_archive,
        name = "bazel_gazelle",
        sha256 = "7949fc6cc17b5b191103e97481cf8889217263acf52e00b560683413af204fcb",
        urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/0.16.0/bazel-gazelle-0.16.0.tar.gz"],
    )

def bazel_integration_testing_deps():
    pass  # TODO(fweikert): examine dependencies and add them, if necessary


def bazel_integration_testing():
    bazel_integration_testing_deps()
    maybe(
        http_archive,
        name = "build_bazel_integration_testing",
        url = "https://github.com/bazelbuild/bazel-integration-testing/archive/13a7d5112aaae5572544c609f364d430962784b1.zip",
        type = "zip",
        strip_prefix = "bazel-integration-testing-13a7d5112aaae5572544c609f364d430962784b1",
        sha256 = "8028ceaad3613404254d6b337f50dc52c0fe77522d0db897f093dd982c6e63ee",
    )

def bazel_toolchains_deps():
    pass # TODO(fweikert): examine dependencies and add them, if necessary

def bazel_toolchains():
    bazel_toolchains_deps()
    maybe(
        http_archive,
        name = "bazel_toolchains",
        sha256 = "5962fe677a43226c409316fcb321d668fc4b7fa97cb1f9ef45e7dc2676097b26",
        strip_prefix = "bazel-toolchains-be10bee3010494721f08a0fccd7f57411a1e773e",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/be10bee3010494721f08a0fccd7f57411a1e773e.tar.gz",
            "https://github.com/bazelbuild/bazel-toolchains/archive/be10bee3010494721f08a0fccd7f57411a1e773e.tar.gz",
        ],
    )

def bazel_skylib_deps():
    pass

def bazel_skylib():
    bazel_skylib_deps()
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/0.9.0/bazel_skylib-0.9.0.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/0.9.0/bazel_skylib-0.9.0.tar.gz",
        ],
        sha256 = "1dde365491125a3db70731e25658dfdd3bc5dbdfd11b840b3e987ecf043c7ca0",
    )

def bazel_stardoc_deps():
    bazel_skylib()
    rules_java()

def bazel_stardoc():
    bazel_stardoc_deps()
    maybe(
        http_archive,
        name = "io_bazel_skydoc",
        url = "https://github.com/bazelbuild/skydoc/archive/0.3.0.tar.gz",
        sha256 = "c2d66a0cc7e25d857e480409a8004fdf09072a1bd564d6824441ab2f96448eea",
        strip_prefix = "skydoc-0.3.0",
    )

# TODO(fweikert): delete this function if it's not needed by the protobuf project itself.
def protobuf_deps():
    zlib()
    protobuf_javalite()

def protobuf():
    protobuf_deps()
    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "b404fe166de66e9a5e6dab43dc637070f950cdba2a8a4c9ed9add354ed4f6525",
        strip_prefix = "protobuf-b4f193788c9f0f05d7e0879ea96cd738630e5d51",
        # Commit from 2019-05-15, update to protobuf 3.8 when available.
        url = "https://github.com/protocolbuffers/protobuf/archive/b4f193788c9f0f05d7e0879ea96cd738630e5d51.zip",
    )
    native.bind(name = "com_google_protobuf_cc", actual = "@com_google_protobuf")
    native.bind(name = "com_google_protobuf_java", actual = "@com_google_protobuf")

def protobuf_javalite_deps():
    pass

def protobuf_javalite():
    protobuf_javalite_deps()
    maybe(
        http_archive,
        name = "com_google_protobuf_javalite",
        strip_prefix = "protobuf-javalite",
        urls = ["https://github.com/protocolbuffers/protobuf/archive/javalite.zip"],
    )

def rules_cc_deps():
    bazel_skylib()

def rules_cc():
    rules_cc_deps()
    maybe(
        http_archive,
        name = "rules_cc",
        url = "https://github.com/bazelbuild/rules_cc/archive/624b5d59dfb45672d4239422fa1e3de1822ee110.zip",
        sha256 = "8c7e8bf24a2bf515713445199a677ee2336e1c487fa1da41037c6026de04bbc3",
        strip_prefix = "rules_cc-624b5d59dfb45672d4239422fa1e3de1822ee110",
        type = "zip",
    )

# TODO(fweikert): check deps
def rules_go_deps():
    protobuf()
    org_golang_x_tools()
    org_golang_x_sys()

def rules_go():
    rules_go_deps()
    maybe(
        http_archive,
        name = "io_bazel_rules_go",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/0.18.6/rules_go-0.18.6.tar.gz",
            "https://github.com/bazelbuild/rules_go/releases/download/0.18.6/rules_go-0.18.6.tar.gz",
        ],
        sha256 = "f04d2373bcaf8aa09bccb08a98a57e721306c8f6043a2a0ee610fd6853dcde3d",
    )

def rules_java_deps():
    # TODO(aiuto): When rules_java stabalizes, reference the deps directly.
    # rules_java is going to be changing for the next few months. While that
    # is happening we let rules_java_setup() bring in the deps. This allows
    # use to quicky update rules_java without havig to update all of the deps
    # tree which is only used by Java.
    bazel_skylib()

def rules_java():
    rules_java_deps()
    # TODO(aiuto): After https://github.com/bazelbuild/rules_java/pull/14 is
    # submitted, produce a release and point to that new one.
    #maybe(
    #    http_archive,
    #    name = "rules_java",
    #    url = "https://github.com/bazelbuild/rules_java/releases/download/0.1.0/rules_java-0.1.0.tar.gz",
    #    sha256 = "TBD",
    #)
    maybe(
        http_archive,
        name = "rules_java",
        url = "https://github.com/bazelbuild/rules_java/archive/d7bf804c8731edd232cb061cb2a9fe003a85d8ee.zip",
        sha256 = "dc6b247b0bc61120e6c2bfe314c7ed5b19a3a5d5d3a3f8e9acf3ea8b4fb05c7b",
        strip_prefix = "rules_java-d7bf804c8731edd232cb061cb2a9fe003a85d8ee",
        type = "zip",
    )

def rules_nodejs_deps():
    pass

def rules_nodejs():
    rules_nodejs_deps()
    maybe(
        http_archive,
        name = "build_bazel_rules_nodejs",
        url = "https://github.com/bazelbuild/rules_nodejs/releases/download/0.30.1/rules_nodejs-0.30.1.tar.gz",
        sha256 = "abcf497e89cfc1d09132adfcd8c07526d026e162ae2cb681dcb896046417ce91",
    )

def rules_pkg_deps():
    pass

def rules_pkg():
    rules_pkg_deps()
    maybe(
        http_archive,
        name = "rules_pkg",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/rules_pkg-0.2.2.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.2.2/rules_pkg-0.2.2.tar.gz",
        ],
        sha256 = "02de387c5ef874379e784ac968bf6efffe5285a168cab5a3169e08cfc634fd22",
    )

def rules_python_deps():
    pass

def rules_python():
    rules_python_deps()
    maybe(
        http_archive,
        name = "rules_python",
        strip_prefix = "rules_python-e0644961d74b9bbb8a975a01bebb045abfd5d1bd",
        url = "https://github.com/bazelbuild/rules_python/archive/e0644961d74b9bbb8a975a01bebb045abfd5d1bd.tar.gz",
        sha256 = "a3c516f4ed620a2c5a2b4edd31150c86023322492852f96a40d1ee4730d6e060",
    )

def rules_rust_deps():
    bazel_skylib()

def rules_rust():
    rules_rust_deps()
    maybe(
        http_archive,
        name = "io_bazel_rules_rust",
        strip_prefix = "rules_rust-05bd7d1d1bd34225a6614fc131267181aee2b61e",
        url = "https://github.com/bazelbuild/rules_rust/archive/05bd7d1d1bd34225a6614fc131267181aee2b61e.tar.gz",
        sha256 = "55968c5377d9d9f4a5c61780c8a041d478eaac26d984d19fd589afaf12b353dc",
    )

def rules_sass_deps():
    bazel_skylib()
    rules_nodejs()

def rules_sass():
    rules_sass_deps()
    maybe(
        git_repository,
        name = "io_bazel_rules_sass",
        remote = "https://github.com/bazelbuild/rules_sass.git",
        commit = "8ccf4f1c351928b55d5dddf3672e3667f6978d60",
    )

def rules_scala_deps():
    bazel_skylib()

def rules_scala():
    rules_scala_deps()
    maybe(
        http_archive,
        name = "io_bazel_rules_scala",
        strip_prefix = "rules_scala-300b4369a0a56d9e590d9fea8a73c3913d758e12",
        type = "zip",
        # commit from 2019-05-27
        url = "https://github.com/bazelbuild/rules_scala/archive/300b4369a0a56d9e590d9fea8a73c3913d758e12.zip",
        sha256 = "7f35ee7d96b22f6139b81da3a8ba5fb816e1803ed097f7295b85b7a56e4401c7",
    )
