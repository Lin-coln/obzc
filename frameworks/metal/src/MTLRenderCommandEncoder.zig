const mtl = @import("root.zig");
const z = @import("macos").z;
const MTLRenderPipelineState = @import("MTLRenderPipelineState.zig").MTLRenderPipelineState;
const MTLTexture = @import("MTLTexture.zig").MTLTexture;

pub const MTLRenderCommandEncoder = opaque {
    const Self = @This();
    const h = mtl.CommandEncoder.Mixin(Self);

    pub const _encoding = h._encoding;

    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;

    pub fn setRenderPipelineState(self: *Self, state: *MTLRenderPipelineState) void {
        h._call(self, void, "setRenderPipelineState:", .{state});
    }

    pub fn setVertexBytes(self: *Self, bytes: *const anyopaque, length: z.NSUInteger, index: z.NSUInteger) void {
        h._call(self, void, "setVertexBytes:length:atIndex:", .{ bytes, length, index });
    }

    pub fn setFragmentTexture(self: *Self, texture: ?*MTLTexture, index: z.NSUInteger) void {
        h._call(self, void, "setFragmentTexture:atIndex:", .{ texture, index });
    }

    pub fn drawPrimitives(self: *Self, primitive_type: z.MTLPrimitiveType, vertex_start: z.NSUInteger, vertex_count: z.NSUInteger) void {
        h._call(self, void, "drawPrimitives:vertexStart:vertexCount:", .{ primitive_type, vertex_start, vertex_count });
    }

    pub const endEncoding = h.endEncoding;
};
