const c = @import("../ffi/root.zig").c;

pub const IOSurface = opaque {
    const Self = @This();

    pub fn incrementUseCount(self: *Self) void {
        self.raw().?.IOSurfaceIncrementUseCount();
    }

    pub fn decrementUseCount(self: *Self) void {
        self.raw().?.IOSurfaceDecrementUseCount();
    }

    fn raw(self: *Self) c.IOSurfaceRef {
        return @ptrCast(self);
    }
};
