# rules_doxygen

Bazel rules for running doxygen.

## Install

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_doxygen",
    # See release page for latest version url and sha.
)

load("@rules_doxygen//:repo.bzl","doxygen_repository")

doxygen_repository(name = "doxygen")
```

## Usage

Build `Doxyfile` through doxygen.

```sh
bazel build @doxygen//:doxygen -s -g Doxyfile
```

Adjust the settings in your Doxygen configuration file `Doxyfile`.Then run doxygen through bazel.


```sh
bazel run @doxygen//:doxygen Doxyfile
```
