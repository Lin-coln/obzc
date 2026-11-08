const core2 = @import("core2");
const std = @import("std");
const z = @import("macos").z;
const mtl = @import("root.zig");
const MTLDevice = @import("MTLDevice.zig").MTLDevice;

pub const MTLTexture = opaque {
    const Self = @This();
    const h = mtl.Resource.Mixin(Self);

    pub const _encoding = h._encoding;

    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;

    pub const width = h._p("width", z.NSUInteger).getter;
    pub const height = h._p("height", z.NSUInteger).getter;
    pub const pixelFormat = h._p("pixelFormat", z.MTLPixelFormat).getter;
    pub const device = h.device;
};

test "MTLTexture: dimensions, format, and device describe the created resource" {
    const MTLTextureDescriptor = @import("MTLTextureDescriptor.zig").MTLTextureDescriptor;
    const pool = core2.AutoReleasePool.create();
    defer pool.release();
    const device = MTLDevice.createSystemDefaultDevice() orelse return error.SkipZigTest;
    defer device.release();
    const descriptor = MTLTextureDescriptor.texture2DDescriptor(z.MTLPixelFormatBGRA8Unorm, 8, 4, false);
    const texture = device.newTexture(descriptor).?;
    defer texture.release();

    try std.testing.expectEqual(8, texture.width());
    try std.testing.expectEqual(4, texture.height());
    try std.testing.expectEqual(@as(z.MTLPixelFormat, z.MTLPixelFormatBGRA8Unorm), texture.pixelFormat());
    try std.testing.expectEqual(device, texture.device());
}
