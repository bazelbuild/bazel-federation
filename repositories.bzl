load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load(
    "//:third_party_repositories.bzl",
    "jinja2",
    "markupsafe",
    "mistune",
    "org_golang_x_tools_REQUIRES_RULES_GO",
    "com_github_golang_protobuf_REQUIRES_RULES_GO",
    "com_github_mwitkow_go_proto_validators_REQUIRES_RULES_GO",
    "com_github_gogo_protobuf_REQUIRES_RULES_GO",
    "org_golang_google_genproto_REQUIRES_RULES_GO",
    "go_googleapis_REQUIRES_RULES_GO",
    "six",
    "subpar",
    "zlib",
)

# WARNING: The following definitions are placeholders since none of the projects have been tested at the versions listed in this file.
# Please do not use them (yet). Future commits to this file will set the proper versions and ensure that all dependencies are correct.


def bazel():
    maybe(
        git_repository,
        name="io_bazel",
        remote="https://github.com/bazelbuild/bazel.git",
        commit="c689bf93917ad0efa8100b3a0fe1b43f1f1a1cdf",  # Mar 19, 2019
    )


def bazel_buildtools_deps():
    bazel_skylib()
    rules_go()


def bazel_buildtools():
    bazel_buildtools_deps()
    maybe(
        http_archive,
        name="com_github_bazelbuild_buildtools",
        strip_prefix="buildtools-f27d1753c8b3210d9e87cdc9c45bc2739ae2c2db",
        url="https://github.com/bazelbuild/buildtools/archive/f27d1753c8b3210d9e87cdc9c45bc2739ae2c2db.zip",
    )


def bazel_gazelle_deps():
    rules_go()
    # TODO(fweikert): add all gazelle dependencies to the federation


def bazel_gazelle():
    bazel_gazelle_deps()
    maybe(
        http_archive,
        name="bazel_gazelle",
        sha256="7949fc6cc17b5b191103e97481cf8889217263acf52e00b560683413af204fcb",
        urls=[
            "https://github.com/bazelbuild/bazel-gazelle/releases/download/0.16.0/bazel-gazelle-0.16.0.tar.gz"
        ],
    )


def bazel_gpg():
    maybe(
        http_file,
        name = "bazel_gpg",
        downloaded_file_path = "bazel_gpg",
        sha256 = "30af2ca7abfb65987cd61802ca6e352aadc6129dfb5bfc9c81f16617bc3a4416",
        urls = ["https://bazel.build/bazel-release.pub.gpg"],
    )


def bazel_integration_testing_deps():
    pass  # TODO(fweikert): examine dependencies and add them, if necessary


def bazel_integration_testing():
    bazel_integration_testing_deps()
    maybe(
        http_archive,
        name="build_bazel_integration_testing",
        url="https://github.com/bazelbuild/bazel-integration-testing/archive/13a7d5112aaae5572544c609f364d430962784b1.zip",
        type="zip",
        strip_prefix="bazel-integration-testing-13a7d5112aaae5572544c609f364d430962784b1",
        sha256="8028ceaad3613404254d6b337f50dc52c0fe77522d0db897f093dd982c6e63ee",
    )


def bazel_toolchains_deps():
    bazel_gpg()
    bazel_skylib()
    rules_docker()


def bazel_toolchains():
    bazel_toolchains_deps()
    maybe(
        http_archive,
        name = "bazel_toolchains",
        sha256 = "1e16833a9f0e32b292568c0dfee7bd48133c2038605757d3a430551394310006",
        strip_prefix = "bazel-toolchains-1.1.0",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/1.1.0.tar.gz",
            "https://github.com/bazelbuild/bazel-toolchains/archive/1.1.0.tar.gz",
        ],
    )


def bazel_skylib_deps():
    pass


def bazel_skylib():
    bazel_skylib_deps()
    maybe(
        http_archive,
        name="bazel_skylib",
        strip_prefix="bazel-skylib-1.0.2",
        url="https://github.com/bazelbuild/bazel-skylib/archive/1.0.2.zip",
        type="zip",
        sha256="64ad2728ccdd2044216e4cec7815918b7bb3bb28c95b7e9d951f9d4eccb07625",
    )
    # TODO(aiuto): We should be able to call bazel_skylib_setup() here.
    #     That would register the toolchains. We can not because you can
    #     not do the load() here.
    # load("@bazel_federation//setup:bazel_skylib.bzl", "bazel_skylib_setup")
    # bazel_skylib_setup()


