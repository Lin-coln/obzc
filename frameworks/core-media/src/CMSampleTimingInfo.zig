const std = @import("std");
const c = @import("../ffi/root.zig").c;
const CMTime = @import("CMTime.zig").CMTime;

pub const CMSampleTimingInfo = extern struct {
    duration: CMTime,
    presentationTimeStamp: CMTime,
    decodeTimeStamp: CMTime,
};

test "SampleTimingInfo matches CMSampleTimingInfo layout" {
    try std.testing.expectEqual(@sizeOf(c.CMSampleTimingInfo), @sizeOf(CMSampleTimingInfo));
    try std.testing.expectEqual(@alignOf(c.CMSampleTimingInfo), @alignOf(CMSampleTimingInfo));
    inline for (.{ "duration", "presentationTimeStamp", "decodeTimeStamp" }) |field| {
        try std.testing.expectEqual(@offsetOf(c.CMSampleTimingInfo, field), @offsetOf(CMSampleTimingInfo, field));
    }
}
