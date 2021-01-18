
load(
    "@rules_buf//internal:buf_build.bzl",
    _buf_image = "buf_image",
)


## Rule Exports
buf_image = _buf_image
