
## `rules_buf` - Rules for [buf.build](https://buf.build)
This repo provides Bazel rules for the Buf system. This is an unofficial package which is simply good at downloading Buf, mounting your protos and a `buf.yaml` file, and running the tool for you.

To learn more about Buf, take a look at their [docs](https://docs.buf.build).

### Using the package
Follow the directions below to get started.

**In your `WORKSPACE`:**
```starlark
load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)

http_archive(
    name = "rules_buf",
    sha256 = "<see_releases_for_sha256>",
    strip_prefix = "rules_buf-<commit_or_release>",
    url = "https://github.com/sgammon/rules_buf/archive/<commit_or_release>",
)

load(
    "@rules_buf//buf:repos.bzl",
    "buf_repositories",
)

buf_repositories()
```

**In your `BUILD.bazel`:**
```starlark
load(
    "@rules_proto//proto:defs.bzl",
    "proto_library"
)

load(
    "@rules_buf//buf:defs.bzl",
    "buf_image",
)


## Your protos
proto_library(
    name = "some-proto",
    srcs = [
        "SomeProto.proto",
    ],
)

proto_library(
    name = "another-proto",
    srcs = [
        "AnotherProto.proto",
    ],
    deps = [
        ":some-proto",
    ],
)


## Buf image gathers all transitive deps (so this will include both)
buf_image(
    name = "buf",
    config = "buf.yaml",
    out = "model.buf.bin",
    protos = [
      ":another-proto",
    ],
)
```

**Note:** By setting the output to `*.bin`, you'll get a binary file. If you set the `out` to `.json`, you'll get a JSON file.

If you want to pass extra args, you can do so with `extra_args`.

**In `buf.yaml`:**
```yaml
version: v1beta1
build:
  roots:
    - .
lint:
  use:
    - BASIC
    - FILE_LOWER_SNAKE_CASE
  except:
    - ENUM_NO_ALLOW_ALIAS
    - IMPORT_NO_PUBLIC
    - PACKAGE_AFFINITY
    - PACKAGE_DIRECTORY_MATCH
    - PACKAGE_SAME_DIRECTORY
breaking:
  use:
    - WIRE_JSON
```

Of course, you should put whatever lint settings make sense for your use case in `buf.yaml`.

#### Extracting outputs
Coming soon.
