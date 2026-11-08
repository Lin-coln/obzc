const std = @import("std");
const ns = @import("foundation");
const z = @import("macos").z;
const MTLRenderPipelineColorAttachmentDescriptor = @import("MTLRenderPipelineColorAttachmentDescriptor.zig").MTLRenderPipelineColorAttachmentDescriptor;

pub const MTLRenderPipelineColorAttachmentDescriptorArray = opaque {
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

    /// Returns a borrowed attachment descriptor. The index must be in 0...7.
    pub fn objectAtIndexedSubscript(self: *Self, index: z.NSUInteger) *MTLRenderPipelineColorAttachmentDescriptor {
        return h._call(self, *MTLRenderPipelineColorAttachmentDescriptor, "objectAtIndexedSubscript:", .{index});
    }
};

test "MTLRenderPipelineColorAttachmentDescriptorArray: indexed attachments keep independent values" {
    const MTLRenderPipelineDescriptor = @import("MTLRenderPipelineDescriptor.zig").MTLRenderPipelineDescriptor;
    const descriptor = MTLRenderPipelineDescriptor.new();
    defer descriptor.release();
    const colors = descriptor.colorAttachments();
    const first = colors.objectAtIndexedSubscript(0);
    const second = colors.objectAtIndexedSubscript(1);

    first.setPixelFormat(z.MTLPixelFormatBGRA8Unorm);
    second.setPixelFormat(z.MTLPixelFormatRGBA16Float);
    try std.testing.expectEqual(@as(z.MTLPixelFormat, z.MTLPixelFormatBGRA8Unorm), colors.objectAtIndexedSubscript(0).pixelFormat());
    try std.testing.expectEqual(@as(z.MTLPixelFormat, z.MTLPixelFormatRGBA16Float), colors.objectAtIndexedSubscript(1).pixelFormat());
}
