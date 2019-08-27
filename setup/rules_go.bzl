load("@io_bazel_rules_go//go:def.bzl", "go_rules_dependencies", "go_register_toolchains")
load("@io_bazel_rules_go//go/private:nogo.bzl", "DEFAULT_NOGO", "go_register_nogo")

def rules_go_setup():
  go_rules_dependencies()
  go_register_toolchains()
  go_register_nogo(name = "io_bazel_rules_nogo", nogo = DEFAULT_NOGO)
