
load(
    "@bazel_tools//tools/build_defs/repo:utils.bzl",
    "maybe"
)

load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
    "http_file",
)


def _buf_repositories():
    """Defines `WORKSPACE` repositories for Buf."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
    )
    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "e589e39ef46fb2b3b476b3ca355bd324e5984cbdfac19f0e1625f0042e99c276",
        strip_prefix = "protobuf-fde7cf7358ec7cd69e8db9be4f1fa6a5c431386a",
        url = "https://github.com/google/protobuf/archive/fde7cf7358ec7cd69e8db9be4f1fa6a5c431386a.tar.gz",
    )
    maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "d8992e6eeec276d49f1d4e63cfa05bbed6d4a26cfe6ca63c972827a0d141ea3b",
        strip_prefix = "rules_proto-cfdc2fa31879c0aebe31ce7702b1a9c8a4be02d2",
        url = "https://github.com/bazelbuild/rules_proto/archive/cfdc2fa31879c0aebe31ce7702b1a9c8a4be02d2.tar.gz",
    )
    maybe(
        http_file,
        name = "buf_darwin",
        downloaded_file_path = "buf_darwin.bin",
        sha256 = "0bba90cb07dd76626de9125b5ec09edfd52cc669ba124d6d154a36373bb35369",
        urls = ["https://github.com/bufbuild/buf/releases/download/v0.35.1/buf-Darwin-x86_64"],
        executable = True,
    )
    maybe(
        http_file,
        name = "buf_linux",
        sha256 = "b1986b786890562149cb1f341b1a089c80439844ca65391161397a8b0b9352a8",
        downloaded_file_path = "buf_linux.bin",
        urls = ["https://github.com/bufbuild/buf/releases/download/v0.35.1/buf-Linux-x86_64"],
        executable = True,
    )


## Exports
buf_repositories = _buf_repositories
