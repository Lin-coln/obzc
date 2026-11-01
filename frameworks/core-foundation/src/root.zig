const std = @import("std");

pub const CFArray = @import("CFArray.zig").CFArray;
pub const CFDictionary = @import("CFDictionary.zig").CFDictionary;
pub const CFMutableDictionary = @import("CFMutableDictionary.zig").CFMutableDictionary;
pub const CFNumber = @import("CFNumber.zig").CFNumber;
pub const CFString = @import("CFString.zig").CFString;

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
