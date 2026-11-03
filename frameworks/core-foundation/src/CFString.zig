const c = @import("macos").c;

pub const CFString = opaque {
    const Self = @This();
    const h = @import("CFType.zig").CFType.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    fn raw(self: *const Self) c.CFStringRef {
        return @ptrCast(self);
    }
};
