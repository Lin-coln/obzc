const c = @import("macos").c;
const cf = @import("core-foundation");

pub const IOSurface = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn incrementUseCount(self: *Self) void {
        c.IOSurfaceIncrementUseCount(self.raw());
    }

    pub fn decrementUseCount(self: *Self) void {
        c.IOSurfaceDecrementUseCount(self.raw());
    }

    fn raw(self: *Self) c.IOSurfaceRef {
        return @ptrCast(self);
    }
};
