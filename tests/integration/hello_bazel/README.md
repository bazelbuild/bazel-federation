# Hello world in all the languages


## Things to try

```
bazel build :*
bazel run :hello_in_c
bazel run :HelloinJava
bazel run :hello_in_python
bazel build :tarball
tar tvf ../bazel-bin/hello_bazel/tarball.tar
```

The tarball content should be

```
drwxr-xr-x 0/0               0 1999-12-31 19:00 ./
drwxr-xr-x 0/0               0 1999-12-31 19:00 ./federation/
drwxr-xr-x 0/0               0 1999-12-31 19:00 ./federation/sample/
drwxr-xr-x 0/0               0 1999-12-31 19:00 ./federation/sample/hello_bazel/
-r-xr-xr-x 0/0            1435 1999-12-31 19:00 ./federation/sample/hello_bazel/BUILD
-r-xr-xr-x 0/0             198 1999-12-31 19:00 ./federation/sample/hello_bazel/Hello.java
-r-xr-xr-x 0/0              93 1999-12-31 19:00 ./federation/sample/hello_bazel/HelloLib.java
-r-xr-xr-x 0/0             142 1999-12-31 19:00 ./federation/sample/hello_bazel/hello.cc
-r-xr-xr-x 0/0             132 1999-12-31 19:00 ./federation/sample/hello_bazel/hello.py
-r-xr-xr-x 0/0              95 1999-12-31 19:00 ./federation/sample/hello_bazel/hello_lib.cc
-r-xr-xr-x 0/0              50 1999-12-31 19:00 ./federation/sample/hello_bazel/hello_lib.h
-r-xr-xr-x 0/0             653 1999-12-31 19:00 ./federation/sample/hello_bazel/my_rule.bzl
-r-xr-xr-x 0/0             143 1999-12-31 19:00 ./federation/sample/BUILD
-r-xr-xr-x 0/0            1098 1999-12-31 19:00 ./federation/sample/WORKSPACE
```
