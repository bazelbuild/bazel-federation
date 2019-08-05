load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# TODO(aiuto): This can not exist here, because it loads bazel_skylib, which
#     is not defined yet. We get a cycle error.
# load("@bazel_federation//setup:bazel_skylib.bzl", "bazel_skylib_setup")

# Repositories in this file have been tested with Bazel 0.26.0.

def _maybe(repo, name, **kwargs):
    if not native.existing_rule(name):
        repo(name = name, **kwargs)

def bazel_skylib():
    if not native.existing_rule("bazel_skylib"):
        http_archive(
            name = "bazel_skylib",
            url = "https://github.com/bazelbuild/bazel-skylib/releases/download/0.9.0/bazel_skylib-0.9.0.tar.gz",
            sha256 = "1dde365491125a3db70731e25658dfdd3bc5dbdfd11b840b3e987ecf043c7ca0",
        )
        # TODO(aiuto): We should be able to call bazel_skylib_setup() here.
        #     That would register the toolchains. We can not because you can
        #     not do the load() here.
        # load("@bazel_federation//setup:bazel_skylib.bzl", "bazel_skylib_setup")
        # bazel_skylib_setup()

def bazel_stardoc():
    rules_java()
    _maybe(
        http_archive,
        name = "io_bazel_skydoc",
        url = "https://github.com/bazelbuild/skydoc/archive/0.3.0.tar.gz",
        sha256 = "c2d66a0cc7e25d857e480409a8004fdf09072a1bd564d6824441ab2f96448eea",
        strip_prefix = "skydoc-0.3.0",
    )


# The @federation markers are an experiment in how to pick up dependency stanzas
# from the rule sets. Each rule set should have a deps.bzl file. Inside those,
# there will be the @federation markers. Those must be designed so they can
# be extracted and dropped directly into this file, replacing the same stanza.


# @federation: BEGIN @rules_pkg
# TODO: ptr to where this was extracted from
# https://github.com/bazelbuild/rules_pkg/pkg/deps.bzl
def rules_pkg_dependencies():
    # Needed for helper tools
    _maybe(
        http_archive,
        name = "abseil_py",
        urls = [
            "https://github.com/abseil/abseil-py/archive/pypi-v0.7.1.tar.gz",
        ],
        sha256 = "3d0f39e0920379ff1393de04b573bca3484d82a5f8b939e9e83b20b6106c9bbe",
        strip_prefix = "abseil-py-pypi-v0.7.1",
    )

    # Needed by abseil-py. They do not use deps yet.
    _maybe(
        http_archive,
        name = "six_archive",
        urls = [
            "http://mirror.bazel.build/pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz",
            "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz",
        ],
        sha256 = "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a",
        strip_prefix = "six-1.10.0",
        build_file = "@abseil_py//third_party:six.BUILD"
    )


def rules_pkg_register_toolchains():
    pass


def rules_pkg():
    rules_pkg_dependencies()
    _maybe(
        http_archive,
        name = "rules_pkg",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/rules_pkg-0.2.1.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.2.1/rules_pkg-0.2.1.tar.gz",
        ],
        sha256 = "04c1eab736f508e94c297455915b6371432cbc4106765b5252b444d1656db051",
    )

# @federation: END @rules_pkg


def org_golang_x_tools():
    _maybe(
        http_archive,
        name = "org_golang_x_tools",
        # master^1, as of 2018-11-02 (master is currently broken)
        urls = ["https://codeload.github.com/golang/tools/zip/92b943e6bff73e0dfe9e975d94043d8f31067b06"],
        strip_prefix = "tools-92b943e6bff73e0dfe9e975d94043d8f31067b06",
        type = "zip",
        patches = [
            "@io_bazel_rules_go//third_party:org_golang_x_tools-gazelle.patch",
            "@io_bazel_rules_go//third_party:org_golang_x_tools-extras.patch",
        ],
        patch_args = ["-p1"],
        # gazelle args: -go_prefix golang.org/x/tools
    )

def org_golang_x_sys():
    _maybe(
        git_repository,
        name = "org_golang_x_sys",
        remote = "https://github.com/golang/sys",
        commit = "e4b3c5e9061176387e7cea65e4dc5853801f3fb7",  # master as of 2018-09-28
        patches = ["@io_bazel_rules_go//third_party:org_golang_x_sys-gazelle.patch"],
        patch_args = ["-p1"],
        # gazelle args: -go_prefix golang.org/x/sys
    )

def io_bazel_rules_go():
    org_golang_x_tools()
    org_golang_x_sys()
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
    bazel_skylib()
    http_archive(
        name = "io_bazel_rules_scala",
        strip_prefix = "rules_scala-300b4369a0a56d9e590d9fea8a73c3913d758e12",
        type = "zip",
        # commit from 2019-05-27
        url = "https://github.com/bazelbuild/rules_scala/archive/300b4369a0a56d9e590d9fea8a73c3913d758e12.zip",
        sha256 = "7f35ee7d96b22f6139b81da3a8ba5fb816e1803ed097f7295b85b7a56e4401c7",
    )

def io_bazel_rules_rust():
    bazel_skylib()
    http_archive(
        name = "io_bazel_rules_rust",
        strip_prefix = "rules_rust-f32695dcd02d9a19e42b9eb7f29a24a8ceb2b858",
        url = "https://github.com/bazelbuild/rules_rust/archive/f32695dcd02d9a19e42b9eb7f29a24a8ceb2b858.tar.gz",
        sha256 = "ed0c81084bcc2bdcc98cfe56f384b20856840825f5e413e2b71809b61809fc87",
    )


def rules_cc():
    bazel_skylib()
    _maybe(
        http_archive,
        name = "rules_cc",
        url = "https://github.com/bazelbuild/rules_cc/archive/b7fe9697c0c76ab2fd431a891dbb9a6a32ed7c3e.zip",
        sha256 = "67412176974bfce3f4cf8bdaff39784a72ed709fc58def599d1f68710b58d68b",
        strip_prefix = "rules_cc-b7fe9697c0c76ab2fd431a891dbb9a6a32ed7c3e",
        type = "zip",
    )


def rules_java():
    bazel_skylib()
    _maybe(
        http_archive,
        name = "rules_java",
        url = "https://github.com/bazelbuild/rules_java/releases/download/0.1.0/rules_java-0.1.0.tar.gz",
        sha256 = "52423cb07384572ab60ef1132b0c7ded3a25c421036176c0273873ec82f5d2b2",
    )


def repositories():
    bazel_skylib()
    io_bazel_rules_go()
    bazel_gazelle()
    com_github_bazelbuild_buildtools()
    io_bazel_rules_scala()
    io_bazel_rules_rust()
