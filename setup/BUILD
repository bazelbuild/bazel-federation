load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

exports_files(glob(["*.bzl"]))

filegroup(
    name = "standard_package",
    srcs = glob([
        "BUILD",
        "*.bzl",
    ]),
    visibility = ["@//distro:__pkg__"],
)

bzl_library(
    name = "bazel_skylib",
    srcs = ["bazel_skylib.bzl"],
    visibility = ["//visibility:public"],
    deps = ["@bazel_skylib//:workspace"],
)

bzl_library(
    name = "bazel_stardoc",
    srcs = ["bazel_stardoc.bzl"],
    visibility = ["//visibility:public"],
    deps = ["@bazel_federation//setup:rules_java"],
)

bzl_library(
    name = "rules_go",
    srcs = ["rules_go.bzl"],
    visibility = ["//visibility:public"],
    deps = [
        "@bazel_federation//setup:bazel_skylib",
        "@io_bazel_rules_go//go:deps",
    ],
)

bzl_library(
    name = "rules_java",
    srcs = ["rules_java.bzl"],
    visibility = ["//visibility:public"],
    deps = ["@rules_java//java:repositories"],
)

bzl_library(
    name = "rules_python",
    srcs = ["rules_python.bzl"],
    visibility = ["//visibility:public"],
    deps = ["@rules_python//python:pip"],
)

bzl_library(
    name = "rules_rust",
    srcs = ["rules_rust.bzl"],
    visibility = ["//visibility:public"],
    deps = [
        "@io_bazel_rules_rust//:workspace",
        "@io_bazel_rules_rust//rust:repositories",
    ],
)

bzl_library(
    name = "rules_cc",
    srcs = ["rules_cc.bzl"],
    visibility = ["//visibility:public"],
)

bzl_library(
    name = "rules_pkg",
    srcs = ["rules_pkg.bzl"],
    visibility = ["//visibility:public"],
)
