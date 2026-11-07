const std = @import("std");

pub fn resolveEncodingFromPointer(info: std.lang.Type.Pointer) ?[]const u8 {
    const T = info.child;
    switch (@typeInfo(T)) {
        .@"opaque", .@"struct" => {},
        else => return null,
    }
    if (!@hasDecl(T, "_encoding")) return null;
    return T._encoding;
}

test "resolveEncodingFromPointer reads marked opaque and struct types" {
    const Object = opaque {
        pub const _encoding = "@";
    };
    const Block = extern struct {
        pub const _encoding = "@?";
        value: u8,
    };
    const Plain = opaque {};
    const Concrete = extern struct { value: u8 };

    try std.testing.expectEqualStrings("@", comptime resolveEncodingFromPointer(@typeInfo(*Object).pointer).?);
    try std.testing.expectEqualStrings("@?", comptime resolveEncodingFromPointer(@typeInfo(*const Block).pointer).?);
    try std.testing.expectEqual(null, comptime resolveEncodingFromPointer(@typeInfo(*Plain).pointer));
    try std.testing.expectEqual(null, comptime resolveEncodingFromPointer(@typeInfo(*Concrete).pointer));
}
