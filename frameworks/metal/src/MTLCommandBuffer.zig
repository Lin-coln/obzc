const ns = @import("foundation");
const z = @import("macos").z;
const MTLRenderPassDescriptor = @import("MTLRenderPassDescriptor.zig").MTLRenderPassDescriptor;
const MTLRenderCommandEncoder = @import("MTLRenderCommandEncoder.zig").MTLRenderCommandEncoder;
const MTLBlitCommandEncoder = @import("MTLBlitCommandEncoder.zig").MTLBlitCommandEncoder;

pub const MTLCommandBuffer = opaque {
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

    /// Returned encoders are autoreleased and must finish before another encoder starts.
    pub fn renderCommandEncoder(self: *Self, descriptor: *MTLRenderPassDescriptor) ?*MTLRenderCommandEncoder {
        return h._call(self, ?*MTLRenderCommandEncoder, "renderCommandEncoderWithDescriptor:", .{descriptor});
    }

    pub fn blitCommandEncoder(self: *Self) ?*MTLBlitCommandEncoder {
        return h._call(self, ?*MTLBlitCommandEncoder, "blitCommandEncoder", .{});
    }

    pub fn commit(self: *Self) void {
        h._call(self, void, "commit", .{});
    }

    pub fn waitUntilCompleted(self: *Self) void {
        h._call(self, void, "waitUntilCompleted", .{});
    }

    pub const status = h._p("status", z.MTLCommandBufferStatus).getter;
    /// Borrowed error describing a failed command buffer.
    pub const @"error" = h._p("error", ?*ns.Error).getter;
};
