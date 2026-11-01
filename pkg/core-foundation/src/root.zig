const std = @import("std");

pub const Array = @import("Array.zig").Array;
pub const Dictionary = @import("Dictionary.zig").Dictionary;
pub const Number = @import("Number.zig").Number;
pub const String = @import("String.zig").String;

const c = @import("../ffi/root.zig").c;

pub fn retain(ptr: *const anyopaque) *const anyopaque {
    return c.CFRetain(ptr).?;
}

pub fn release(ptr: *const anyopaque) void {
    c.CFRelease(ptr);
}

test {
    std.testing.refAllDecls(@This());
}
