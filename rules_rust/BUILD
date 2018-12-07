load("@io_bazel_rules_rust//rust:rust.bzl", "rust_library", "rust_binary", "rust_test")

rust_library(
    name = "lib",
    srcs = ["lib.rs"],
)

rust_binary(
    name = "hello_world",
    srcs = ["main.rs"],
    deps = [":lib"],
)

rust_test(
    name = "lib_test",
    srcs = ["lib_test.rs"],
    deps = [":lib"],
)
