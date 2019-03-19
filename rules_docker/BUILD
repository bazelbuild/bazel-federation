load("@io_bazel_rules_docker//container:container.bzl", "container_image")

exports_files(glob(["*.yaml"]))

container_image(
    name = "basic_alpine",
    base = "@alpine_linux_amd64//image",
    cmd = ["Hello World!"],
    entrypoint = ["echo"],
)

# Tests

load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")

container_test(
    name = "basic_alpine_bazel_test",
    configs = [":basic_alpine.yaml"],
    image = ":basic_alpine",
)
