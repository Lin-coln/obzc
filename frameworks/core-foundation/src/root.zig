const std = @import("std");

pub const Array = @import("CFArray.zig").CFArray;
pub const Boolean = @import("CFBoolean.zig").CFBoolean;
pub const Dictionary = @import("CFDictionary.zig").CFDictionary;
pub const Number = @import("CFNumber.zig").CFNumber;
pub const String = @import("CFString.zig").CFString;

const c = @import("macos").c;

pub fn retain(ptr: *const anyopaque) *const anyopaque {
    _ = c.CFRetain(ptr);
    return ptr;
}

pub fn release(ptr: *const anyopaque) void {
    c.CFRelease(ptr);
}

test {
    std.testing.refAllDecls(@This());
}
