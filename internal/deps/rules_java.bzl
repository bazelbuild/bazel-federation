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

"""Dependencies that are needed for rules_java tests and tools.

This file is only a wrapper around @rules_java//:internal_deps.bzl and will
go away once all project repositories contain their own internal_deps and
internal_setup files.
"""

load("@rules_java//:internal_deps.bzl", _func = "rules_java_internal_deps")

def rules_java_internal_deps():
    _func()
