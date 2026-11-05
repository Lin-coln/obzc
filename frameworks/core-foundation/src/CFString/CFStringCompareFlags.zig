const c = @import("macos").c;

pub const kCFStringCompareFlags = enum {
    CaseInsensitive,
    Backwards,
    Anchored,
    Nonliteral,
    Localized,
    Numerically,
    DiacriticInsensitive,
    WidthInsensitive,
    ForcedOrdering,

    const Self = @This();

    pub fn create(flags: []const Self) c.CFStringCompareFlags {
        var raw: c.CFStringCompareFlags = 0;
        for (flags) |flag| {
            raw |= switch (flag) {
                inline else => |value| @field(c, "kCFCompare" ++ @tagName(value)),
            };
        }
        return raw;
    }
};

test "comparison flags combine into the Core Foundation bitmask" {
    const std = @import("std");
    try std.testing.expectEqual(
        @as(c.CFStringCompareFlags, c.kCFCompareCaseInsensitive | c.kCFCompareNumerically),
        kCFStringCompareFlags.create(&.{ .CaseInsensitive, .Numerically }),
    );
    try std.testing.expectEqual(@as(c.CFStringCompareFlags, 0), kCFStringCompareFlags.create(&.{}));
}
