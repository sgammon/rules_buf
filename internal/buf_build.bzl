

def _buf_image_impl(ctx,
                    name = None,
                    protos = None,
                    config = None,
                    out = None,
                    compiler = None):
    """Implementation of the `buf_image` rule."""
    
    name = name or ctx.attr.name
    out = out or ctx.outputs.out
    protos = protos or ctx.attr.protos
    config = config or ctx.file.config
    compiler = compiler or ctx.attr._compiler

    args = ctx.actions.args()
    args.add("--config=%s" % config.path)
    args.add("--output=%s" % out.path)

    inputs = [config]
    protoindex = []
    for dep in protos:
        if dep not in protoindex:
            for src in dep[ProtoInfo].transitive_sources.to_list():
                if src not in protoindex:
                    inputs.append(src)

    ctx.actions.run_shell(
        outputs = [out],
        inputs = inputs,
        mnemonic = "BufBuild",
        use_default_shell_env = True,
        progress_message = "Building %d proto file(s) via Buf" % len(ctx.attr.protos),
        tools = [ctx.executable._compiler],
        command = ctx.expand_location("{buf} build --config={config} --output={output}".format(
            buf = ctx.executable._compiler.path,
            config = config.path,
            output = out.path,
        )),
    )
    return [DefaultInfo(files = depset([out]))]


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
        "_compiler": attr.label(
            default = Label("@rules_buf//internal/tools:buf"),
            executable = True,
            cfg = "exec",
        ),
    },
)
