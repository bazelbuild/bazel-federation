load("@bazel_federation//setup:bazel_skylib.bzl", "bazel_skylib_setup")
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

def rules_go_setup():
    bazel_skylib_setup()
    go_rules_dependencies()
    go_register_toolchains()
