const c = @import("macos").c;

pub const IOSurface = opaque {
    const Self = @This();
    const h = @import("macos").helpers.ref(Self);
    const raw = h.raw;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn incrementUseCount(self: *Self) void {
        c.IOSurfaceIncrementUseCount(self.raw());
    }

    pub fn decrementUseCount(self: *Self) void {
        c.IOSurfaceDecrementUseCount(self.raw());
    }
};
