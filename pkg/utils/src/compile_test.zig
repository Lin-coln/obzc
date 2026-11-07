const std = @import("std");

pub const sources = .{
    @import("spread.test.zig"),
    @import("resolveFnInfo.test.zig"),
    @import("resolveReceiverType.test.zig"),
};

test {
    std.testing.refAllDecls(@This());
}
