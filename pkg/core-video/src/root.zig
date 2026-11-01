const std = @import("std");

pub const Buffer = @import("Buffer.zig").Buffer;

test {
    std.testing.refAllDecls(@This());
}
