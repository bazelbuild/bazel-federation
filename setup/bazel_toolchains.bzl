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

load("@bazel_toolchains//rules:rbe_repo.bzl", "rbe_autoconfig")

def bazel_toolchains_setup():
    # Creates a default toolchain config for RBE.
    # Use this as is if you are using the rbe_ubuntu16_04 container,
    # otherwise refer to RBE docs.
    rbe_autoconfig(name = "rbe_default")
