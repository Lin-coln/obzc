const std = @import("std");

pub const ffi = @import("ffi/root.zig");
pub const c = ffi.c;

const src = @import("src/root.zig");
pub const Buffer = src.Buffer;

test {
    std.testing.refAllDecls(@This());
}
