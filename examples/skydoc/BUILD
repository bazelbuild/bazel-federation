load("@bazel_skylib//:bzl_library.bzl", "bzl_library")
load("@io_bazel_skydoc//stardoc:stardoc.bzl", "stardoc")
load(":my_rule.bzl", "my_rule")

package(default_visibility = ["//visibility:private"])

bzl_library(
    name = "my_rule",
    srcs = [
        "my_rule.bzl",
    ],
    visibility = ["//visibility:public"],
)

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
