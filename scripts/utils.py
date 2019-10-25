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

import os
import subprocess
import sys


PRINT_COMMANDS = True
_SENTINEL = "meta_data_sentinel_value"


def calculate_paths(root_file):
    script_path = os.path.abspath(__file__)
    current_dir = os.path.dirname(script_path)
    script_dirs = []

    while True:
        file_path = os.path.join(current_dir, root_file)
        if os.path.exists(file_path):
            script_base_path = os.path.join(*script_dirs) if script_dirs else ""
            return current_dir, script_base_path

        parent_dir, part = os.path.split(current_dir)
        if not parent_dir or parent_dir == current_dir:
            raise Exception(
                "Unable to find a parent directory of {} that contains {}".format(
                    script_path, root_file
                )
            )

        script_dirs.insert(0, part)
        current_dir = parent_dir


REPO_ROOT, _SCRIPT_BASE = calculate_paths("repositories.bzl")


def get_script_path(filename):
    """Returns the path of the given script, relative to the repo root."""
    # os.path.join ignores empty _SCRIPT_BASE values
    return os.path.join(_SCRIPT_BASE, filename)


def eprint(msg):
    """Print to stderr and flush (just in case)."""
    print(msg, flush=True, file=sys.stderr)


def print_group(name, collapsed=True):
    sign = "-" if collapsed else "+"
    eprint("\n\n{} {}\n\n".format(sign * 3, name))


def execute_command(*args):
    if PRINT_COMMANDS:
        eprint(" ".join(args))

    process = subprocess.run(
        args, check=False, stdout=subprocess.PIPE, errors="replace", universal_newlines=True
    )

    return process


def get_meta_data(key, default=_SENTINEL):
    process = execute_command("buildkite-agent", "meta-data", "get", key, "--default", default)
    if process.returncode:
        raise ValueError("Failed to read meta data '{}': {}".format(key, process.stderr))

    value = process.stdout
    if value == _SENTINEL:
        raise ValueError("Missing meta data value for key '{}'".format(key))

    return value


def set_meta_data(key, value):
    process = execute_command("buildkite-agent", "meta-data", "set", key, value)
    if process.returncode:
        raise ValueError("Failed to write meta data '{}': {}".format(key, process.stderr))

    return process.stdout


def upload_file(path):
    # Don't upload from `path` directly since Buildkite will keep the long path
    # as part of the artifact name.
    cwd = os.getcwd()
    dirname, basename = os.path.split(os.path.abspath(path))
    os.chdir(dirname)

    try:
        process = execute_command("buildkite-agent", "artifact", "upload", basename)
        if process.returncode:
            raise Exception("Failed to upload {}: {}".format(path, process.stderr))
    finally:
        os.chdir(cwd)
    
    return basename
