# Bazel Federation

**Status:** Experimental, unmaintained and archived. Development of this project
is on hold while we figure out how a bazel-federation should look like in the
new Bazel LTS world. For a related project see the [bzlmod design doc](https://docs.google.com/document/d/1moQfNcEIttsk6vYanNKIy3ZuK53hQUFq1b1r0rmsYVg/edit?usp=sharing).

The Bazel Federation is a set of rules at versions that have been tested
together to ensure interoperability.

## Goals

This repository will contain examples and tests for the most important Bazel
rules. This allows us to ensure that all recommended rules work well together.

At the same time, it provides information to users. If a project uses both Scala
and Haskell rules, it can know which versions of the rules were tested together
and work well with a specific version of Bazel. We hope this will help users
update their dependencies when they upgrade Bazel.

This repository is also a way for the Bazel team to monitor incompatible changes
to recommended rules. If changes are needed to keep the examples working, we may
push back and suggest a change to the rule; or the diff will serve as an example
for anyone updating their code.

## Example WORKSPACE

Load the federation first

```starlark
workspace(name = "my_project")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "bazel_federation",
    url = "https://github.com/bazelbuild/bazel-federation/archive/130c84ec6d60f31b711400e8445a8d0d4a2b5de8.zip",
    sha256 = "9d4fdf7cc533af0b50f7dd8e58bea85df3b4454b7ae00056d7090eb98e3515cc",
    strip_prefix = "bazel-federation-130c84ec6d60f31b711400e8445a8d0d4a2b5de8",
    type = "zip",
)
```

If you want to pin specific versions of some rule sets, you may do that here.
For example, we are using a specific commit of skylib.

```starlark
http_archive(
    name = "bazel_skylib",
    url = "https://github.com/bazelbuild/bazel-skylib/archive/f130d7c388e6beeb77309ba4e421c8f783b91739.zip",
    sha256 = "8eb5bce85cddd2f4e5232c94e57799de62b1671ce4f79f0f83e10e2d3b2e7986",
    strip_prefix = "bazel-skylib-f130d7c388e6beeb77309ba4e421c8f783b91739",
    type = "zip",
)
```

Now load the initializer methods for all the rules you want to use.

```starlark
load("@bazel_federation//:repositories.bzl",
     "bazel_stardoc",
     "rules_cc",
     "rules_java",
     "rules_pkg",
     "rules_python",
)
```

For each rule set, follow this pattern

-   *rule name*()
-   load("@bazel_federation//setup:*rule_name*.bzl", "*rule_name*_setup")
-   *rule_name*_setup()

The setup method will bring in any dependencies needed for the rules and do any
toolchain setup

```starlark
rules_cc()
load("@bazel_federation//setup:rules_cc.bzl", "rules_cc_setup")
rules_cc_setup()

rules_java()
load("@bazel_federation//setup:rules_java.bzl", "rules_java_setup")
rules_java_setup()

rules_python()
load("@bazel_federation//setup:rules_python.bzl", "rules_python_setup")
rules_python_setup()

rules_pkg()
load("@bazel_federation//setup:rules_pkg.bzl", "rules_pkg_setup")
rules_pkg_setup()

bazel_stardoc()
load("@bazel_federation//setup:bazel_stardoc.bzl", "bazel_stardoc_setup")
bazel_stardoc_setup()
```

## Federation testing on Bazel CI

[![Build status](https://badge.buildkite.com/9305b2e2ab7f186b3d596baee5e72aabb7274ff9fc28e54251.svg?branch=master)](https://buildkite.com/bazel/bazel-federation)

We test pull requests on Bazel CI: A CI build runs all tests for each member project and builds several example projects from this repository.
Moreover, the federation gets tested with upcoming incompatible Bazel flags as part of the [downstream pipeline](https://buildkite.com/bazel/bazelisk-plus-incompatible-flags).

The CI configuration for each member project is based on their regular presubmit CI configuration, but we had to disable some targets that could not be tested remotely. Please see the individual CI configuration files in the `.bazelci` directory for details.

## More information

[Documentation](https://bazelbuild.github.io/bazel-federation/)
