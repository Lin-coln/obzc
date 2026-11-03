const c = @import("macos").c;
const cf = @import("core-foundation");
const ios = @import("io-surface");
const CVImageBuffer = @import("CVImageBuffer.zig").CVImageBuffer;

pub const CVPixelBuffer = opaque {
    pub const LockFlag = CVPixelBufferLockFlag;

    const Self = @This();
    const h = CVImageBuffer.Mixin(Self);

    pub const create = CVPixelBufferCreate;

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

    pub fn lockBaseAddress(self: *Self, flags: c.CVPixelBufferLockFlags) bool {
        return c.CVPixelBufferLockBaseAddress(raw(self), flags) == c.kCVReturnSuccess;
    }

    pub fn unlockBaseAddress(self: *Self, flags: c.CVPixelBufferLockFlags) bool {
        return c.CVPixelBufferUnlockBaseAddress(raw(self), flags) == c.kCVReturnSuccess;
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
    format: CVPixelFormat,
    attrs: ?*const cf.Dictionary,
) ?*CVPixelBuffer {
    var buffer: c.CVPixelBufferRef = null;
    if (c.CVPixelBufferCreate(null, width, height, @backingInt(format), @ptrCast(attrs), &buffer) != c.kCVReturnSuccess)
        return null;
    return @ptrCast(buffer);
}

pub const CVPixelFormat = enum(c.OSType) {
    BGRA32 = c.kCVPixelFormatType_32BGRA,
    RGBA64Half = c.kCVPixelFormatType_64RGBAHalf,
    _,
};

pub const kCVPixelBuffer = enum {
    IOSurfacePropertiesKey,
    MetalCompatibilityKey,

    const Self = @This();

    pub fn unwrap(self: Self) *const cf.String {
        const value: c.CFStringRef = switch (self) {
            .IOSurfacePropertiesKey => c.kCVPixelBufferIOSurfacePropertiesKey,
            .MetalCompatibilityKey => c.kCVPixelBufferMetalCompatibilityKey,
        };
        return @ptrCast(value.?);
    }
};

const CVPixelBufferLockFlag = struct {
    pub const None = 0;
    pub const ReadOnly = c.kCVPixelBufferLock_ReadOnly;
};

test "pixel buffer inherits image and buffer operations" {
    const std = @import("std");
    const buffer = CVPixelBuffer.create(2, 2, .BGRA32, null) orelse return error.PixelBufferCreationFailed;
    defer buffer.release();

    try std.testing.expectEqual(@as(f64, 2), buffer.getEncodedSize().width);
    try std.testing.expect(buffer.lockBaseAddress(CVPixelBuffer.LockFlag.None));
    defer _ = buffer.unlockBaseAddress(CVPixelBuffer.LockFlag.None);
    try std.testing.expect(buffer.getBaseAddress() != null);
    try std.testing.expect(buffer.getBytesPerRow() >= 8);
    const retained = buffer.retain();
    retained.release();
}
