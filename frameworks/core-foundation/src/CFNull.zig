const c = @import("macos").c;

pub const CFNull = opaque {
    const Self = @This();
    const h = @import("CFType.zig").CFType.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;

    pub fn getTypeID() c.CFTypeID {
        return c.CFNullGetTypeID();
    }

    pub inline fn getConst() *const Self {
        return @ptrCast(c.kCFNull.?);
    }
};

test "CFNull exposes the singleton" {
    const std = @import("std");
    const null_value = CFNull.getConst();
    try std.testing.expectEqual(CFNull.getTypeID(), c.CFGetTypeID(@ptrCast(null_value)));
    try std.testing.expectEqual(@intFromPtr(c.kCFNull.?), @intFromPtr(null_value));
}
