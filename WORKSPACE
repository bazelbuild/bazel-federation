workspace(name = "bazel_federation")

load("@bazel_federation//:repositories.bzl", "rules_pkg")

rules_pkg()

load("@bazel_federation//setup:rules_pkg.bzl", "rules_pkg_setup")

rules_pkg_setup()

load("@bazel_federation//:repositories.bzl", "bazel_skylib")

bazel_skylib()

load("@bazel_federation//setup:bazel_skylib.bzl", "bazel_skylib_setup")

bazel_skylib_setup()
