const std = @import("std");
const core = @import("core");
const z = @import("macos").z;
const MTLDevice = @import("MTLDevice.zig").MTLDevice;

pub const MTLTexture = opaque {
    pub const metadata = core.Metadata.obj;
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn width(self: *Self) z.NSUInteger {
        return h.call(self, z.NSUInteger, "width", .{});
    }

    pub fn height(self: *Self) z.NSUInteger {
        return h.call(self, z.NSUInteger, "height", .{});
    }

    pub fn pixelFormat(self: *Self) z.MTLPixelFormat {
        return h.call(self, z.MTLPixelFormat, "pixelFormat", .{});
    }
    /// Borrowed device that created this texture.
    pub fn device(self: *Self) *MTLDevice {
        return h.call(self, *MTLDevice, "device", .{});
    }
};

test "MTLTexture: dimensions, format, and device describe the created resource" {
    const MTLTextureDescriptor = @import("MTLTextureDescriptor.zig").MTLTextureDescriptor;
    const pool = core.AutoReleasePool.create();
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
