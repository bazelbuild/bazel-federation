load("@rules_python//python:pip.bzl", "pip_repositories")

def rules_python_setup(use_pip=True):
    if use_pip:
        pip_repositories()
