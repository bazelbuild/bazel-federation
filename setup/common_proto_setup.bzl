# Copyright 2020 The Bazel Authors. All rights reserved.
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

load("@rules_proto//proto:repositories.bzl", "rules_proto_toolchains")

"""This file handles setup for rules_proto and protobuf.

There is a dependency cycle between these two projects,
hence the need for this file.
"""

def common_proto_setup():
    _rules_proto_setup()
    _protobuf_setup()

def _rules_proto_setup():
    # Do not call rules_proto_dependencies() since it also fetches dependencies of com_google_protobuf
    rules_proto_toolchains()

def _protobuf_setup():
    pass
