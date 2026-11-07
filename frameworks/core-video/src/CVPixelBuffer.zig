const c = @import("macos").c;
const cf = @import("core-foundation");
const ios = @import("io-surface");
const cv = @import("root.zig");

pub const CVPixelBuffer = opaque {
    const Self = @This();
    const h = cv.ImageBuffer.Mixin(Self);

    pub const create = CVPixelBufferCreate;
    pub const createWithIOSurface = CVPixelBufferCreateWithIOSurface;

    pub const retain = h.retain;
    pub const release = h.release;

    pub const getEncodedSize = h.getEncodedSize;
    pub const getDisplaySize = h.getDisplaySize;
    pub const getCleanRect = h.getCleanRect;

    pub fn getBaseAddress(self: *Self) ?[*]u8 {
        const address = c.CVPixelBufferGetBaseAddress(raw(self)) orelse return null;
        return @ptrCast(address);
    }

    pub fn getDataSize(self: *Self) usize {
        return c.CVPixelBufferGetDataSize(raw(self));
    }

    pub fn getBytesPerRow(self: *Self) usize {
        return c.CVPixelBufferGetBytesPerRow(raw(self));
    }

    pub fn getWidth(self: *Self) usize {
        return c.CVPixelBufferGetWidth(raw(self));
    }

    pub fn getHeight(self: *Self) usize {
        return c.CVPixelBufferGetHeight(raw(self));
    }

    pub fn lockBaseAddress(self: *Self, flags: c.CVPixelBufferLockFlags) bool {
        return c.CVPixelBufferLockBaseAddress(raw(self), flags) == cv.kReturn(.Success);
    }

    pub fn unlockBaseAddress(self: *Self, flags: c.CVPixelBufferLockFlags) bool {
        return c.CVPixelBufferUnlockBaseAddress(raw(self), flags) == cv.kReturn(.Success);
    }

    pub fn getIOSurface(self: *Self) ?*ios.Surface {
        const surface = c.CVPixelBufferGetIOSurface(raw(self)) orelse return null;
        return @ptrCast(surface);
    }

    fn raw(self: *Self) c.CVPixelBufferRef {
        return @ptrCast(self);
    }
};

pub fn CVPixelBufferCreate(
    width: usize,
    height: usize,
    format: c.OSType,
    attrs: ?*const cf.Dictionary,
) ?*CVPixelBuffer {
    var buffer: c.CVPixelBufferRef = null;
    if (c.CVPixelBufferCreate(null, width, height, format, @ptrCast(attrs), &buffer) != cv.kReturn(.Success))
        return null;
    return @ptrCast(buffer);
}

pub fn CVPixelBufferCreateWithIOSurface(
    surface: *ios.Surface,
    attrs: ?*const cf.Dictionary,
) ?*CVPixelBuffer {
    var buffer: c.CVPixelBufferRef = null;
    if (c.CVPixelBufferCreateWithIOSurface(null, @ptrCast(surface), @ptrCast(attrs), &buffer) != cv.kReturn(.Success))
        return null;
    return @ptrCast(buffer);
}

pub inline fn kCVPixelFormat(value: enum { BGRA32, RGBA64Half }) c.OSType {
    return switch (value) {
        .BGRA32 => c.kCVPixelFormatType_32BGRA,
        .RGBA64Half => c.kCVPixelFormatType_64RGBAHalf,
    };
}

pub inline fn kCVPixelBufferKey(value: enum {
    IOSurfaceProperties,
    MetalCompatibility,
}) *const cf.String {
    const raw: c.CFStringRef = switch (value) {
        inline else => |key| @field(c, "kCVPixelBuffer" ++ @tagName(key) ++ "Key"),
    };
    return @ptrCast(raw.?);
}

pub const kCVPixelBufferLockFlags = enum {
    ReadOnly,

    const Self = @This();

    pub fn create(flags: []const Self) c.CVPixelBufferLockFlags {
        var raw: c.CVPixelBufferLockFlags = 0;
        for (flags) |flag| {
            raw |= switch (flag) {
                inline else => |value| @field(c, "kCVPixelBufferLock_" ++ @tagName(value)),
            };
        }
        return raw;
    }
};

test "pixel buffer inherits image and buffer operations" {
    const std = @import("std");
    try std.testing.expectEqual(@as(c.OSType, c.kCVPixelFormatType_32BGRA), kCVPixelFormat(.BGRA32));
    try std.testing.expectEqual(@as(c.CVPixelBufferLockFlags, c.kCVPixelBufferLock_ReadOnly), kCVPixelBufferLockFlags.create(&.{.ReadOnly}));
    try std.testing.expectEqual(@as(c.CVPixelBufferLockFlags, 0), kCVPixelBufferLockFlags.create(&.{}));
    try std.testing.expect(kCVPixelBufferKey(.IOSurfaceProperties).equal(@ptrCast(c.kCVPixelBufferIOSurfacePropertiesKey.?)));
    const buffer = CVPixelBuffer.create(2, 2, kCVPixelFormat(.BGRA32), null) orelse return error.PixelBufferCreationFailed;
    defer buffer.release();

    try std.testing.expectEqual(@as(f64, 2), buffer.getEncodedSize().width);
    try std.testing.expect(buffer.lockBaseAddress(0));
    defer _ = buffer.unlockBaseAddress(0);
    try std.testing.expect(buffer.getBaseAddress() != null);
    try std.testing.expect(buffer.getBytesPerRow() >= 8);
    const retained = buffer.retain();
    retained.release();
}
