#!/usr/bin/env python3
#
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

# A script for generating a WORKSPACE file for a specific member project of the federation.
# It will be invoked by CI runners during the setup step of a test task.

import argparse
import os
import os.path
import sys
import utils


WORKSPACE_TEMPLATE = """workspace(name = "{repo}_federation_example")

local_repository(
    name = "bazel_federation",
    path = "..",
)

load("@bazel_federation//:repositories.bzl", "{project}")

{project}()

load("@bazel_federation//setup:{project}.bzl", "{project}_setup")

{project}_setup()
"""


INTERNAL_SETUP_TEMPLATE = """load("@bazel_federation//internal/deps:{repo}.bzl", "{project}_internal_deps")

{project}_internal_deps()

load("@bazel_federation//internal/setup:{repo}.bzl", "{project}_internal_setup")

{project}_internal_setup()
"""


def create_new_workspace(project_name, repo_name, add_internal_setup):
    workspace = WORKSPACE_TEMPLATE.format(project=project_name, repo=repo_name)
    if add_internal_setup:
        workspace = "{}\n{}".format(
            workspace, INTERNAL_SETUP_TEMPLATE.format(project=project_name, repo=repo_name)
        )

    return workspace


def set_up_project(project_name, workspace_content):
    os.mkdir(project_name)
    path = os.path.join(os.getcwd(), project_name, "WORKSPACE")
    with open(path, "w") as f:
        f.write(workspace_content)


def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]

    parser = argparse.ArgumentParser(description="Bazel Federation WORKSPACE Generation Script")
    parser.add_argument("--project", type=str, required=True)
    parser.add_argument("--repo", type=str)
    parser.add_argument("--internal", type=int, default=1)
    # TODO(https://github.com/bazelbuild/bazel-federation/issues/78): Turn it into a boolean
    # flag that defaults to False once all presubmit configurations have been migrated.

    args = parser.parse_args(argv)

    try:
        content = create_new_workspace(args.project, args.repo or args.project, bool(args.internal))
        set_up_project(args.project, content)
    except Exception as ex:
        utils.eprint(ex)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
