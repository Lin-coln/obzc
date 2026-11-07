const z = @import("macos").z;
const cf = @import("core-foundation");
const cv = @import("root.zig");
const mtl = @import("metal");

pub const CVMetalTextureCache = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn create(device: *mtl.Device, attributes: ?*const cf.Dictionary) ?*Self {
        var cache: z.CVMetalTextureCacheRef = null;
        if (z.CVMetalTextureCacheCreate(null, @ptrCast(attributes), @ptrCast(device), null, &cache) != cv.kReturn(.Success))
            return null;
        return @ptrCast(cache);
    }

    pub fn createTextureFromImage(
        self: *Self,
        image: *cv.ImageBuffer,
        attributes: ?*const cf.Dictionary,
        pixel_format: z.MTLPixelFormat,
        width: usize,
        height: usize,
        plane_index: usize,
    ) ?*cv.MetalTexture {
        var texture: z.CVMetalTextureRef = null;
        if (z.CVMetalTextureCacheCreateTextureFromImage(
            null,
            @ptrCast(self),
            @ptrCast(image),
            @ptrCast(attributes),
            pixel_format,
            width,
            height,
            plane_index,
            &texture,
        ) != cv.kReturn(.Success)) return null;
        return @ptrCast(texture);
    }
};
