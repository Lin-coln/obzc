const c = @import("macos").c;
const cf = @import("root.zig");

pub const CFData = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;

    pub fn getTypeID() c.CFTypeID {
        return c.CFDataGetTypeID();
    }

    pub fn length(self: *const Self) c.CFIndex {
        return c.CFDataGetLength(@ptrCast(self));
    }
};
