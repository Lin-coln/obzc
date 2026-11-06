const core = @import("core");
const mtl = @import("mtl-abi");
const MTLRenderPipelineState = @import("MTLRenderPipelineState.zig").MTLRenderPipelineState;
const MTLTexture = @import("MTLTexture.zig").MTLTexture;

pub const MTLRenderCommandEncoder = opaque {
    pub const metadata = core.Metadata.obj;
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn setRenderPipelineState(self: *Self, state: *MTLRenderPipelineState) void {
        h.call(self, void, "setRenderPipelineState:", .{state});
    }

    pub fn setVertexBytes(self: *Self, bytes: *const anyopaque, length: usize, index: usize) void {
        h.call(self, void, "setVertexBytes:length:atIndex:", .{ bytes, length, index });
    }

    pub fn setFragmentTexture(self: *Self, texture: ?*MTLTexture, index: usize) void {
        h.call(self, void, "setFragmentTexture:atIndex:", .{ texture, index });
    }

    pub fn drawPrimitives(self: *Self, primitive_type: mtl.MTLPrimitiveType, vertex_start: usize, vertex_count: usize) void {
        h.call(self, void, "drawPrimitives:vertexStart:vertexCount:", .{ primitive_type, vertex_start, vertex_count });
    }

    pub fn endEncoding(self: *Self) void {
        h.call(self, void, "endEncoding", .{});
    }
};
