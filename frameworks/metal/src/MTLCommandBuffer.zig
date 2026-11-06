const core = @import("core");
const ns = @import("foundation");
const mtl = @import("mtl-abi");
const MTLRenderPassDescriptor = @import("MTLRenderPassDescriptor.zig").MTLRenderPassDescriptor;
const MTLRenderCommandEncoder = @import("MTLRenderCommandEncoder.zig").MTLRenderCommandEncoder;
const MTLBlitCommandEncoder = @import("MTLBlitCommandEncoder.zig").MTLBlitCommandEncoder;

pub const MTLCommandBuffer = opaque {
    pub const metadata = core.Metadata.obj;
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    /// Returned encoders are autoreleased and must finish before another encoder starts.
    pub fn renderCommandEncoder(self: *Self, descriptor: *MTLRenderPassDescriptor) ?*MTLRenderCommandEncoder {
        return h.call(self, ?*MTLRenderCommandEncoder, "renderCommandEncoderWithDescriptor:", .{descriptor});
    }

    pub fn blitCommandEncoder(self: *Self) ?*MTLBlitCommandEncoder {
        return h.call(self, ?*MTLBlitCommandEncoder, "blitCommandEncoder", .{});
    }

    pub fn commit(self: *Self) void {
        h.call(self, void, "commit", .{});
    }

    pub fn waitUntilCompleted(self: *Self) void {
        h.call(self, void, "waitUntilCompleted", .{});
    }

    pub fn status(self: *Self) mtl.MTLCommandBufferStatus {
        return h.call(self, mtl.MTLCommandBufferStatus, "status", .{});
    }
    /// Borrowed error describing a failed command buffer.
    pub fn @"error"(self: *Self) ?*ns.Error {
        return h.call(self, ?*ns.Error, "error", .{});
    }
};