def bazel_stardoc_deps():
    bazel_skylib()
    rules_java()


def bazel_stardoc():
    bazel_stardoc_deps()
    maybe(
        http_archive,
        name="io_bazel_skydoc",
        url="https://github.com/bazelbuild/skydoc/archive/0.3.0.tar.gz",
        sha256="c2d66a0cc7e25d857e480409a8004fdf09072a1bd564d6824441ab2f96448eea",
        strip_prefix="skydoc-0.3.0",
    )


def platforms():
    # Repository of standard constraint settings and values.
    # Bazel declares this automatically after 0.28.0, but it's better to
    # define an explicit version.
    maybe(
        http_archive,
        name = "platforms",
        strip_prefix = "platforms-441afe1bfdadd6236988e9cac159df6b5a9f5a98",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/platforms/archive/441afe1bfdadd6236988e9cac159df6b5a9f5a98.zip",
            "https://github.com/bazelbuild/platforms/archive/441afe1bfdadd6236988e9cac159df6b5a9f5a98.zip",
        ],
        sha256 = "a07fe5e75964361885db725039c2ba673f0ee0313d971ae4f50c9b18cd28b0b5",
    )

def protobuf_deps(load_rules_proto):
    bazel_skylib()
    rules_cc()
    rules_java()
    rules_python()
    six()
    zlib()
    protobuf_javalite()
    if load_rules_proto:
        rules_proto(load_protobuf=False)


def protobuf(load_rules_proto=True):
    protobuf_deps(load_rules_proto)
    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "758249b537abba2f21ebc2d02555bf080917f0f2f88f4cbe2903e0e28c4187ed",
        strip_prefix = "protobuf-3.10.0",
        urls = [
            "https://mirror.bazel.build/github.com/protocolbuffers/protobuf/archive/v3.10.0.tar.gz",
            "https://github.com/protocolbuffers/protobuf/archive/v3.10.0.tar.gz",
        ],
    )
    native.bind(name="com_google_protobuf_cc", actual="@com_google_protobuf")
    native.bind(name="com_google_protobuf_java", actual="@com_google_protobuf")


def protobuf_javalite_deps():
    pass


def protobuf_javalite():
    protobuf_javalite_deps()
    maybe(
        http_archive,
        name="com_google_protobuf_javalite",
        strip_prefix="protobuf-javalite",
        urls=["https://github.com/protocolbuffers/protobuf/archive/javalite.zip"],
    )


def rules_cc_deps():
    bazel_skylib()


def rules_cc():
    rules_cc_deps()
    maybe(
        http_archive,
        name="rules_cc",
        url="https://github.com/bazelbuild/rules_cc/archive/624b5d59dfb45672d4239422fa1e3de1822ee110.zip",
        sha256="8c7e8bf24a2bf515713445199a677ee2336e1c487fa1da41037c6026de04bbc3",
        strip_prefix="rules_cc-624b5d59dfb45672d4239422fa1e3de1822ee110",
        type="zip",
    )


def rules_docker_deps():
    bazel_gazelle()
    bazel_skylib()
    rules_go()
    rules_python()
    subpar()


def rules_docker():
    rules_docker_deps()
    maybe(
        http_archive,
        name = "io_bazel_rules_docker",
        sha256 = "dc97fccceacd4c6be14e800b2a00693d5e8d07f69ee187babfd04a80a9f8e250",
        strip_prefix = "rules_docker-0.14.1",
        urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.14.1/rules_docker-v0.14.1.tar.gz"],
    )


def rules_go_deps_call_after_repo():
    bazel_skylib()
    platforms()
    org_golang_x_tools_REQUIRES_RULES_GO()
    com_github_golang_protobuf_REQUIRES_RULES_GO()
    com_github_mwitkow_go_proto_validators_REQUIRES_RULES_GO()
    com_github_gogo_protobuf_REQUIRES_RULES_GO()
    org_golang_google_genproto_REQUIRES_RULES_GO()
    go_googleapis_REQUIRES_RULES_GO()


def rules_go():
    maybe(
        http_archive,
        name="io_bazel_rules_go",
        urls=[
            "https://github.com/bazelbuild/rules_go/releases/download/v0.20.2/rules_go-v0.20.2.tar.gz"
        ],
        sha256="b9aa86ec08a292b97ec4591cf578e020b35f98e12173bbd4a921f84f583aebd9",
    )
    # We need to call the deps function after defining @io_bazel_rules_go since some dependencies require
    # patches from the repo.
    # TODO: decide how to handle patches
    rules_go_deps_call_after_repo()


