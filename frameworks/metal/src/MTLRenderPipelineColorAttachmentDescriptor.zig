const std = @import("std");
const ns = @import("foundation");
const z = @import("macos").z;

pub const MTLRenderPipelineColorAttachmentDescriptor = opaque {
    const Self = @This();
    const h = ns.Object.Mixin(Self);

    pub const _encoding = h._encoding;

    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;

    pub fn new() *Self {
        return h._cls(null).new(Self);
    }

    pub const pixelFormat = h._p("pixelFormat", z.MTLPixelFormat).getter;
    pub const setPixelFormat = h._p("pixelFormat", z.MTLPixelFormat).setter;
};

test "MTLRenderPipelineColorAttachmentDescriptor: pixelFormat can be changed" {
    const descriptor = MTLRenderPipelineColorAttachmentDescriptor.new();
    defer descriptor.release();

    descriptor.setPixelFormat(z.MTLPixelFormatBGRA8Unorm);
    try std.testing.expectEqual(@as(z.MTLPixelFormat, z.MTLPixelFormatBGRA8Unorm), descriptor.pixelFormat());
    descriptor.setPixelFormat(z.MTLPixelFormatRGBA16Float);
    try std.testing.expectEqual(@as(z.MTLPixelFormat, z.MTLPixelFormatRGBA16Float), descriptor.pixelFormat());
}
