load("@io_bazel_rules_rust//:workspace.bzl", "bazel_version")
load("@io_bazel_rules_rust//rust:repositories.bzl", "rust_repositories")

def rules_rust_setup():
    rust_repositories()
    bazel_version(name = "bazel_version")
