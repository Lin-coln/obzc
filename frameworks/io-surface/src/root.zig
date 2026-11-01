const std = @import("std");

pub const IOSurface = @import("IOSurface.zig").IOSurface;

test {
    std.testing.refAllDecls(@This());
}
