const c = @import("macos").c;

pub const CFString = opaque {
    const Self = @This();
    const h = @import("CFType.zig").CFType.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;

    pub fn length(self: *const Self) usize {
        return @intCast(c.CFStringGetLength(self.raw()));
    }

    fn raw(self: *const Self) c.CFStringRef {
        return @ptrCast(self);
    }
};
