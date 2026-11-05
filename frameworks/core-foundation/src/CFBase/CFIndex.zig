const c = @import("macos").c;

pub inline fn kCFCompare(value: enum {
    LessThan,
    EqualTo,
    GreaterThan,
}) isize {
    return switch (value) {
        inline else => |item| @field(c, "kCFCompare" ++ @tagName(item)),
    };
}

test "comparison results match Core Foundation" {
    const std = @import("std");
    try std.testing.expectEqual(@as(isize, c.kCFCompareLessThan), kCFCompare(.LessThan));
    try std.testing.expectEqual(@as(isize, c.kCFCompareEqualTo), kCFCompare(.EqualTo));
    try std.testing.expectEqual(@as(isize, c.kCFCompareGreaterThan), kCFCompare(.GreaterThan));
}
