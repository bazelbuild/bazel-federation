# Bazel Federation - How to integrate rules

This is a guide for rule authors. It describes the steps needed to have your
rules play properly in the Bazel Federation. The general pattern is

1.  Consider the dependencies your user will need to *use* your rules vs. those
    need to build, test and distribute your rules.
1.  Verify that the versions of your dependencies do not conflict with the
    federation.
1.  Provide tagged releases for your rules rather than github commits
1.  Add the configuration needed to make your rules part of the federation.

## Bring your dependencies up to date

**Critical point**: The Federation solves the diamond dependency problem in a
blunt, but effective way - the Federation gets to pick a single version of each
repo for canonically named rules.

What does that really mean?

Every rule set has a canonical name. For example,
[bazel-skylib](https://github.com/bazelbuild/bazel-skylib) is known as
`bazel_skylib`. Its documentation talks about `bazel_skylib`. It might reference
that name from within its own rules. Your transitive dependencies will probably
reference it by that name.

**When at all possible, use the canoncial name for a repo and take the version
that the Federation provides.**

If you really need to pin to a version, you may do that, but you will have to
load that repo under a different name and refer to it that way (e.g.
`@rules_mine_bazel_skylib`). If you can't make that work, then you'll have to
work with the other rule owners to eventually come up with a common release you
can all use.

Note that this only applies to repos that your users will need to use your
rules. Your own WORKSPACE file may include whatever it wants for the purposes of
stress testing your rules and building your distribution. For example, we
recommend using [stardoc](https://github.com/bazelbuild/stardoc) to generate
your documentation and [rules_pkg](https://github.com/bazelbuild/rules_pkg) to
create distribution archives, but you should structure your deps() functions so
those are not needed by your users.

The recommended task at this point is to update all of your dependency versions
to the versions used in the Federation release you are trying to integrate into.
If everything works, great. If not, you'll have to resolve that:

-   maybe pin (and rename) that repo
-   maybe change your code to be compatible with the Federation release.
-   maybe untangle and remove dependencies that are not actually needed by your
    users.

## Start doing the work needed to make releases

**Critical point**: The Federation strongly prefers release artifacts. It will
never point to a github repo at HEAD.

There are a few reasons for this: - releases tagge by version provide much more
context to your users and the people maintaining the Federation. - No
strip_prefix. - You can get download stats from github for release artifacts.
You can not get that for commit based downloads. Tracking downloads by version
will allow you to see that your users are migrating (or not) from older releases
to new ones.

For an example of minimal release packaging, you might follow what `rules_pkg`
does. The tarball is simply a
[target to be built](https://github.com/bazelbuild/rules_pkg/blob/master/pkg/distro/BUILD).
and the release page
[looks like this](https://github.com/bazelbuild/rules_pkg/releases)

## Add your repo to the Federation

This involes 3 steps

1.  Updating repositories.bzl
1.  Creating setup/*rules_mine*.bzl
1.  Adding tests

The end result is that someone who wants to use your rules will have a
`WORKSPACE` file that looks like

```
workspace(name = "my_project")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_repository(name = "bazel_federation", urls = [...], ...)

load("@bazel_federation//:repositories.bzl",
     "bazel_skylib"
)

bazel_skylib()
load("@bazel_federation//setup:bazel_skylib.bzl", "bazel_skylib_setup")
bazel_skylib_setup()
```

The methods provide all follow a common naming pattern for ease of use.

*NOTE: In the future, we will be trying to eliminate the need to call the
`_setup()` methods.*

### Updating repositories.bzl

All of the top level components of the Federation are listed in
[repositories.bzl](https://github.com/bazelbuild/bazel-federation/blob/master/repositories.bzl)

We will use the stanza for `bazel_skylib` as an example.

```
def bazel_skylib_deps():
    pass

def bazel_skylib():
    bazel_skylib_deps()
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/0.9.0/bazel_skylib-0.9.0.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/0.9.0/bazel_skylib-0.9.0.tar.gz",
        ],
        sha256 = "1dde365491125a3db70731e25658dfdd3bc5dbdfd11b840b3e987ecf043c7ca0",
    )
```

Each rule set has a macro that is simply the canoncial name for the rules. It
begins with a call to a `{rule}`_deps() method, which is also in this file. If
you depend on other top level components of the Federation, you should call the
existing deps methods from your deps() method.

**Critical point**: These methods always conditionally load repos. If a user
does not call your top level method, they will never bring in your repo. If a
user add their own repository rule to bring in some deeply nested dependency
before calling any Federation methods, we will use their preferred version.

### Create the setup methods

The setup method is a bit of glue that lets the user load your dependencies
using a method name they can predict from pattern. Example:

```
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

def bazel_skylib_setup():
    bazel_skylib_workspace()
```

This calls back to bazel_skylib (or your rules) to load the previously defined
external deps method. In this method you may

-   Bring in more transitive deps. You should alway guard that with `maybe()`.
-   Register any toolchains.

### Adding tests

At a minimum, you must add yourself to the
[integration tests](https://github.com/bazelbuild/bazel-federation/tree/master/tests/integration).

-   Add your repository setup to the `WORKSPACE` file file there
-   Add an example which uses your rules
-   If you are providing a language toolchain, then add that directly to the
    ["hello bazel"](https://github.com/bazelbuild/bazel-federation/tree/master/tests/integration/hello_bazel)
    example.

The next step is to make sure there is test coverage on CI.

TODO(fweikert): Add instructions for editing the .yaml files.
