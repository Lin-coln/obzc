const c = @import("macos").c;
const cf = @import("core-foundation");
const ios = @import("io-surface");
const CVPixelFormat = @import("CVPixelFormat.zig").CVPixelFormat;

pub const kCVPixelBuffer = enum {
    const Self = @This();
    IOSurfacePropertiesKey,
    MetalCompatibilityKey,
    const h = @import("macos").helpers.konst(Self);
    pub const raw = h.raw;
};

pub const CVBuffer = opaque {
    const Self = @This();
    const h = @import("macos").helpers.ref(Self);
    const raw = h.raw;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn create(
        width: usize,
        height: usize,
        pixel_format: CVPixelFormat,
        attrs: ?*const cf.Dictionary,
    ) ?*Self {
        var buffer: c.CVPixelBufferRef = null;
        if (c.CVPixelBufferCreate(null, width, height, @bitCast(@backingInt(pixel_format)), @ptrCast(attrs), &buffer) != c.kCVReturnSuccess)
            return null;
        return @ptrCast(buffer);
    }

    pub fn getBaseAddress(self: *Self) ?[*]u8 {
        const address = c.CVPixelBufferGetBaseAddress(self.raw()) orelse return null;
        return @ptrCast(address);
    }

    pub fn getDataSize(self: *Self) usize {
        return c.CVPixelBufferGetDataSize(self.raw());
    }

    pub fn getBytesPerRow(self: *Self) usize {
        return c.CVPixelBufferGetBytesPerRow(self.raw());
    }

    pub fn lockBaseAddress(self: *Self, flags: CVPixelBufferLockFlags) bool {
        return c.CVPixelBufferLockBaseAddress(self.raw(), @backingInt(flags)) == c.kCVReturnSuccess;
    }

    pub fn unlockBaseAddress(self: *Self, flags: CVPixelBufferLockFlags) bool {
        return c.CVPixelBufferUnlockBaseAddress(self.raw(), @backingInt(flags)) == c.kCVReturnSuccess;
    }

    pub fn getIOSurface(self: *Self) ?*ios.Surface {
        const surface = c.CVPixelBufferGetIOSurface(self.raw()) orelse return null;
        return @ptrCast(surface);
    }
};

const CVPixelBufferLockFlags = enum(c.CVPixelBufferLockFlags) {
    none = 0,
    readOnly = c.kCVPixelBufferLock_ReadOnly,
    _,
};
