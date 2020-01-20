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


"""Setup for bazel_gazelle."""

load("@bazel_federation//:tools.bzl", "assert_unmodified_repositories")
load("@bazel_federation//setup:bazel_skylib.bzl", "bazel_skylib_setup")
load("@bazel_federation//setup:rules_go.bzl", "rules_go_setup")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")


def bazel_gazelle_setup():
    bazel_skylib_setup()
    rules_go_setup()

    # Prevent gazelle from bringing in any dependencies that should be fetched from the federation.
    # Ideally we'd refactor go_rules_dependencies() by splitting it into two methods, with one of them executing the code that we actually need here.
    snapshot = native.existing_rules()
    gazelle_dependencies()
    # TODO(fweikert): add allowed deps to whitelist
    assert_unmodified_repositories(snapshot, whitelist=[])
