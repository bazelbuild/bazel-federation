load("@bazel_skylib//:bzl_library.bzl", "bzl_library")
load("@io_bazel_skydoc//stardoc:stardoc.bzl", "stardoc")
load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library", "go_test")
load("@io_bazel_rules_rust//rust:rust.bzl", "rust_library", "rust_binary", "rust_test")
load("@rules_cc//cc:defs.bzl", "cc_library", "cc_binary")
load("@rules_java//java:defs.bzl", "java_library", "java_binary")
load("@rules_python//python:defs.bzl", "py_binary")
load("@rules_pkg//:pkg.bzl", "pkg_tar")
load(":my_rule.bzl", "my_rule")

stardoc(
    name = "my_rule_doc",
    out = "my_rule_doc.md",
    input = ":my_rule.bzl",
    symbol_names = [
        "my_rule",
    ],
    deps = [":my_rule"],
)

my_rule(
    name = "example",
    deps = [
        ":BUILD",
        ":my_rule.bzl",
    ],
    out = "example.txt",
)

# A C++ program

cc_binary(
    name = "hello_in_c",
    srcs = ["hello.cc"],
    deps = [":hello_lib_c"],
)

cc_library(
    name = "hello_lib_c",
    srcs = ["hello_lib.cc"],
    hdrs = ["hello_lib.h"],
)

go_library(
    name = "lib",
    srcs = ["lib.go"],
    importpath = "github.com/bazelbuild/bazel-federation/examples/go/lib",
)

go_binary(
    name = "hello_in_go",
    srcs = ["main.go"],
    deps = [":lib"],
)

go_test(
    name = "lib_test",
    srcs = ["lib_test.go"],
    deps = [":lib"],
)

java_binary(
    name = "HelloInJava",
    srcs = ["Hello.java"],
    deps = [":hello_lib_java"],
    main_class = "example.Hello",
)

java_library(
    name = "hello_lib_java",
    srcs = ["HelloLib.java"],
)

py_binary(
    name = "hello_in_python",
    srcs = ["hello.py"],
    main = "hello.py",
)

rust_library(
    name = "rust_lib",
    srcs = ["lib.rs"],
)

rust_binary(
    name = "hello_in_rust",
    srcs = ["main.rs"],
    deps = [":rust_lib"],
)

rust_test(
    name = "rust_lib_test",
    srcs = ["rust_lib_test.rs"],
    deps = [":rust_lib"],
)

pkg_tar(
    name = "tarball",
    srcs = glob(["**"]) + [
        "//:srcs",
        ":hello_in_c",
        ":HelloInJava",
        ":hello_in_go",
        ":hello_in_python",
        ":hello_in_rust",
    ],
    strip_prefix = "/",
    package_dir = "federation/sample",
)

bzl_library(
    name = "my_rule",
    srcs = ["my_rule.bzl"],
    visibility = ["//visibility:public"],
)
