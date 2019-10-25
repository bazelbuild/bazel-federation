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

def define_bind(actual):
    return {
        "type": "bind",
        "bind": "@{}".format(actual),
        "dependencies": [actual],
    }


def define_forward(actual):
    return {
        "type": "forward",
        "dependencies": [actual],
    }


def define_git_repository(remote, commit, deps=[]):
    return {
        "type": "git_repository",
        "git_repository": {
            "remote": remote,
            "commit": commit,
        },
        "dependencies": deps,
    }


def define_http_archive(sha256, urls, strip_prefix=None, deps=[]):
    http_archive = {
        "sha256": sha256,
        "urls": urls,
    }
    if strip_prefix is not None:
        http_archive["strip_prefix"] = strip_prefix
    return {
        "type": "http_archive",
        "http_archive": http_archive,
        "dependencies": deps,
    }


def define_load(label, symbol):
    return {
        "type": "load",
        "load": {
            "label": label,
            "symbol": symbol,
        },
        "dependencies": [],
    }
