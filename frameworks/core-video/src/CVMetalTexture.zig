const c = @import("macos").c;
const cf = @import("core-foundation");
const mtl = @import("metal");

pub const CVMetalTexture = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    /// The Metal texture is borrowed from this CVMetalTexture.
    pub fn getTexture(self: *Self) ?*mtl.Texture {
        return @ptrCast(c.CVMetalTextureGetTexture(@ptrCast(self)) orelse return null);
    }
};
