const std = @import("std");

pub const Array = @import("CFArray.zig").CFArray;
pub const Boolean = @import("CFBoolean.zig").CFBoolean;
pub const Dictionary = @import("CFDictionary.zig").CFDictionary;
pub const Number = @import("CFNumber.zig").CFNumber;
pub const String = @import("CFString.zig").CFString;

pub const k = struct {
    pub const Boolean = @import("CFBoolean.zig").kCFBoolean;
};

test {
    std.testing.refAllDecls(@This());
}
