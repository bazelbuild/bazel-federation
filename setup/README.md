# Setup functions

These methods are used to configure rules after they are loaded.

They should all be of the form

setup/**REPO**_setup.bzl:

```
load("@REPO//:workspace.bzl", "some_setup_method")

def REPO_setup():
    some_setup_method()
```

Where:

-   `REPO` is the name of the repository
-   `some_setup_method` is the name the repository chose for their setup. We
    give it the name REPO_setup to provide a uniform pattern.
