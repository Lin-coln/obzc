const c = @import("../ffi/root.zig").c;
const Surface = @import("io-surface").Surface;

pub const Buffer = opaque {
    const Self = @This();

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
