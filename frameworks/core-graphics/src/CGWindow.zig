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

    pub fn fromRaw(raw: c.CGWindowID) Self {
        return @fromBackingInt(raw);
    }
};

test "window ID converts from raw" {
    const std = @import("std");
    try std.testing.expectEqual(kCGWindowID.Null, kCGWindowID.fromRaw(kCGWindowID.Null.unwrap()));
}
