const std = @import("std");
const c = @import("../ffi/root.zig").c;

pub const Time = extern struct {
    const Self = @This();

    value: c.CMTimeValue align(4),
    timescale: c.CMTimeScale,
    flags: c.CMTimeFlags,
    epoch: c.CMTimeEpoch align(4),

    pub fn make(value: i64, timescale: i32) Self {
        const time = c.CMTimeMake(value, timescale);
        return @as(*const Self, @ptrCast(&time)).*;
    }

    fn raw(self: Self) c.CMTime {
        return @as(*const c.CMTime, @ptrCast(&self)).*;
    }
};

test "Time matches CMTime layout" {
    try std.testing.expectEqual(@sizeOf(c.CMTime), @sizeOf(Time));
    try std.testing.expectEqual(@alignOf(c.CMTime), @alignOf(Time));
    inline for (.{ "value", "timescale", "flags", "epoch" }) |field| {
        try std.testing.expectEqual(@offsetOf(c.CMTime, field), @offsetOf(Time, field));
    }
    const time = Time.make(1, 60);
    try std.testing.expectEqual(time.value, time.raw().value);
}
