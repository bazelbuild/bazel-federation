load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library", "scala_binary", "scala_test")

scala_binary(
    name = "ScalaBinary",
    srcs = ["ScalaBinary.scala"],
    main_class = "scalarules.test.ScalaBinary",
    deps = [":HelloLib"],
)

scala_library(
    name = "HelloLib",
    srcs = ["HelloLib.scala"],
)

scala_test(
    name = "HelloLibTest",
    srcs = ["HelloLibTest.scala"],
    deps = [":HelloLib"],
)
