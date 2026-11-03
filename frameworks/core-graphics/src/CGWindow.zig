const c = @import("macos").c;

pub const kCGWindowID = enum(c.CGWindowID) {
    Null = c.kCGNullWindowID,
    _,

    const Self = @This();

    pub fn wrap(value: c.CGWindowID) Self {
        return @fromBackingInt(value);
    }

    pub fn unwrap(self: Self) c.CGWindowID {
        return @backingInt(self);
    }
};
