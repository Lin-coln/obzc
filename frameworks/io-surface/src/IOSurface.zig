pub const IOSurface = opaque {
    const Self = @This();
    const h = @import("macos").helpers.ref(Self);
    const raw = h.raw;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn incrementUseCount(self: *Self) void {
        self.raw().IOSurfaceIncrementUseCount();
    }

    pub fn decrementUseCount(self: *Self) void {
        self.raw().IOSurfaceDecrementUseCount();
    }
};
