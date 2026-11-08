const std = @import("std");
const ns = @import("foundation");
const z = @import("macos").z;
const MTLRenderPassColorAttachmentDescriptor = @import("MTLRenderPassColorAttachmentDescriptor.zig").MTLRenderPassColorAttachmentDescriptor;

pub const MTLRenderPassColorAttachmentDescriptorArray = opaque {
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
    pub fn objectAtIndexedSubscript(self: *Self, index: z.NSUInteger) *MTLRenderPassColorAttachmentDescriptor {
        return h._call(self, *MTLRenderPassColorAttachmentDescriptor, "objectAtIndexedSubscript:", .{index});
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
