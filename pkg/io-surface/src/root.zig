const std = @import("std");

pub const Surface = @import("Surface.zig").Surface;

test {
    std.testing.refAllDecls(@This());
}
