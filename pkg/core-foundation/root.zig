const std = @import("std");

pub const ffi = @import("ffi/root.zig");
pub const c = ffi.c;

const src = @import("src/root.zig");
pub const Array = src.Array;
pub const Dictionary = src.Dictionary;
pub const Number = src.Number;
pub const String = src.String;

pub const retain = src.retain;
pub const release = src.release;

test {
    std.testing.refAllDecls(@This());
}
