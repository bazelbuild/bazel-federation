# Copyright 2019 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from bazel_federation import workspace

# yapf: disable

dependencies = {
    "bazel": workspace.define_forward("io_bazel"),
    "bazel_gazelle": workspace.define_http_archive(
        sha256 = "7949fc6cc17b5b191103e97481cf8889217263acf52e00b560683413af204fcb",
        urls = [
            "https://github.com/bazelbuild/bazel-gazelle/releases/download/0.16.0/bazel-gazelle-0.16.0.tar.gz",
        ],
        deps = [
            "rules_go",
        ],
    ),
    "bazel_skylib": workspace.define_http_archive(
        sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
        ],
    ),
    "bazel_stardoc": workspace.define_forward("io_bazel_skydoc"),
    "bazel_toolchains": workspace.define_http_archive(
        sha256 = "5962fe677a43226c409316fcb321d668fc4b7fa97cb1f9ef45e7dc2676097b26",
        strip_prefix = "bazel-toolchains-be10bee3010494721f08a0fccd7f57411a1e773e",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/be10bee3010494721f08a0fccd7f57411a1e773e.tar.gz",
            "https://github.com/bazelbuild/bazel-toolchains/archive/be10bee3010494721f08a0fccd7f57411a1e773e.tar.gz",
        ],
    ),
    "build_bazel_integration_testing": workspace.define_http_archive(
        strip_prefix = "bazel-integration-testing-13a7d5112aaae5572544c609f364d430962784b1",
        sha256 = "8028ceaad3613404254d6b337f50dc52c0fe77522d0db897f093dd982c6e63ee",
        urls = [
            "https://github.com/bazelbuild/bazel-integration-testing/archive/13a7d5112aaae5572544c609f364d430962784b1.zip",
        ],
    ),
    "build_bazel_rules_nodejs": workspace.define_http_archive(
        sha256 = "abcf497e89cfc1d09132adfcd8c07526d026e162ae2cb681dcb896046417ce91",
        urls = [
            "https://github.com/bazelbuild/rules_nodejs/releases/download/0.30.1/rules_nodejs-0.30.1.tar.gz",
        ],
    ),
    "com_github_bazelbuild_buildtools": workspace.define_http_archive(
        strip_prefix = "buildtools-f27d1753c8b3210d9e87cdc9c45bc2739ae2c2db",
        sha256 = "cdaac537b56375f658179ee2f27813cac19542443f4722b6730d84e4125355e6",
        urls = [
            "https://github.com/bazelbuild/buildtools/archive/f27d1753c8b3210d9e87cdc9c45bc2739ae2c2db.zip",
        ],
        deps = [
            "bazel_skylib",
            "rules_go",
        ],
    ),
    "com_google_protobuf": workspace.define_http_archive(
        sha256 = "758249b537abba2f21ebc2d02555bf080917f0f2f88f4cbe2903e0e28c4187ed",
        strip_prefix = "protobuf-3.10.0",
        urls = [
            "https://mirror.bazel.build/github.com/protocolbuffers/protobuf/archive/v3.10.0.tar.gz",
            "https://github.com/protocolbuffers/protobuf/archive/v3.10.0.tar.gz",
        ],
        deps = [
            "bazel_skylib",
            "rules_cc",
            "rules_java",
            "rules_proto",
            "rules_python",
            "protobuf_javalite",
            "zlib",
        ],
    ),
    "com_google_protobuf_cc": workspace.define_forward("com_google_protobuf"),
    "com_google_protobuf_java": workspace.define_forward("com_google_protobuf"),
    "com_google_protobuf_javalite": workspace.define_git_repository(
        remote = "https://github.com/protocolbuffers/protobuf.git",
        commit = "7b64714af67aa967dcf941df61fe5207975966be",  # javalite / Aug 23, 2019
        deps = [
            "rules_cc",
            "rules_java",
            "rules_proto",
            "rules_python",
        ],
    ),
    "io_bazel": workspace.define_git_repository(
        remote = "https://github.com/bazelbuild/bazel.git",
        commit = "c689bf93917ad0efa8100b3a0fe1b43f1f1a1cdf",  # master / Mar 19, 2019
    ),
    "io_bazel_rules_go": workspace.define_http_archive(
        urls = [
            "https://github.com/bazelbuild/rules_go/archive/0c1081b3618a2c6ca1220f7f7ffb644a2955ddf8.zip",
        ],
        sha256 = "3cb1bf7f2a3bbd9bed618234a792ce522093138a6298d6d4688b7b8018a49f8b",
        strip_prefix = "rules_go-0c1081b3618a2c6ca1220f7f7ffb644a2955ddf8",
        deps = [
            "bazel_skylib",
        ],
    ),
    "io_bazel_rules_rust": workspace.define_http_archive(
        strip_prefix = "rules_rust-55f77017a7f5b08e525ebeab6e11d8896a4499d2",
        urls = [
            "https://github.com/bazelbuild/rules_rust/archive/55f77017a7f5b08e525ebeab6e11d8896a4499d2.tar.gz",
        ],
        sha256 = "b6da34e057a31b8a85e343c732de4af92a762f804fc36b0baa6c001423a70ebc",
        deps = [
            "bazel_skylib",
        ],
    ),
    "io_bazel_rules_sass": workspace.define_git_repository(
        remote = "https://github.com/bazelbuild/rules_sass.git",
        commit = "8ccf4f1c351928b55d5dddf3672e3667f6978d60",
        deps = [
            "bazel_skylib",
            "rules_nodejs",
        ],
    ),
    "io_bazel_rules_scala": workspace.define_http_archive(
        strip_prefix = "rules_scala-300b4369a0a56d9e590d9fea8a73c3913d758e12",
        urls = [
            "https://github.com/bazelbuild/rules_scala/archive/300b4369a0a56d9e590d9fea8a73c3913d758e12.zip",  # commit from 2019-05-27
        ],
        sha256 = "7f35ee7d96b22f6139b81da3a8ba5fb816e1803ed097f7295b85b7a56e4401c7",
        deps = [
            "bazel_skylib",
        ],
    ),
    "io_bazel_skydoc": workspace.define_http_archive(
        urls = [
            "https://github.com/bazelbuild/skydoc/archive/0.3.0.tar.gz",
        ],
        sha256 = "c2d66a0cc7e25d857e480409a8004fdf09072a1bd564d6824441ab2f96448eea",
        strip_prefix = "skydoc-0.3.0",
        deps = [
            "bazel_skylib",
            "rules_java",
        ],
    ),
    "jinja2": workspace.define_load("//:third_party_repositories.bzl", "jinja2"),
    "markupsafe": workspace.define_load("//:third_party_repositories.bzl", "markupsafe"),
    "mistune": workspace.define_load("//:third_party_repositories.bzl", "mistune"),
    "org_golang_x_sys": workspace.define_load(
        "//:third_party_repositories.bzl",
        "org_golang_x_sys",
    ),
    "org_golang_x_tools": workspace.define_load(
        "//:third_party_repositories.bzl",
        "org_golang_x_tools",
    ),
    "protobuf": workspace.define_forward("com_google_protobuf"),
    "protobuf_javalite": workspace.define_forward("com_google_protobuf_javalite"),
    "rules_cc": workspace.define_http_archive(
        urls = [
            "https://github.com/bazelbuild/rules_cc/archive/624b5d59dfb45672d4239422fa1e3de1822ee110.zip",
        ],
        sha256 = "8c7e8bf24a2bf515713445199a677ee2336e1c487fa1da41037c6026de04bbc3",
        strip_prefix = "rules_cc-624b5d59dfb45672d4239422fa1e3de1822ee110",
        deps = [
            "bazel_skylib",
            "rules_proto",
        ],
    ),
    "rules_go": workspace.define_forward("io_bazel_rules_go"),
    "rules_java": workspace.define_http_archive(
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_java/archive/rules_java-0.1.1.tar.gz",
            "https://github.com/bazelbuild/rules_java/releases/download/0.1.1/rules_java-0.1.1.tar.gz",
        ],
        sha256 = "220b87d8cfabd22d1c6d8e3cdb4249abd4c93dcc152e0667db061fb1b957ee68",
        deps = [
            "bazel_skylib",
        ],
    ),
    "rules_nodejs": workspace.define_forward("build_bazel_rules_nodejs"),
    "rules_pkg": workspace.define_http_archive(
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.2.4/rules_pkg-0.2.4.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.2.4/rules_pkg-0.2.4.tar.gz",
        ],
        sha256 = "4ba8f4ab0ff85f2484287ab06c0d871dcb31cc54d439457d28fd4ae14b18450a",
    ),
    "rules_proto": workspace.define_http_archive(
        strip_prefix = "rules_proto-0b96d7d6b4cdee3ef22b8b26a8ce8bf8dcc83478",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/0b96d7d6b4cdee3ef22b8b26a8ce8bf8dcc83478.tar.gz",
            "https://github.com/bazelbuild/rules_proto/archive/0b96d7d6b4cdee3ef22b8b26a8ce8bf8dcc83478.tar.gz",
        ],
        sha256 = "8fd4bb56703072e093fe2c20c1dc8a2ea92f8d8513b90ab462e1ad4240abc2c8",
        deps = [
            "com_google_protobuf",
        ],
    ),
    "rules_python": workspace.define_http_archive(
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_python/releases/download/0.0.1/rules_python-0.0.1.tar.gz",
            "https://github.com/bazelbuild/rules_python/releases/download/0.0.1/rules_python-0.0.1.tar.gz",
        ],
        sha256 = "aa96a691d3a8177f3215b14b0edc9641787abaaa30363a080165d06ab65e1161",
    ),
    "rules_rust": workspace.define_forward("io_bazel_rules_rust"),
    "rules_sass": workspace.define_forward("io_bazel_rules_sass"),
    "rules_scala": workspace.define_forward("io_bazel_rules_scala"),
    "zlib": workspace.define_load("//:third_party_repositories.bzl", "zlib"),
}
