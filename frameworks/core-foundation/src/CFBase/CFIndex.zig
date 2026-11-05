const c = @import("macos").c;

pub inline fn kCFCompare(value: enum {
    LessThan,
    EqualTo,
    GreaterThan,
}) c.CFComparisonResult {
    return switch (value) {
        inline else => |item| @field(c, "kCFCompare" ++ @tagName(item)),
    };
}

test "comparison results match Core Foundation" {
    const std = @import("std");
    try std.testing.expectEqual(@as(c.CFComparisonResult, c.kCFCompareLessThan), kCFCompare(.LessThan));
    try std.testing.expectEqual(@as(c.CFComparisonResult, c.kCFCompareEqualTo), kCFCompare(.EqualTo));
    try std.testing.expectEqual(@as(c.CFComparisonResult, c.kCFCompareGreaterThan), kCFCompare(.GreaterThan));
}
