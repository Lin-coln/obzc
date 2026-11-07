const std = @import("std");
const core = @import("core");
const e = core.ffi.metadata.e;
const z = @import("macos").z;
const MTLRenderPassColorAttachmentDescriptor = @import("MTLRenderPassColorAttachmentDescriptor.zig").MTLRenderPassColorAttachmentDescriptor;

pub const MTLRenderPassColorAttachmentDescriptorArray = opaque {
    pub const _encoding = e(.obj);
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    /// Returns a borrowed attachment descriptor. The index must be in 0...7.
    pub fn objectAtIndexedSubscript(self: *Self, index: z.NSUInteger) *MTLRenderPassColorAttachmentDescriptor {
        return h.call(self, *MTLRenderPassColorAttachmentDescriptor, "objectAtIndexedSubscript:", .{index});
    }
};

test "MTLRenderPassColorAttachmentDescriptorArray: indexed attachments keep independent values" {
    const MTLRenderPassDescriptor = @import("MTLRenderPassDescriptor.zig").MTLRenderPassDescriptor;
    const descriptor = MTLRenderPassDescriptor.new();
    defer descriptor.release();
    const colors = descriptor.colorAttachments();
    const first = colors.objectAtIndexedSubscript(0);
    const second = colors.objectAtIndexedSubscript(1);

    first.setLoadAction(z.MTLLoadActionClear);
    second.setLoadAction(z.MTLLoadActionLoad);
    try std.testing.expectEqual(@as(z.MTLLoadAction, z.MTLLoadActionClear), colors.objectAtIndexedSubscript(0).loadAction());
    try std.testing.expectEqual(@as(z.MTLLoadAction, z.MTLLoadActionLoad), colors.objectAtIndexedSubscript(1).loadAction());
}
