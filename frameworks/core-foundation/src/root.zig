const std = @import("std");

pub const Type = @import("CFBase/CFType.zig").CFType;
pub const Array = @import("CFArray.zig").CFArray;
pub const Boolean = @import("CFBoolean.zig").CFBoolean;
pub const Dictionary = @import("CFDictionary.zig").CFDictionary;
pub const Error = @import("CFBase/CFError.zig").CFError;
pub const Null = @import("CFBase/CFNull.zig").CFNull;
pub const Number = @import("CFNumber.zig").CFNumber;
pub const String = @import("CFString.zig").CFString;

// const
pub const kBoolean = @import("CFBoolean.zig").kCFBoolean;
pub const kNumberType = @import("CFNumber.zig").kCFNumberType;

test {
    std.testing.refAllDecls(@This());
}
