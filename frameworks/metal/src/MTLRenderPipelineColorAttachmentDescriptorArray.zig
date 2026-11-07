const std = @import("std");
const core = @import("core");
const z = @import("macos").z;
const MTLRenderPipelineColorAttachmentDescriptor = @import("MTLRenderPipelineColorAttachmentDescriptor.zig").MTLRenderPipelineColorAttachmentDescriptor;

pub const MTLRenderPipelineColorAttachmentDescriptorArray = opaque {
    pub const metadata = core.Metadata.obj;
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    /// Returns a borrowed attachment descriptor. The index must be in 0...7.
    pub fn objectAtIndexedSubscript(self: *Self, index: z.NSUInteger) *MTLRenderPipelineColorAttachmentDescriptor {
        return h.call(self, *MTLRenderPipelineColorAttachmentDescriptor, "objectAtIndexedSubscript:", .{index});
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
