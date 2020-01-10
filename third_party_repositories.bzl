load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")


def abseil_py():
    maybe(
        http_archive,
        name = "io_abseil_py",
        repo_mapping = {"@six_archive" : "@six"},
        sha256 = "3d0f39e0920379ff1393de04b573bca3484d82a5f8b939e9e83b20b6106c9bbe",
        strip_prefix = "abseil-py-pypi-v0.7.1",
        urls = [
            "https://mirror.bazel.build/github.com/abseil/abseil-py/archive/pypi-v0.7.1.tar.gz",
            "https://github.com/abseil/abseil-py/archive/pypi-v0.7.1.tar.gz",
        ],
    )

def futures_2_whl():
    maybe(
        http_file,
        name = "futures_2_2_0_whl",
        downloaded_file_path = "futures-2.2.0-py2.py3-none-any.whl",
        sha256 = "9fd22b354a4c4755ad8c7d161d93f5026aca4cfe999bd2e53168f14765c02cd6",
        # From https://pypi.python.org/pypi/futures/2.2.0
        urls = [
            "https://mirror.bazel.build/pypi.python.org/packages/d7/1d/68874943aa37cf1c483fc61def813188473596043158faa6511c04a038b4/futures-2.2.0-py2.py3-none-any.whl",
            "https://pypi.python.org/packages/d7/1d/68874943aa37cf1c483fc61def813188473596043158faa6511c04a038b4/futures-2.2.0-py2.py3-none-any.whl",
        ],
    )

def futures_3_whl():
    maybe(
        http_file,
        name = "futures_3_1_1_whl",
        downloaded_file_path = "futures-3.1.1-py2-none-any.whl",
        sha256 = "c4884a65654a7c45435063e14ae85280eb1f111d94e542396717ba9828c4337f",
        # From https://pypi.python.org/pypi/futures
        urls = [
            "https://mirror.bazel.build/pypi.python.org/packages/a6/1c/72a18c8c7502ee1b38a604a5c5243aa8c2a64f4bba4e6631b1b8972235dd/futures-3.1.1-py2-none-any.whl",
            "https://pypi.python.org/packages/a6/1c/72a18c8c7502ee1b38a604a5c5243aa8c2a64f4bba4e6631b1b8972235dd/futures-3.1.1-py2-none-any.whl",
        ],
    )

def google_cloud_language_whl():
    maybe(
        http_file,
        name = "google_cloud_language_whl",
        downloaded_file_path = "google_cloud_language-0.29.0-py2.py3-none-any.whl",
        sha256 = "a2dd34f0a0ebf5705dcbe34bd41199b1d0a55c4597d38ed045bd183361a561e9",
        # From https://pypi.python.org/pypi/google-cloud-language
        urls = [
            "https://mirror.bazel.build/pypi.python.org/packages/6e/86/cae57e4802e72d9e626ee5828ed5a646cf4016b473a4a022f1038dba3460/google_cloud_language-0.29.0-py2.py3-none-any.whl",
            "https://pypi.python.org/packages/6e/86/cae57e4802e72d9e626ee5828ed5a646cf4016b473a4a022f1038dba3460/google_cloud_language-0.29.0-py2.py3-none-any.whl",
        ],
    )

def grpc_whl():
    maybe(
        http_file,
        name = "grpc_whl",
        downloaded_file_path = "grpcio-1.6.0-cp27-cp27m-manylinux1_i686.whl",
        sha256 = "c232d6d168cb582e5eba8e1c0da8d64b54b041dd5ea194895a2fe76050916561",
        # From https://pypi.python.org/pypi/grpcio/1.6.0
        urls = [
            "https://mirror.bazel.build/pypi.python.org/packages/c6/28/67651b4eabe616b27472c5518f9b2aa3f63beab8f62100b26f05ac428639/grpcio-1.6.0-cp27-cp27m-manylinux1_i686.whl",
            "https://pypi.python.org/packages/c6/28/67651b4eabe616b27472c5518f9b2aa3f63beab8f62100b26f05ac428639/grpcio-1.6.0-cp27-cp27m-manylinux1_i686.whl",
        ],
    )

JINJA2_BUILD_FILE = """
py_library(
    name = "jinja2",
    srcs = glob(["jinja2/*.py"]),
    srcs_version = "PY2AND3",
    deps = [
        "@markupsafe_archive//:markupsafe",
    ],
    visibility = ["//visibility:public"],
)
"""

def jinja2():
    maybe(
        http_archive,
        name = "jinja2_archive",
        urls = [
            "https://mirror.bazel.build/pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz",
            "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz",
        ],
        sha256 = "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4",
        build_file_content = JINJA2_BUILD_FILE,
        strip_prefix = "Jinja2-2.8",
    )
    native.bind(
        name = "jinja2",
        actual = "@jinja2_archive//:jinja2",
    )