def rules_java_deps():
    # TODO(aiuto): When rules_java stabalizes, reference the deps directly.
    # rules_java is going to be changing for the next few months. While that
    # is happening we let rules_java_setup() bring in the deps. This allows
    # use to quicky update rules_java without havig to update all of the deps
    # tree which is only used by Java.
    bazel_skylib()


def rules_java():
    rules_java_deps()
    maybe(
        http_archive,
        name="rules_java",
        urls=[
            "https://mirror.bazel.build/github.com/bazelbuild/rules_java/archive/rules_java-0.1.1.tar.gz",
            "https://github.com/bazelbuild/rules_java/releases/download/0.1.1/rules_java-0.1.1.tar.gz",
        ],
        sha256="220b87d8cfabd22d1c6d8e3cdb4249abd4c93dcc152e0667db061fb1b957ee68",
    )


def rules_nodejs_deps():
    pass


def rules_nodejs():
    rules_nodejs_deps()
    maybe(
        http_archive,
        name="build_bazel_rules_nodejs",
        url="https://github.com/bazelbuild/rules_nodejs/releases/download/0.30.1/rules_nodejs-0.30.1.tar.gz",
        sha256="abcf497e89cfc1d09132adfcd8c07526d026e162ae2cb681dcb896046417ce91",
    )


def rules_pkg_deps():
    pass


def rules_pkg():
    rules_pkg_deps()
    maybe(
        http_archive,
        name="rules_pkg",
        urls=[
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.2.4/rules_pkg-0.2.4.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.2.4/rules_pkg-0.2.4.tar.gz",
        ],
        sha256="4ba8f4ab0ff85f2484287ab06c0d871dcb31cc54d439457d28fd4ae14b18450a",
    )


def rules_proto_deps(load_protobuf):
    bazel_skylib()
    if load_protobuf:
        protobuf(load_rules_proto=False)


def rules_proto(load_protobuf=True):
    rules_proto_deps(load_protobuf)
    maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "602e7161d9195e50246177e7c55b2f39950a9cf7366f74ed5f22fd45750cd208",
        strip_prefix = "rules_proto-97d8af4dc474595af3900dd85cb3a29ad28cc313",
        urls = ["https://github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz"],
    )


def rules_python_deps():
    pass


def rules_python():
    rules_python_deps()
    maybe(
        http_archive,
        name="rules_python",
        strip_prefix="rules_python-0.0.1",
        type="zip",
        url="https://github.com/bazelbuild/rules_python/archive/0.0.1.zip",
        sha256="f73c0cf51c32c7aaeaf02669ed03b32d12f2d92e1b05699eb938a75f35a210f4",
    )


def rules_rust_deps():
    bazel_skylib()


def rules_rust():
    rules_rust_deps()
    maybe(
        http_archive,
        name="io_bazel_rules_rust",
        strip_prefix="rules_rust-55f77017a7f5b08e525ebeab6e11d8896a4499d2",
        url="https://github.com/bazelbuild/rules_rust/archive/55f77017a7f5b08e525ebeab6e11d8896a4499d2.tar.gz",
        sha256="b6da34e057a31b8a85e343c732de4af92a762f804fc36b0baa6c001423a70ebc",
    )


def rules_sass_deps():
    bazel_skylib()
    rules_nodejs()


def rules_sass():
    rules_sass_deps()
    maybe(
        git_repository,
        name="io_bazel_rules_sass",
        remote="https://github.com/bazelbuild/rules_sass.git",
        commit="8ccf4f1c351928b55d5dddf3672e3667f6978d60",
    )


def rules_scala_deps():
    bazel_skylib()


def rules_scala():
    rules_scala_deps()
    maybe(
        http_archive,
        name="io_bazel_rules_scala",
        strip_prefix="rules_scala-300b4369a0a56d9e590d9fea8a73c3913d758e12",
        type="zip",
        # commit from 2019-05-27
        url="https://github.com/bazelbuild/rules_scala/archive/300b4369a0a56d9e590d9fea8a73c3913d758e12.zip",
        sha256="7f35ee7d96b22f6139b81da3a8ba5fb816e1803ed097f7295b85b7a56e4401c7",
    )

