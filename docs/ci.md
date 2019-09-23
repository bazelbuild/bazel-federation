# Bazel Federation - How we use CI to gate PR and releases

*NOTE: This document is a work in progress. It is very much incomplete.*

## TL;DR;

For non-incompatible flag flip realeases

-   There is a Federation major version track for every incompatible flag flip
    bazel release.
-   We have a minor federation release every time we update a rule version
-   Minor version changes (semantically compatible) are allowed in a federation
    track
-   Major version chanages are only allowed at flag flip releasess.
-   Bazel RC candidates (N+1)rc have to test with the federation using bazel N.
    If CI fails, then we have to block the Bazel release, because we must have made an
    incompatible change by mistake. We do not block Bazel CI at post submit,
    because we may decide to fix forward.

For incompatible flag flip realeases

-   There will be a CI chain with Bazel + all the incompatible flags we intend
    to flip in the next major release
-   Breaking rules will not block any individual submit
-   We can only do the Federation release when there is a solution with all
    the rules passing. Bazel team and rule owners have to learn to work this
    out with reasonable speed.