# For manual testing against an LLVM toolchain.
# Use --crosstool_top=@llvm_toolchain//:toolchain
def llvm_toolchain():
    maybe(
        http_archive,
        name = "com_grail_bazel_toolchain",
        sha256 = "aafea89b6abe75205418c0d2127252948afe6c7f2287a79b67aab3e0c3676c4f",
        strip_prefix = "bazel-toolchain-d0a5b0af3102c7c607f2cf098421fcdbaeaaaf19",
        urls = [
            "https://mirror.bazel.build/github.com/grailbio/bazel-toolchain/archive/d0a5b0af3102c7c607f2cf098421fcdbaeaaaf19.tar.gz",
            "https://github.com/grailbio/bazel-toolchain/archive/d0a5b0af3102c7c607f2cf098421fcdbaeaaaf19.tar.gz",
        ],
    )

MARKUPSAFE_BUILD_FILE = """
py_library(
    name = "markupsafe",
    srcs = glob(["markupsafe/*.py"]),
    srcs_version = "PY2AND3",
    visibility = ["//visibility:public"],
)
"""

def markupsafe():
    maybe(
        http_archive,
        name = "markupsafe_archive",
        urls = [
            "https://mirror.bazel.build/pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz",
            "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz",
        ],
        sha256 = "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3",
        build_file_content = MARKUPSAFE_BUILD_FILE,
        strip_prefix = "MarkupSafe-0.23",
    )
    native.bind(
        name = "markupsafe",
        actual = "@markupsafe_archive//:markupsafe",
    )

MISTUNE_BUILD_FILE = """
py_library(
    name = "mistune",
    srcs = ["mistune.py"],
    srcs_version = "PY2AND3",
    visibility = ["//visibility:public"],
)
"""

def mistune():
    maybe(
        http_archive,
        name = "mistune_archive",
        urls = [
            "https://mirror.bazel.build/pypi.python.org/packages/source/m/mistune/mistune-0.7.1.tar.gz",
            "https://pypi.python.org/packages/source/m/mistune/mistune-0.7.1.tar.gz",
        ],
        sha256 = "6076dedf768348927d991f4371e5a799c6a0158b16091df08ee85ee231d929a7",
        build_file_content = MISTUNE_BUILD_FILE,
        strip_prefix = "mistune-0.7.1",
    )
    native.bind(
        name = "mistune",
        actual = "@mistune_archive//:mistune",
    )

def mock_whl():
    maybe(
        http_file,
        name = "mock_whl",
        downloaded_file_path = "mock-2.0.0-py2.py3-none-any.whl",
        sha256 = "5ce3c71c5545b472da17b72268978914d0252980348636840bd34a00b5cc96c1",
        # From https://pypi.python.org/pypi/mock
        urls = [
            "https://mirror.bazel.build/pypi.python.org/packages/e6/35/f187bdf23be87092bd0f1200d43d23076cee4d0dec109f195173fd3ebc79/mock-2.0.0-py2.py3-none-any.whl",
            "https://pypi.python.org/packages/e6/35/f187bdf23be87092bd0f1200d43d23076cee4d0dec109f195173fd3ebc79/mock-2.0.0-py2.py3-none-any.whl",
        ],
    )

def org_golang_x_tools_REQUIRES_RULES_GO():
    maybe(
        git_repository,
        name = "org_golang_x_tools",
        remote = "https://go.googlesource.com/tools",
        # master (latest) as of 2019-10-05
        commit = "c9f9432ec4b21a28c4d47f172513698febb68e9c",
        patches = [
            "@io_bazel_rules_go//third_party:org_golang_x_tools-deletegopls.patch",
            "@io_bazel_rules_go//third_party:org_golang_x_tools-gazelle.patch",
            "@io_bazel_rules_go//third_party:org_golang_x_tools-extras.patch",
        ],
        patch_args = ["-p1"],
        shallow_since = "1570239844 +0000",
        # gazelle args: -go_prefix golang.org/x/tools
    )

def com_github_golang_protobuf_REQUIRES_RULES_GO():
    # Go protoc plugin and runtime library
    # We need to apply a patch to enable both go_proto_library and
    # go_library with pre-generated sources.
    maybe(
        git_repository,
        name = "com_github_golang_protobuf",
        remote = "https://github.com/golang/protobuf",
        # v1.3.1 (latest) as of 2019-10-05
        commit = "6c65a5562fc06764971b7c5d05c76c75e84bdbf7",
        shallow_since = "1562005321 -0700",
        patches = [
            "@io_bazel_rules_go//third_party:com_github_golang_protobuf-gazelle.patch",
            "@io_bazel_rules_go//third_party:com_github_golang_protobuf-extras.patch",
        ],
        patch_args = ["-p1"],
        # gazelle args: -go_prefix github.com/golang/protobuf -proto disable_global
    )

