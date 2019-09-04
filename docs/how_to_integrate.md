# Bazel Federation - How to integrate rules

*TBD*

## Basic Integration

-   Updating repositories.bzl
    -   Layering you dependencies.
-   Creating setup/*rules_mine*.bzl
    -   Bringing in more dependencies
    -   Registring toolchains
-   Adding tests
    -   Unit tests
    -   Integration tests

## Advanced Topics

### Pinning a depedency

If you must pin a dependency to a particular version, you may not call it by the
canonical name. You *must* give it a private name (e.g.
@rules_mine_bazel_skylib).
