workspace(name = "bazel_federation")

load("@bazel_federation//:repositories.bzl", "rules_pkg")
rules_pkg()
load("@bazel_federation//setup:rules_pkg.bzl", "rules_pkg_setup")
rules_pkg_setup()

load("@bazel_federation//:repositories.bzl", "rules_python")
rules_python()
load("@bazel_federation//setup:rules_python.bzl", "rules_python_setup")
rules_python_setup()
