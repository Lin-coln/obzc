const std = @import("std");

pub const Type = @import("CFBase/CFType.zig").CFType;
pub const Array = @import("CFArray.zig").CFArray;
pub const Boolean = @import("CFBoolean.zig").CFBoolean;
pub const Dictionary = @import("CFDictionary.zig").CFDictionary;
pub const Error = @import("CFBase/CFError.zig").CFError;
pub const Index = @import("CFBase/CFIndex.zig").CFIndex;
pub const Null = @import("CFBase/CFNull.zig").CFNull;
pub const Number = @import("CFNumber.zig").CFNumber;
pub const String = @import("CFString/CFString.zig").CFString;
pub const StringCompareFlags = @import("CFString/CFStringCompareFlags.zig").CFStringCompareFlags;
pub const StringEncoding = @import("CFString/CFStringEncoding.zig").CFStringEncoding;

// const
pub const kBoolean = @import("CFBoolean.zig").kCFBoolean;
pub const kNumberType = @import("CFNumber.zig").kCFNumberType;
pub const kStringEncoding = @import("CFString/CFStringEncoding.zig").kCFStringEncoding;

test {
    std.testing.refAllDecls(@This());
}
