const std = @import("std");

pub const c = @import("c.zig").c;
pub const z = @import("z.zig");

test {
    std.testing.refAllDecls(@This());
}
