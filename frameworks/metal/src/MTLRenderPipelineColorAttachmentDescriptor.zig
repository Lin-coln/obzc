const std = @import("std");
const core = @import("core");
const e = core.ffi.metadata.e;
const z = @import("macos").z;

pub const MTLRenderPipelineColorAttachmentDescriptor = opaque {
    pub const _encoding = e(.obj);
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const new = h.cls.new;

    pub const pixelFormat = h.prop("pixelFormat", z.MTLPixelFormat).getter;
    pub const setPixelFormat = h.prop("pixelFormat", z.MTLPixelFormat).setter;
};

test "MTLRenderPipelineColorAttachmentDescriptor: pixelFormat can be changed" {
    const descriptor = MTLRenderPipelineColorAttachmentDescriptor.new();
    defer descriptor.release();

    descriptor.setPixelFormat(z.MTLPixelFormatBGRA8Unorm);
    try std.testing.expectEqual(@as(z.MTLPixelFormat, z.MTLPixelFormatBGRA8Unorm), descriptor.pixelFormat());
    descriptor.setPixelFormat(z.MTLPixelFormatRGBA16Float);
    try std.testing.expectEqual(@as(z.MTLPixelFormat, z.MTLPixelFormatRGBA16Float), descriptor.pixelFormat());
}
