const std = @import("std");

pub const Type = @import("CFBase/CFType.zig").CFType;
pub const Array = @import("CFArray.zig").CFArray;
pub const Boolean = @import("CFBoolean.zig").CFBoolean;
pub const Data = @import("CFData.zig").CFData;
pub const Dictionary = @import("CFDictionary.zig").CFDictionary;
pub const Error = @import("CFBase/CFError.zig").CFError;
pub const Null = @import("CFBase/CFNull.zig").CFNull;
pub const Number = @import("CFNumber.zig").CFNumber;
pub const String = @import("CFString/CFString.zig").CFString;

// const
pub const kBoolean = @import("CFBoolean.zig").kCFBoolean;
pub const kCompare = @import("CFBase/CFIndex.zig").kCFCompare;
pub const kErrorDomain = @import("CFBase/CFError.zig").kCFErrorDomain;
pub const kNumberType = @import("CFNumber.zig").kCFNumberType;
pub const kStringCompareFlags = @import("CFString/CFStringCompareFlags.zig").kCFStringCompareFlags;
pub const kStringEncoding = @import("CFString/CFStringEncoding.zig").kCFStringEncoding;

test {
    std.testing.refAllDecls(@This());
}
