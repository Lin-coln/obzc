const std = @import("std");
const core = @import("core");
const z = @import("macos").z;

pub const MTLTextureDescriptor = opaque {
    pub const metadata = core.Metadata.obj;
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const new = h.cls.new;

    /// Returns an autoreleased descriptor; retain it to keep it beyond the current pool.
    pub fn texture2DDescriptor(pixel_format: z.MTLPixelFormat, width_value: z.NSUInteger, height_value: z.NSUInteger, mipmapped: bool) *Self {
        return h.cls.call(*Self, "texture2DDescriptorWithPixelFormat:width:height:mipmapped:", .{
            pixel_format,
            width_value,
            height_value,
            mipmapped,
        });
    }

    pub const pixelFormat = h.prop("pixelFormat", z.MTLPixelFormat).getter;
    pub const setPixelFormat = h.prop("pixelFormat", z.MTLPixelFormat).setter;
    pub const width = h.prop("width", z.NSUInteger).getter;
    pub const setWidth = h.prop("width", z.NSUInteger).setter;
    pub const height = h.prop("height", z.NSUInteger).getter;
    pub const setHeight = h.prop("height", z.NSUInteger).setter;
    pub const mipmapLevelCount = h.prop("mipmapLevelCount", z.NSUInteger).getter;
    pub const usage = h.prop("usage", z.MTLTextureUsage).getter;
    pub const setUsage = h.prop("usage", z.MTLTextureUsage).setter;
    pub const storageMode = h.prop("storageMode", z.MTLStorageMode).getter;
    pub const setStorageMode = h.prop("storageMode", z.MTLStorageMode).setter;
};

test "MTLTextureDescriptor: configure texture dimensions and storage" {
    const pool = core.AutoReleasePool.create();
    defer pool.release();
    const descriptor = MTLTextureDescriptor.texture2DDescriptor(z.MTLPixelFormatBGRA8Unorm, 32, 16, false);
    descriptor.setUsage(z.MTLTextureUsageShaderRead | z.MTLTextureUsageRenderTarget);
    descriptor.setStorageMode(z.MTLStorageModePrivate);

    try std.testing.expectEqual(32, descriptor.width());
    try std.testing.expectEqual(16, descriptor.height());
    try std.testing.expectEqual(1, descriptor.mipmapLevelCount());
    try std.testing.expectEqual(@as(z.MTLPixelFormat, z.MTLPixelFormatBGRA8Unorm), descriptor.pixelFormat());
    try std.testing.expectEqual(@as(z.MTLTextureUsage, z.MTLTextureUsageShaderRead | z.MTLTextureUsageRenderTarget), descriptor.usage());
    try std.testing.expectEqual(@as(z.MTLStorageMode, z.MTLStorageModePrivate), descriptor.storageMode());

    descriptor.setWidth(64);
    descriptor.setHeight(48);
    descriptor.setPixelFormat(z.MTLPixelFormatRGBA16Float);
    try std.testing.expectEqual(64, descriptor.width());
    try std.testing.expectEqual(48, descriptor.height());
    try std.testing.expectEqual(@as(z.MTLPixelFormat, z.MTLPixelFormatRGBA16Float), descriptor.pixelFormat());

    const mipmapped = MTLTextureDescriptor.texture2DDescriptor(z.MTLPixelFormatBGRA8Unorm, 32, 16, true);
    try std.testing.expectEqual(6, mipmapped.mipmapLevelCount());
}
