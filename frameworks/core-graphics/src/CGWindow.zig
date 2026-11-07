const c = @import("macos").c;

pub inline fn kCGWindowID(value: enum { Null }) c.CGWindowID {
    return switch (value) {
        .Null => c.kCGNullWindowID,
    };
}

test "null window ID matches Core Graphics" {
    const std = @import("std");
    try std.testing.expectEqual(c.kCGNullWindowID, kCGWindowID(.Null));
}
