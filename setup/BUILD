exports_files(glob(["*.bzl"]))

filegroup(
    name = "standard_package",
    srcs = glob(["BUILD", "*.bzl"]),
    visibility = ["@//distro:__pkg__"],
)
