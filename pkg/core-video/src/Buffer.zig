const c = @import("../ffi/root.zig").c;
const cf = @import("core-foundation");
const Surface = @import("io-surface").Surface;

pub const Buffer = opaque {
    const Self = @This();

    pub fn create(width: usize, height: usize, pixel_format: c.OSType, attributes: ?*const cf.Dictionary) ?*Self {
        var buffer: c.CVPixelBufferRef = null;
        if (c.CVPixelBufferCreate(null, width, height, pixel_format, @ptrCast(attributes), &buffer) != c.kCVReturnSuccess)
            return null;
        return @ptrCast(buffer);
    }

    pub fn release(self: *Self) void {
        self.raw().?.CVBufferRelease();
    }

    pub fn getBaseAddress(self: *Self) ?[*]u8 {
        const address = self.raw().?.CVPixelBufferGetBaseAddress() orelse return null;
        return @ptrCast(address);
    }

    pub fn getDataSize(self: *Self) usize {
        return self.raw().?.CVPixelBufferGetDataSize();
    }

    pub fn getBytesPerRow(self: *Self) usize {
        return self.raw().?.CVPixelBufferGetBytesPerRow();
    }

    pub fn lockBaseAddress(self: *Self, flags: c.CVPixelBufferLockFlags) bool {
        return self.raw().?.CVPixelBufferLockBaseAddress(flags) == c.kCVReturnSuccess;
    }

    pub fn unlockBaseAddress(self: *Self, flags: c.CVPixelBufferLockFlags) bool {
        return self.raw().?.CVPixelBufferUnlockBaseAddress(flags) == c.kCVReturnSuccess;
    }

    pub fn getIOSurface(self: *Self) ?*Surface {
        const surface = self.raw().?.CVPixelBufferGetIOSurface() orelse return null;
        return @ptrCast(surface);
    }

    fn raw(self: *Self) c.CVBufferRef {
        return @ptrCast(self);
    }
};
