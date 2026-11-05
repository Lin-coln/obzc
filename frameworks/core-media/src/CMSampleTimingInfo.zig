const std = @import("std");
const c = @import("macos").c;
const cm = @import("root.zig");

pub const CMSampleTimingInfo = extern struct {
    duration: cm.Time,
    presentationTimeStamp: cm.Time,
    decodeTimeStamp: cm.Time,
};

test "SampleTimingInfo matches CMSampleTimingInfo layout" {
    try std.testing.expectEqual(@sizeOf(c.CMSampleTimingInfo), @sizeOf(CMSampleTimingInfo));
    try std.testing.expectEqual(@alignOf(c.CMSampleTimingInfo), @alignOf(CMSampleTimingInfo));
    inline for (.{ "duration", "presentationTimeStamp", "decodeTimeStamp" }) |field| {
        try std.testing.expectEqual(@offsetOf(c.CMSampleTimingInfo, field), @offsetOf(CMSampleTimingInfo, field));
    }
}
