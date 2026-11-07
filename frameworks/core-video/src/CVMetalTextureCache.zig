const c = @import("macos").c;
const cf = @import("core-foundation");
const cv = @import("root.zig");

pub const CVMetalTextureCache = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    /// The device is an Objective-C Metal device reference.
    pub fn create(device: *anyopaque, attributes: ?*const cf.Dictionary) ?*Self {
        var cache: c.CVMetalTextureCacheRef = null;
        if (c.CVMetalTextureCacheCreate(null, @ptrCast(attributes), device, null, &cache) != c.kCVReturnSuccess)
            return null;
        return @ptrCast(cache);
    }

    pub fn createTextureFromImage(
        self: *Self,
        image: *cv.ImageBuffer,
        attributes: ?*const cf.Dictionary,
        pixel_format: usize,
        width: usize,
        height: usize,
        plane_index: usize,
    ) ?*cv.MetalTexture {
        var texture: c.CVMetalTextureRef = null;
        if (c.CVMetalTextureCacheCreateTextureFromImage(
            null,
            @ptrCast(self),
            @ptrCast(image),
            @ptrCast(attributes),
            pixel_format,
            width,
            height,
            plane_index,
            &texture,
        ) != c.kCVReturnSuccess) return null;
        return @ptrCast(texture);
    }
};
