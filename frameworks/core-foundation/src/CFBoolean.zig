const c = @import("macos").c;

pub const CFBoolean = opaque {
    const Self = @This();
    const h = @import("CFBase/CFType.zig").CFType.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;

    pub fn getTypeID() c.CFTypeID {
        return c.CFBooleanGetTypeID();
    }

    pub fn val(self: *const Self) bool {
        return c.CFBooleanGetValue(self.raw()) != 0;
    }

    fn raw(self: *const Self) c.CFBooleanRef {
        return @ptrCast(self);
    }
};

pub fn kCFBoolean(value: enum { True, False }) *const CFBoolean {
    const raw: c.CFBooleanRef = switch (value) {
        .True => c.kCFBooleanTrue,
        .False => c.kCFBooleanFalse,
    };
    return @ptrCast(raw.?);
}

test "kCFBoolean returns the two singleton values" {
    const std = @import("std");
    try std.testing.expect(kCFBoolean(.True).val());
    try std.testing.expect(!kCFBoolean(.False).val());
}
