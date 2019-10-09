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

import subprocess
import sys


PRINT_COMMANDS = True
_SENTINEL = "meta_data_sentinel_value"


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
    process = execute_command(
        "buildkite-agent", "meta-data", "get", key, "--default", default
    )
    if process.returncode:
        raise ValueError("Failed to read meta data '{}': {}".format(key, process.stderr))

    value = process.stdout
    if value == _SENTINEL:
        raise ValueError("Missing meta data value for key '{}'".format(key))

    return value


def set_meta_data(key, value):
    process = execute_command(
        "buildkite-agent", "meta-data", "set", key, value
    )
    if process.returncode:
        raise ValueError("Failed to write meta data '{}': {}".format(key, process.stderr))

    return process.stdout


def upload_file(path):
    process = execute_command("buildkite-agent", "artifact", "upload", path)
    if process.returncode:
        raise Exception("Failed to upload {}: {}".format(path, process.stderr))
