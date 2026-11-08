const ns = @import("foundation");
const MTLCommandBuffer = @import("MTLCommandBuffer.zig").MTLCommandBuffer;

pub const MTLCommandQueue = opaque {
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

    /// Returns an autoreleased command buffer, or null on allocation failure.
    pub fn commandBuffer(self: *Self) ?*MTLCommandBuffer {
        return h._call(self, ?*MTLCommandBuffer, "commandBuffer", .{});
    }
};
