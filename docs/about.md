# Bazel Federation - About

The Bazel Federation is a set of rules at versions that have been tested
together to ensure interoperability.

*NOTE: This document is a work in progress. It is very much incomplete.*

## TL;DR;

-   A Federation release is a promise that we tested a specific Bazel version
    along with a set of rules at their specific versions. It is little more than
    a set of workspace methods that gets you that tested set.
-   There will be a Federation track for each long term support Bazel track. You
    might stick with the Federation that includes Bazel 1.0.0 for a year or
    more.
    -   As rules add features which back port to older Bazel, there can be
        Federation patch releases for that track.
    -   If rules evolve to require newer versions of Bazel, they will only be
        included in Federation releases tracking the newer Bazel releases.

## What is a Federation release?

The most obvious goal of the Federation is give users greater assurance that a
set of rules works with a particular Bazel release. We give that assurance by
integration testing them against each other. We encourage integration tests that
span rule sets. This is especially important as the number of interdependencies
of rules grow.

An equally important goal is that if a user adopts a Federation version today,
_they can continue to use it for an extended period of time_. This does not mean
that Bazel (or rules) can never have backwards incompatible changes. It means
that the Federation is a mechanism to allow a user to continue to use an older
version of Bazel along with rules that are being updated. It would be
unreasonable to insist that all rules remain backwards compatible with all
previous Bazel versions - that is just too much work. Instead, a Federation
around an older version of Bazel can be updated to include new versions of some
rules, as long as the basic promise that all the rules  in the Federation work
together is kept.

This implies a freedom that Bazel maintainers and rule creators should have.
They may update their rules in ways totally incompatible with earlier versions
of Bazel. If users want to make use of those new features, they will have to
update to a new Federation release that includes the updated rule(s). While this
may sound like any Bazel release can break arbitrary things it is significantly
different.

-   There are update paths from old Bazel versions to newer rules providing they
    interoperate in an old Federation version
-   When you need a new rule capability that depends on a breaking change in
    Bazel, the Federation release for that Bazel version is guidance about all
    the rules which must be updated. Users are not left on their own to
    determine what interoperates. This is the most important user facing
    promise. It allows you to scope the effort to update rather than do it by
    trial and error.

While it seems that we have granted rule owners the right to never look at
backwards compatibility, we want to aim for the best user experience. Rule
owners should have some commitments to the community:

-   as they add new backwards compatible features they should update older
    federation versions to include their new rule.
-   if they create breaking changes, they must work with downstream rules to
    make sure they interoperate in the upcoming Federation releases.

## Some principles

-   The idea of downloading rules at head is strongly unrecommended. Federation
    releases will only point to explicit rule releases.
-   Rule authors are not obliged to keep their rules working with older versions
    of Bazel.

## Things to read.

-   [Example of how multiple Federation releases co-exist as Bazel and rules
    evolve](https://docs.google.com/spreadsheets/d/1JOqCREzfctH_ITO8Cl4rDHEWI9ylR6FgUksMpDhZeDI/edit#gid=0)
