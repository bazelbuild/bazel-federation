load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

filegroup(
    name = "standard_package",
    srcs = glob([
        "BUILD",
        "LICENSE",
        "*.bzl",
        "third_party/**",
    ]),
    visibility = ["@//distro:__pkg__"],
)

bzl_library(
    name = "java_repositories",
    srcs = ["java_repositories.bzl"],
    visibility = ["//visibility:public"],
    # Temporarily omit @bazel_tools//... bzl files from the bzl_library until
    # they are `exports_files`'d in a released version of Bazel.
    deps = [
        #"@bazel_tools//tools/build_defs/repo:http.bzl",
        #"@bazel_tools//tools/build_defs/repo:utils.bzl",
    ],  # keep
)

bzl_library(
    name = "repositories",
    srcs = ["repositories.bzl"],
    visibility = ["//visibility:public"],
    # Temporarily omit @bazel_tools//... bzl files from the bzl_library until
    # they are `exports_files`'d in a released version of Bazel.
    deps = [
        ":third_party_repositories",
        #"@bazel_tools//tools/build_defs/repo:git.bzl",
        #"@bazel_tools//tools/build_defs/repo:http.bzl",
        #"@bazel_tools//tools/build_defs/repo:utils.bzl",
    ],  # keep
)

bzl_library(
    name = "third_party_repositories",
    srcs = ["third_party_repositories.bzl"],
    visibility = ["//visibility:public"],
    # Temporarily omit @bazel_tools//... bzl files from the bzl_library until
    # they are `exports_files`'d in a released version of Bazel.
    deps = [
        #"@bazel_tools//tools/build_defs/repo:git.bzl",
        #"@bazel_tools//tools/build_defs/repo:http.bzl",
        #"@bazel_tools//tools/build_defs/repo:utils.bzl",
    ],  # keep
)

bzl_library(
    name = "version",
    srcs = ["version.bzl"],
    visibility = ["//visibility:public"],
)
