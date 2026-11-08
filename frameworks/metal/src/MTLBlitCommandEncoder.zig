const mtl = @import("root.zig");
const MTLTexture = @import("MTLTexture.zig").MTLTexture;

pub const MTLBlitCommandEncoder = opaque {
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

    pub fn copyFromTexture(self: *Self, source: *MTLTexture, destination: *MTLTexture) void {
        h._call(self, void, "copyFromTexture:toTexture:", .{ source, destination });
    }

    pub const endEncoding = h.endEncoding;
};
