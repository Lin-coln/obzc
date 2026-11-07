const c = @import("macos").c;
const std = @import("std");

pub const kVTEncodeInfoFlags = enum {
    Asynchronous,
    FrameDropped,

    const Self = @This();

    pub fn create(flags: []const Self) c.VTEncodeInfoFlags {
        var raw: c.VTEncodeInfoFlags = 0;
        for (flags) |flag| {
            raw |= switch (flag) {
                inline else => |value| @field(c, "kVTEncodeInfo_" ++ @tagName(value)),
            };
        }
        return raw;
    }
};

pub inline fn kVTPropertyErr(value: enum { NotSupported, ReadOnly }) c.OSStatus {
    return @field(c, "kVTProperty" ++ @tagName(value) ++ "Err");
}

test "VideoToolbox error and encode info constants match the SDK" {
    try std.testing.expectEqual(@as(c.OSStatus, c.kVTPropertyNotSupportedErr), kVTPropertyErr(.NotSupported));
    try std.testing.expectEqual(@as(c.OSStatus, c.kVTPropertyReadOnlyErr), kVTPropertyErr(.ReadOnly));
    try std.testing.expectEqual(
        @as(c.VTEncodeInfoFlags, c.kVTEncodeInfo_Asynchronous | c.kVTEncodeInfo_FrameDropped),
        kVTEncodeInfoFlags.create(&.{ .Asynchronous, .FrameDropped }),
    );
    try std.testing.expectEqual(@as(c.VTEncodeInfoFlags, 0), kVTEncodeInfoFlags.create(&.{}));
}
