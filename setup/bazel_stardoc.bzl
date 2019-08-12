# Stardoc does not have any of its own setup, but we do have to make
# sure we run the setup for all our dependencies.
load("@bazel_federation//setup:rules_java.bzl", "rules_java_setup")

def bazel_stardoc_setup():
    rules_java_setup()
