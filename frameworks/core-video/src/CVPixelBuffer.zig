const c = @import("macos").c;
const cf = @import("core-foundation");
const ios = @import("io-surface");
const CVImageBuffer = @import("CVImageBuffer.zig").CVImageBuffer;

pub const CVPixelBuffer = opaque {
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

    pub fn lockBaseAddress(self: *Self, flags: []const kCVPixelBufferLockFlag) bool {
        return c.CVPixelBufferLockBaseAddress(raw(self), kCVPixelBufferLockFlag.flags(flags)) == c.kCVReturnSuccess;
    }

    pub fn unlockBaseAddress(self: *Self, flags: []const kCVPixelBufferLockFlag) bool {
        return c.CVPixelBufferUnlockBaseAddress(raw(self), kCVPixelBufferLockFlag.flags(flags)) == c.kCVReturnSuccess;
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
    format: kCVPixelFormat,
    attrs: ?*const cf.Dictionary,
) ?*CVPixelBuffer {
    var buffer: c.CVPixelBufferRef = null;
    if (c.CVPixelBufferCreate(null, width, height, format.unwrap(), @ptrCast(attrs), &buffer) != c.kCVReturnSuccess)
        return null;
    return @ptrCast(buffer);
}

pub const kCVPixelFormat = enum(c.OSType) {
    BGRA32 = c.kCVPixelFormatType_32BGRA,
    RGBA64Half = c.kCVPixelFormatType_64RGBAHalf,
    _,

    const Self = @This();

    pub fn wrap(value: c.OSType) Self {
        return @fromBackingInt(value);
    }

    pub fn unwrap(self: Self) c.OSType {
        return @backingInt(self);
    }

    pub fn fromRaw(raw: c.OSType) Self {
        return @fromBackingInt(raw);
    }
};

pub const kCVPixelBufferKey = enum {
    IOSurfaceProperties,
    MetalCompatibility,

    const Self = @This();

    pub fn unwrap(self: Self) *const cf.String {
        const raw: c.CFStringRef = switch (self) {
            inline else => |key| @field(c, "kCVPixelBuffer" ++ @tagName(key) ++ "Key"),
        };
        return @ptrCast(raw.?);
    }

    pub fn fromRaw(raw: c.CFStringRef) ?Self {
        const key: *const cf.String = @ptrCast(raw orelse return null);
        inline for (@import("std").meta.tags(Self)) |candidate| {
            if (key.equal(candidate.unwrap())) return candidate;
        }
        return null;
    }
};

pub const kCVPixelBufferLockFlag = enum(c_int) {
    None = 0,
    ReadOnly = c.kCVPixelBufferLock_ReadOnly,
    _,

    const Self = @This();

    pub fn unwrap(self: Self) c_int {
        return @backingInt(self);
    }

    pub fn fromRaw(raw: c_int) Self {
        return @fromBackingInt(raw);
    }

    pub fn flags(args: []const Self) c.CVPixelBufferLockFlags {
        var bits: c.CVPixelBufferLockFlags = 0;
        for (args) |flag| {
            const raw = flag.unwrap();
            bits |= @as(c.CVPixelBufferLockFlags, @as(u32, @bitCast(raw)));
        }
        return bits;
    }
};

test "pixel buffer inherits image and buffer operations" {
    const std = @import("std");
    try std.testing.expectEqual(kCVPixelFormat.BGRA32, kCVPixelFormat.fromRaw(kCVPixelFormat.BGRA32.unwrap()));
    try std.testing.expectEqual(kCVPixelBufferLockFlag.ReadOnly, kCVPixelBufferLockFlag.fromRaw(kCVPixelBufferLockFlag.ReadOnly.unwrap()));
    try std.testing.expectEqual(kCVPixelBufferKey.IOSurfaceProperties, kCVPixelBufferKey.fromRaw(@ptrCast(kCVPixelBufferKey.IOSurfaceProperties.unwrap())).?);
    const buffer = CVPixelBuffer.create(2, 2, .BGRA32, null) orelse return error.PixelBufferCreationFailed;
    defer buffer.release();

    try std.testing.expectEqual(@as(f64, 2), buffer.getEncodedSize().width);
    try std.testing.expectEqual(@as(c.CVPixelBufferLockFlags, 0), kCVPixelBufferLockFlag.flags(&.{}));
    const extra: kCVPixelBufferLockFlag = @fromBackingInt(2);
    try std.testing.expectEqual(@as(c.CVPixelBufferLockFlags, 3), kCVPixelBufferLockFlag.flags(&.{ .ReadOnly, extra }));
    try std.testing.expect(buffer.lockBaseAddress(&.{}));
    defer _ = buffer.unlockBaseAddress(&.{});
    try std.testing.expect(buffer.getBaseAddress() != null);
    try std.testing.expect(buffer.getBytesPerRow() >= 8);
    const retained = buffer.retain();
    retained.release();
}
