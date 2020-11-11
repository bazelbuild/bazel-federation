load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

bzl_library(
    name = "bazel_skylib",
    srcs = ["bazel_skylib.bzl"],
    visibility = ["//:__subpackages__"],
    deps = ["@bazel_skylib//:internal_setup"],
)

bzl_library(
    name = "rules_cc",
    srcs = ["rules_cc.bzl"],
    visibility = ["//:__subpackages__"],
    deps = ["@rules_cc//:internal_setup"],
)

bzl_library(
    name = "rules_java",
    srcs = ["rules_java.bzl"],
    visibility = ["//:__subpackages__"],
    deps = ["@rules_java//:internal_setup"],
)

bzl_library(
    name = "rules_python",
    srcs = ["rules_python.bzl"],
    visibility = ["//:__subpackages__"],
    deps = ["@rules_python//:internal_setup"],
)
