const std = @import("std");

pub const Surface = @import("IOSurface.zig").IOSurface;

test {
    std.testing.refAllDecls(@This());
}
