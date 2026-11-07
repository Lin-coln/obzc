const std = @import("std");

pub const sources = .{
    @import("encode.test.zig"),
    @import("struct.test.zig"),
};

test {
    std.testing.refAllDecls(@This());
}
