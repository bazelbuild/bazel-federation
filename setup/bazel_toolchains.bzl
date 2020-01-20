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


"""Setup for bazel_toolchains."""

load("@bazel_federation//:tools.bzl", "assert_unmodified_repositories")
load(
    "@bazel_toolchains//repositories:repositories.bzl",
    bazel_toolchains_repositories = "repositories",
    bazel_toolchains_images = "images",
)
load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)
load("@bazel_toolchains//rules:rbe_repo.bzl", "rbe_autoconfig")


def bazel_toolchains_setup():
    # We only bazel_toolchains_repositories() for registering toolchains.
    # However, we need to prevent it from bringing in any dependencies
    # that should be loaded from the federation.
    # Ideally we'd refactor the function by splitting it into two,
    # with one of them executing the code that we actually need here.
    snapshot = native.existing_rules()
    bazel_toolchains_repositories()
    assert_unmodified_repositories(snapshot)

    # Same problem as above.
    container_repositories()
    assert_unmodified_repositories(snapshot)

    bazel_toolchains_images()

    # Creates a default toolchain config for RBE.
    # Use this as is if you are using the rbe_ubuntu16_04 container,
    # otherwise refer to RBE docs.
    rbe_autoconfig(name = "rbe_default")
