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

# A script for importing a new federation project. It automates several tasks:
#
# 1. Creation of a CI presubmit configuration that can be used in the federation test pipeline: The script
#    can either generate a standard configuration, or take the yaml configuration of a "regular" presubmit pipeline
#    and generate a modified version that can be used to test a project as part of the federation.
#    In both cases the script places the generated file in the right directory and registers the config in the master
#    config file.
# 2. Generation of boilerplate bzl files: It generates templates for required bzl files in several locations:
#    setup/$project.bzl, internal/deps/$project.bzl and internal/setup/$project.bzl

import argparse
import codecs
import os
import re
import sys
import urllib.request
import utils
import traceback
import yaml

# TODO(fweikert): keep this list in sync with PLATFORMS in https://github.com/bazelbuild/continuous-integration/blob/master/buildkite/bazelci.py
# (or find a better solution)
PYTHON_VERSIONS = {"debian10": "python3.7", "macos": "python3.7", "windows": "python.exe"}

DEFAULT_PYTHON_VERSION = "python3.6"

PROJECT_REGEX = re.compile(r"bazelbuild/([^/]+)/")

MASTER_CONFIG_FILE = os.path.join(utils.REPO_ROOT, ".bazelci/presubmit.yml")


CONFIG_TEMPLATE = """
---
tasks:
  ubuntu1604:
    build_targets:
    - "..."
    test_targets:
    - "..."
  ubuntu1804:
    build_targets:
    - "..."
    test_targets:
    - "..."
  macos:
    build_targets:
    - "..."
    test_targets:
    - "..."
  windows:
    build_targets:
    - "..."
    test_targets:
    - "..."
"""


HEADER = """# Copyright 2019 The Bazel Authors. All rights reserved.
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
"""

# """Setup for {project}"""
# """Setup for {project} tests and tools.
# """Dependencies for {project} tests and tools.

BZL_TEMPLATE = '''{header}

"""{kind} for {project}{maybe_tests}."""

load("@{repo}//:REPLACE_ME.bzl", ...)

def {project}_{func_suffix}():
    pass
'''

ALLOWED_KINDS = {"setup": "Setup", "deps": "Dependencies"}


class Error(Exception):
    """Base error class for this module.

    Currently it doesn't offer anything substantial, though.
    """


# Copied from https://github.com/bazelbuild/continuous-integration/blob/master/buildkite/bazelci.py
# TODO(fweikert): find a way to reuse the module easily
def str_presenter(dumper, data):
    if len(data.splitlines()) > 1:  # check for multiline string
        return dumper.represent_scalar("tag:yaml.org,2002:str", data, style="|")

    return dumper.represent_scalar("tag:yaml.org,2002:str", data)


def get_project_name_from_url(config_url):
    match = PROJECT_REGEX.search(config_url)
    if not match:
        raise Error(
            "Config URL '%s' does not point to a file in the "
            "bazelbuild GitHub organisation." % config_url
        )
    return match.group(1)


def load_config(http_url):
    return load_remote_config(http_url) if http_url else yaml.safe_load(CONFIG_TEMPLATE)


def load_remote_config(http_url):
    with urllib.request.urlopen(http_url) as resp:
        reader = codecs.getreader("utf-8")
        return yaml.safe_load(reader(resp))


def transform_config(project_name, repository_name, config):
    tasks = config.get("tasks") or config.get("platforms")
    for name, task_config in tasks.items():
        python = get_python_version_for_task(name, task_config)
        patch_script_path = utils.get_script_path("patch_repositories.py")
        ws_script_path = utils.get_script_path("create_project_workspace.py")
        task_config["setup"] = [
            "{} {}".format(python, patch_script_path),
            "{} {} --project={}".format(python, ws_script_path, project_name,),
        ]
        for field in ("run_targets", "build_targets", "test_targets"):
            targets = task_config.get(field)
            if targets:
                task_config[field] = transform_all_targets(repository_name, targets)

    return config