def com_github_mwitkow_go_proto_validators_REQUIRES_RULES_GO():
    # Extra protoc plugins and libraries.
    # Doesn't belong here, but low maintenance.
    maybe(
        git_repository,
        name = "com_github_mwitkow_go_proto_validators",
        remote = "https://github.com/mwitkow/go-proto-validators",
        # v0.2.0 (latest) as of 2019-10-05
        commit = "d70d97bb65387105677cb21cee7318e4feb7b4b0",
        shallow_since = "1568733758 +0100",
        patches = ["@io_bazel_rules_go//third_party:com_github_mwitkow_go_proto_validators-gazelle.patch"],
        patch_args = ["-p1"],
        # gazelle args: -go_prefix github.com/mwitkow/go-proto-validators -proto disable
    )

def com_github_gogo_protobuf_REQUIRES_RULES_GO():
    # Extra protoc plugins and libraries
    # Doesn't belong here, but low maintenance.
    maybe(
        git_repository,
        name = "com_github_gogo_protobuf",
        remote = "https://github.com/gogo/protobuf",
        # v1.3.0 (latest) as of 2019-10-05
        commit = "0ca988a254f991240804bf9821f3450d87ccbb1b",
        shallow_since = "1567336231 +0200",
        patches = ["@io_bazel_rules_go//third_party:com_github_gogo_protobuf-gazelle.patch"],
        patch_args = ["-p1"],
        # gazelle args: -go_prefix github.com/gogo/protobuf -proto legacy
    )

def org_golang_google_genproto_REQUIRES_RULES_GO():
    # go_library targets with pre-generated sources for Well Known Types
    # and Google APIs.
    # Doesn't belong here, but it would be an annoying source of errors if
    # this weren't generated with -proto disable_global.
    maybe(
        git_repository,
        name = "org_golang_google_genproto",
        remote = "https://github.com/google/go-genproto",
        # master (latest) as of 2019-10-05
        commit = "c459b9ce5143dd819763d9329ff92a8e35e61bd9",
        patches = ["@io_bazel_rules_go//third_party:org_golang_google_genproto-gazelle.patch"],
        patch_args = ["-p1"],
        # gazelle args: -go_prefix google.golang.org/genproto -proto disable_global
    )

def go_googleapis_REQUIRES_RULES_GO():
    # go_proto_library targets for gRPC and Google APIs.
    # TODO(rules_go#1986): migrate to com_google_googleapis. This workspace was added
    # before the real workspace supported Bazel. Gazelle resolves dependencies
    # here. Gazelle should resolve dependencies to com_google_googleapis
    # instead, and we should remove this.
    maybe(
        git_repository,
        name = "go_googleapis",
        remote = "https://github.com/googleapis/googleapis",
        # master (latest) as of 2019-10-05
        commit = "ceb8e2fb12f048cc94caae532ef0b4cf026a78f3",
        shallow_since = "1570228637 -0700",
        patches = [
            "@io_bazel_rules_go//third_party:go_googleapis-deletebuild.patch",
            "@io_bazel_rules_go//third_party:go_googleapis-directives.patch",
            "@io_bazel_rules_go//third_party:go_googleapis-gazelle.patch",
        ],
        patch_args = ["-E", "-p1"],
    )

def py_mock():
    maybe(
        http_archive,
        name = "py_mock",
        sha256 = "b839dd2d9c117c701430c149956918a423a9863b48b09c90e30a6013e7d2f44f",
        urls = [
            "https://mirror.bazel.build/pypi.python.org/packages/source/m/mock/mock-1.0.1.tar.gz",
            "https://pypi.python.org/packages/source/m/mock/mock-1.0.1.tar.gz",
        ],
        strip_prefix = "mock-1.0.1",
        patch_cmds = [
            "mkdir -p py/mock",
            "mv mock.py py/mock/__init__.py",
            """echo 'licenses(["notice"])' > BUILD""",
            "touch py/BUILD",
            """echo 'py_library(name = "mock", srcs = ["__init__.py"], visibility = ["//visibility:public"],)' > py/mock/BUILD""",
        ],
    )

def six():
    maybe(
        http_archive,
        name = "six",
        build_file = "@bazel_federation//:third_party/six.BUILD",
        sha256 = "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73",
        urls = [
            "https://mirror.bazel.build/pypi.python.org/packages/source/s/six/six-1.12.0.tar.gz",
            "https://pypi.python.org/packages/source/s/six/six-1.12.0.tar.gz",
        ],
    )

def subpar():
    maybe(
        git_repository,
        name = "subpar",
        remote = "https://github.com/google/subpar",
        tag = "2.0.0",
    )

def zlib():
    maybe(
        http_archive,
        name = "zlib",
        build_file = "@bazel_federation//:third_party/zlib.BUILD",
        sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",
        strip_prefix = "zlib-1.2.11",
        urls = [
            "https://mirror.bazel.build/zlib.net/zlib-1.2.11.tar.gz",
            "https://zlib.net/zlib-1.2.11.tar.gz",
        ],
    )
