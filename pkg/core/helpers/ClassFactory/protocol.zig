const std = @import("std");
const ffi = @import("../../ffi/root.zig");
const c = @import("macos").c;

pub fn protocol(comptime T: type) type {
    _ = T;
    return struct {
        pub fn addProtocol(cls: *ffi.Class, comptime name: [:0]const u8) !void {
            const ptc = ffi.Protocol.lookup(name) orelse return;

            const done = c.class_addProtocol(@ptrCast(cls), @ptrCast(ptc));
            if (done == c.YES) return;

            return error.AddProtocolFailed;
        }
    };
}
