load("@bazel_federation//setup:bazel_skylib.bzl", "bazel_skylib_setup")
load("@bazel_federation//:tools.bzl", "assert_unmodified_repositories")
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

def rules_go_setup():
    bazel_skylib_setup()

    # Prevent rules_go from bringing in any new http_archive / git_repository dependencies.
    # Ideally we'd refactor go_rules_dependencies() by splitting it into two methods, with one of them executing the code that we actually need here.
    snapshot = native.existing_rules()
    go_rules_dependencies()
    assert_unmodified_repositories(snapshot)
    
    go_register_toolchains()
