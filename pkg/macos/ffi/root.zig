const std = @import("std");

pub const c = @import("c.zig").c;

test {
    std.testing.refAllDecls(@This());
}
