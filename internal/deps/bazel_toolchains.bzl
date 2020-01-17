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


"""Dependencies for bazel_toolchains tests and tools."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load("@bazel_federation//:tools.bzl", "assert_unmodified_repositories")
load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")
load(
    "@io_bazel_rules_docker//repositories:go_repositories.bzl",
    container_go_deps = "go_deps",
)
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)
load("//rules:gcs.bzl", "gcs_file")


def bazel_toolchains_internal_deps():
    # Copied from https://github.com/bazelbuild/bazel-toolchains/blob/master/WORKSPACE
    # Ideally the following code would be in a bzl file.
    snapshot = native.existing_rules()

    # TOOD: move to rules_docker functions
    container_deps()
    assert_unmodified_repositories(snapshot)

    container_go_deps()
    assert_unmodified_repositories(snapshot)

    container_pull(
        name = "official_jessie",
        registry = "index.docker.io",
        repository = "library/debian",
        tag = "jessie",
    )

    container_pull(
        name = "official_xenial",
        registry = "index.docker.io",
        repository = "library/ubuntu",
        tag = "16.04",
    )

    # Pinned to marketplace.gcr.io/google/clang-ubuntu@sha256:ab3f65314c94279e415926948f8428428e3b6057003f15197ffeae0b1b5a2386
    # solely for testing purpose used by //tests/config:ubuntu16_04_clang_autoconfig_test.
    container_pull(
        name = "ubuntu16_04-clang-test",
        digest = "sha256:ab3f65314c94279e415926948f8428428e3b6057003f15197ffeae0b1b5a2386",
        registry = "marketplace.gcr.io",
        repository = "google/clang-ubuntu",
    )

    # Test purpose only. bazel-toolchains repo at release for Bazel 0.24.0.
    # https://github.com/bazelbuild/bazel-toolchains/releases/tag/cddc376
    http_file(
        name = "bazel_toolchains_test",
        downloaded_file_path = "cddc376d428ada2927ad359211c3e356bd9c9fbb.tar.gz",
        sha256 = "67335b3563d9b67dc2550b8f27cc689b64fadac491e69ce78763d9ba894cc5cc",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/cddc376d428ada2927ad359211c3e356bd9c9fbb.tar.gz",
            "https://github.com/bazelbuild/bazel-toolchains/archive/cddc376d428ada2927ad359211c3e356bd9c9fbb.tar.gz",
        ],
    )

    # Download test file to test gcs_file rule
    gcs_file(
        name = "download_test_gcs_file",
        bucket = "gs://bazel-toolchains-test",
        downloaded_file_path = "test.txt",
        file = "test.txt",
        sha256 = "5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9",
    )