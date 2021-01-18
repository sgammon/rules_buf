

def _buf_image_impl(ctx, name = None, protos = None, config = None):
    """Implementation of the `buf_image` rule."""
    pass



buf_image = rule(
    implementation = _buf_image_impl,
    attrs = {
        "protos": attr.label_list(allow_files = False),
        "config": attr.label(allow_files = True),
        "_compiler": attr.label(
            default = "@rules_buf//internal/tools:buf",
            providers = [ProtoInfo],
        ),
    },
)
