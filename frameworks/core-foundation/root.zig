const std = @import("std");

pub const ffi = @import("ffi/root.zig");
pub const c = ffi.c;

const src = @import("src/root.zig");
pub const Array = src.CFArray;
pub const Dictionary = src.CFDictionary;
pub const MutableDictionary = src.CFMutableDictionary;
pub const Number = src.CFNumber;
pub const String = src.CFString;

pub const retain = src.retain;
pub const release = src.release;

test {
    std.testing.refAllDecls(@This());
}
