load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library", "go_test")

go_library(
    name = "lib",
    srcs = ["lib.go"],
    importpath = "github.com/laurentlb/bazel-federation/lib",
)

go_binary(
    name = "hello",
    srcs = ["main.go"],
    deps = [":lib"],
)

go_test(
    name = "lib_test",
    srcs = ["lib_test.go"],
    deps = [":lib"],
)
