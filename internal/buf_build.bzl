

def _buf_image_impl(ctx,
                    name = None,
                    protos = None,
                    config = None,
                    out = None,
                    mount_paths = False,
                    mount_protos = False,
                    extra_args = [],
                    compiler = None):
    """Implementation of the `buf_image` rule."""
    
    name = name or ctx.attr.name
    out = out or ctx.outputs.out
    protos = protos or ctx.attr.protos
    config = config or ctx.file.config
    mount_paths = mount_paths or ctx.attr.mount_paths
    mount_protos = mount_protos or ctx.attr.mount_protos
    extra_args = extra_args or ctx.attr.extra_args
    compiler = compiler or ctx.attr._compiler

    args = ctx.actions.args()
    for arg in extra_args:
        args.add(arg)

    args.add("build")
    args.add("--config=%s" % config.path)
    args.add("--output=%s" % out.path)

    inputs = [config]
    proto_roots = []
    proto_srcs = []
    for dep in protos:
        for src in dep[ProtoInfo].transitive_sources.to_list():
            if "descriptor.proto" in src.path:
                continue
            if src not in proto_srcs:
                inputs.append(src)
                proto_srcs.append(src)
                if mount_protos:
                    args.add("--path=%s" % src.path)
        if mount_paths:
            for root in dep[ProtoInfo].transitive_proto_path.to_list():
                if root != "." and root not in proto_roots:
                    proto_roots.append(root)
                    args.add("--path=%s" % root)

    ctx.actions.run(
        outputs = [out],
        inputs = inputs,
        mnemonic = "BufBuild",
        arguments = [args],
        use_default_shell_env = True,
        progress_message = "Building %d proto file(s) via Buf" % len(ctx.attr.protos),
        tools = [ctx.executable._compiler],
        executable = ctx.executable._compiler,
    )
    return [DefaultInfo(files = depset([
        out,
    ]))]


buf_image = rule(
    implementation = _buf_image_impl,
    doc = "Builds a Buf image of the provided protocol buffers, in JSON or binary.",
    attrs = {
        "config": attr.label(
            mandatory = True,
            allow_single_file = [".yaml"],
        ),
        "out": attr.output(
            mandatory = True,
        ),
        "protos": attr.label_list(
            mandatory = True,
            allow_files = False,
            providers = [ProtoInfo],
        ),
        "extra_args": attr.string_list(),
        "mount_paths": attr.bool(
            default = False,
        ),
        "mount_protos": attr.bool(
            default = False,
        ),
        "_compiler": attr.label(
            default = Label("@rules_buf//internal/tools:buf"),
            executable = True,
            cfg = "exec",
        ),
    },
)
