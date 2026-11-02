const std = @import("std");

pub const c = @import("main-abi");

test {
    std.testing.refAllDecls(@This());
}
