
workspace(
    name = "rules_buf",
)

load(
    "//buf:repos.bzl",
    "buf_repositories",
)

buf_repositories()

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
rules_proto_dependencies()
rules_proto_toolchains()
