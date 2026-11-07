const std = @import("std");
pub const sources = .{
    @import("helpers/method/initBlockWithContext.test.zig"),
    @import("helpers/method/makeWithCallback.test.zig"),
    @import("helpers/method/makeWithSync.test.zig"),
    @import("helpers/method/spreadForCallback.test.zig"),
};

test {
    std.testing.refAllDecls(@This());
}
