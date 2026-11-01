const std = @import("std");
const c = @import("../ffi/root.zig").c;
const Time = @import("Time.zig").Time;

pub const SampleTimingInfo = extern struct {
    duration: Time,
    presentationTimeStamp: Time,
    decodeTimeStamp: Time,
};

test "SampleTimingInfo matches CMSampleTimingInfo layout" {
    try std.testing.expectEqual(@sizeOf(c.CMSampleTimingInfo), @sizeOf(SampleTimingInfo));
    try std.testing.expectEqual(@alignOf(c.CMSampleTimingInfo), @alignOf(SampleTimingInfo));
    inline for (.{ "duration", "presentationTimeStamp", "decodeTimeStamp" }) |field| {
        try std.testing.expectEqual(@offsetOf(c.CMSampleTimingInfo, field), @offsetOf(SampleTimingInfo, field));
    }
}
