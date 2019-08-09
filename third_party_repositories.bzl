load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")


def _import_abseil_py(name):
    maybe(
        http_archive,
        name = name,
        sha256 = "3d0f39e0920379ff1393de04b573bca3484d82a5f8b939e9e83b20b6106c9bbe",
        strip_prefix = "abseil-py-pypi-v0.7.1",
        urls = [
            "https://github.com/abseil/abseil-py/archive/pypi-v0.7.1.tar.gz",
        ],
    )

def abseil_py():
    # TODO(fweikert): remove this hack. It's currently needed since rules_cc and rule_pkg
    # use different repository names for abseil.
    _import_abseil_py("abseil_py")
    _import_abseil_py("io_abseil_py")

def futures_2_whl():
    maybe(
        http_file,
        name = "futures_2_2_0_whl",
        downloaded_file_path = "futures-2.2.0-py2.py3-none-any.whl",
        sha256 = "9fd22b354a4c4755ad8c7d161d93f5026aca4cfe999bd2e53168f14765c02cd6",
        # From https://pypi.python.org/pypi/futures/2.2.0
        urls = [("https://pypi.python.org/packages/d7/1d/" +
                "68874943aa37cf1c483fc61def813188473596043158faa6511c04a038b4/" +
                "futures-2.2.0-py2.py3-none-any.whl")],
    )

def futures_3_whl():
    maybe(
        http_file,
        name = "futures_3_1_1_whl",
        downloaded_file_path = "futures-3.1.1-py2-none-any.whl",
        sha256 = "c4884a65654a7c45435063e14ae85280eb1f111d94e542396717ba9828c4337f",
        # From https://pypi.python.org/pypi/futures
        urls = [("https://pypi.python.org/packages/a6/1c/" +
                "72a18c8c7502ee1b38a604a5c5243aa8c2a64f4bba4e6631b1b8972235dd/" +
                "futures-3.1.1-py2-none-any.whl")],
    )

def google_cloud_language_whl():
    maybe(
        http_file,
        name = "google_cloud_language_whl",
        downloaded_file_path = "google_cloud_language-0.29.0-py2.py3-none-any.whl",
        sha256 = "a2dd34f0a0ebf5705dcbe34bd41199b1d0a55c4597d38ed045bd183361a561e9",
        # From https://pypi.python.org/pypi/google-cloud-language
        urls = [("https://pypi.python.org/packages/6e/86/" +
                "cae57e4802e72d9e626ee5828ed5a646cf4016b473a4a022f1038dba3460/" +
                "google_cloud_language-0.29.0-py2.py3-none-any.whl")],
    )

def grpc_whl():
    maybe(
        http_file,
        name = "grpc_whl",
        downloaded_file_path = "grpcio-1.6.0-cp27-cp27m-manylinux1_i686.whl",
        sha256 = "c232d6d168cb582e5eba8e1c0da8d64b54b041dd5ea194895a2fe76050916561",
        # From https://pypi.python.org/pypi/grpcio/1.6.0
        urls = [("https://pypi.python.org/packages/c6/28/" +
                "67651b4eabe616b27472c5518f9b2aa3f63beab8f62100b26f05ac428639/" +
                "grpcio-1.6.0-cp27-cp27m-manylinux1_i686.whl")],
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
        urls = ["https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz#md5=edb51693fe22c53cee5403775c71a99e"],
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
        urls = ["https://github.com/grailbio/bazel-toolchain/archive/d0a5b0af3102c7c607f2cf098421fcdbaeaaaf19.tar.gz"],
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
        urls = ["https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz#md5=f5ab3deee4c37cd6a922fb81e730da6e"],
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
        urls = ["https://pypi.python.org/packages/source/m/mistune/mistune-0.7.1.tar.gz#md5=057bc28bf629d6a1283d680a34ed9d0f"],
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
        urls = [("https://pypi.python.org/packages/e6/35/" +
                "f187bdf23be87092bd0f1200d43d23076cee4d0dec109f195173fd3ebc79/" +
                "mock-2.0.0-py2.py3-none-any.whl")],
    )

def org_golang_x_sys():
    maybe(
        git_repository,
        name = "org_golang_x_sys",
        remote = "https://github.com/golang/sys",
        commit = "e4b3c5e9061176387e7cea65e4dc5853801f3fb7",  # master as of 2018-09-28
        patches = ["@io_bazel_rules_go//third_party:org_golang_x_sys-gazelle.patch"],
        patch_args = ["-p1"],
        # gazelle args: -go_prefix golang.org/x/sys
    )

def org_golang_x_tools():
    maybe(
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
        name = "six_archive",
        build_file = "@bazel_federation//:third_party/six.BUILD",
        sha256 = "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a",
        urls = ["https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz#md5=34eed507548117b2ab523ab14b2f8b55"],
    )
    native.bind(name = "six", actual = "@six_archive//:six")

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
        urls = ["https://zlib.net/zlib-1.2.11.tar.gz"],
    )
    native.bind(name = "zlib", actual = "@net_zlib//:zlib")