def get_python_version_for_task(name, task_config):
    platform = task_config.get("platform", name)
    return PYTHON_VERSIONS.get(platform, DEFAULT_PYTHON_VERSION)


def transform_all_targets(repository_name, targets):
    return [transform_target(repository_name, t) for t in targets]


def transform_target(repository_name, target):
    if target == "--" or target.startswith("@"):
        return target

    exclusion_prefix = ""
    if target.startswith("-"):
        exclusion_prefix = "-"
        target = target[1:]

    slashes = "" if target.startswith("//") else "//"
    return "{}@{}{}{}".format(exclusion_prefix, repository_name, slashes, target)


def update_master_config(project_name):
    master_config = load_master_config()
    if "imports" not in master_config:
        raise Error(
            "Master presubmit configuration at '%s'"
            " does not contain any 'imports'" % MASTER_CONFIG_FILE
        )

    config_name = "%s.yml" % project_name
    if config_name in master_config["imports"]:
        return

    master_config["imports"].append(config_name)
    master_config["imports"] = sorted(master_config["imports"])

    file_name = os.path.basename(MASTER_CONFIG_FILE)
    save_config_file(file_name, master_config)


def load_master_config():
    with open(MASTER_CONFIG_FILE, "r") as fd:
        return yaml.safe_load(fd)


def save_config_file(file_name, config):
    directory = os.path.dirname(MASTER_CONFIG_FILE)
    path = os.path.join(directory, file_name)
    with open(path, "w") as f:
        f.write(yaml.dump(config, default_flow_style=False))


def create_bzl_file(project, repo, internal=True, kind="setup"):
    display_kind = ALLOWED_KINDS.get(kind)
    if not display_kind:
        raise ValueError("Kind must be one of {}, not {}".format(ALLOWED_KINDS.keys(), kind))

    if kind == "deps" and not internal:
        raise ValueError("Kind = 'deps' with internal = False is not allowed")

    def MakeParts():
        return ["internal"] if internal else []

    suffix_parts = MakeParts() + [kind]

    content = BZL_TEMPLATE.format(
        project=project,
        repo=repo,
        header=HEADER,
        kind=display_kind,
        maybe_tests=" tests and tools" if internal else "",
        func_suffix="_".join(suffix_parts),
    )

    path_parts = MakeParts() + [kind, "{}.bzl".format(project)]
    path = os.path.join(*path_parts)
    with open(path, "w") as f:
        f.write(content)


def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]

    yaml.add_representer(str, str_presenter)

    parser = argparse.ArgumentParser(
        description="Bazel Federation CI Configuration Generation Script"
    )
    parser.add_argument(
        "--config_url",
        type=str,
        help="URL of the presubmit configuration that should act as template. "
        "If None, a default configuration will be used instead.",
    )
    parser.add_argument(
        "--project",
        type=str,
        help="Name of the project in the federation. "
        "This flag can be omitted if --config_url points to a file in the bazelbuild GitHub organisation "
        "and if the repository name of that config file should be used as project name.",
    )
    parser.add_argument(
        "--repo",
        type=str,
        help="Name of the remote repository. If empty, the project name is being used instead.",
    )

    args = parser.parse_args(argv)
    if not args.project and not args.config_url:
        utils.eprint("At least one of --project and --config_url must be set.")
        return 1

    try:
        project_name = args.project or get_project_name_from_url(args.config_url)
        repo = args.repo or project_name
        config = transform_config(project_name, repo, load_config(args.config_url))
        update_master_config(project_name)
        save_config_file("%s.yml" % project_name, config)

        create_bzl_file(project_name, repo, internal=False, kind="setup")
        create_bzl_file(project_name, repo, internal=True, kind="setup")
        create_bzl_file(project_name, repo, internal=True, kind="deps")
    except Exception as ex:
        utils.eprint("".join(traceback.format_exception(None, ex, ex.__traceback__)))
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())

