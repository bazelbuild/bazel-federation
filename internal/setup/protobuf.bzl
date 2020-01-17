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

"""Setup for protobuf tests and tools."""

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
load("@bazel_tools//tools/build_defs/repo:jvm.bzl", "jvm_maven_import_external")


def protobuf_internal_setup():
    native.local_repository(
        name = "com_google_protobuf_examples",
        path = "examples",
    )

    native.bind(
        name = "python_headers",
        actual = "//util/python:python_headers",
    )

    # protobuf uses a local_repository called "submodule_gmock" for googletest.
    # We use the real googletest repo instead.
    native.bind(
        name = "gtest",
        actual = "@googletest//:gtest",
    )

    native.bind(
        name = "gtest_main",
        actual = "@googletest//:gtest_main",
    )

    jvm_maven_import_external(
        name = "guava_maven",
        artifact = "com.google.guava:guava:18.0",
        artifact_sha256 = "d664fbfc03d2e5ce9cab2a44fb01f1d0bf9dfebeccc1a473b1f9ea31f79f6f99",
        server_urls = [
            "https://jcenter.bintray.com/",
            "https://repo1.maven.org/maven2",
        ],
    )

    native.bind(
        name = "guava",
        actual = "@guava_maven//jar",
    )

    jvm_maven_import_external(
        name = "gson_maven",
        artifact = "com.google.code.gson:gson:2.7",
        artifact_sha256 = "2d43eb5ea9e133d2ee2405cc14f5ee08951b8361302fdd93494a3a997b508d32",
        server_urls = [
            "https://jcenter.bintray.com/",
            "https://repo1.maven.org/maven2",
        ],
    )

    native.bind(
        name = "gson",
        actual = "@gson_maven//jar",
    )

    jvm_maven_import_external(
        name = "error_prone_annotations_maven",
        artifact = "com.google.errorprone:error_prone_annotations:2.3.2",
        artifact_sha256 = "357cd6cfb067c969226c442451502aee13800a24e950fdfde77bcdb4565a668d",
        server_urls = [
            "https://jcenter.bintray.com/",
            "https://repo1.maven.org/maven2",
        ],
    )

    native.bind(
        name = "error_prone_annotations",
        actual = "@error_prone_annotations_maven//jar",
    )

    # For `cc_proto_blacklist_test`.
    bazel_skylib_workspace()
