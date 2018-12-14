# Bazel Federation

Experimental: do not depend on it.


This repository contains examples of use of a few Bazel rules.

## Goals

This repository will contain examples and tests for the most important Bazel
rules. This allows us to ensure that all recommended rules work well together.

At the same time, it provides information to users. If a project uses both Scala
and Haskell rules, it can know which versions of the rules were tested together
and work well with a specific version of Bazel. We hope this will help users
update their dependencies when they upgrade Bazel.

This repository is also a way for the Bazel team to monitor incompatible changes
to recommended rules. If changes are needed to keep the examples working, we may
push back and suggest a change to the rule; or the diff will serve as an example
for anyone updating their code.

