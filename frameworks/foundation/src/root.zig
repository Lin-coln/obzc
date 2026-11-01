const std = @import("std");
pub const Error = @import("NSError.zig").NSError;
pub const String = @import("NSString.zig").NSString;
pub const Array = @import("NSArray.zig").NSArray;
pub const Dictionary = @import("NSDictionary.zig").NSDictionary;
pub const Number = @import("NSNumber.zig").NSNumber;
pub const Data = @import("NSData.zig").NSData;
pub const MutableData = @import("NSMutableData.zig").NSMutableData;

test {
    std.testing.refAllDecls(@This());
}
