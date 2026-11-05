const c = @import("macos").c;
const cf = @import("../root.zig");

pub const CFString = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;

    pub fn getTypeID() c.CFTypeID {
        return c.CFStringGetTypeID();
    }

    pub fn length(self: *const Self) usize {
        return @intCast(c.CFStringGetLength(self.raw()));
    }

    fn raw(self: *const Self) c.CFStringRef {
        return @ptrCast(self);
    }
};
