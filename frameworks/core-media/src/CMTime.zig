const std = @import("std");
const c = @import("../ffi/root.zig").c;

pub const CMTime = extern struct {
    const Self = @This();

    value: c.CMTimeValue align(4),
    timescale: c.CMTimeScale,
    flags: c.CMTimeFlags,
    epoch: c.CMTimeEpoch align(4),

    pub fn make(value: i64, timescale: i32) Self {
        const time = c.CMTimeMake(value, timescale);
        return @as(*const Self, @ptrCast(&time)).*;
    }

    pub fn add(self: Self, other: Self) Self {
        const time = c.CMTimeAdd(self.raw(), other.raw());
        return @as(*const Self, @ptrCast(&time)).*;
    }

    fn raw(self: Self) c.CMTime {
        return @as(*const c.CMTime, @ptrCast(&self)).*;
    }
};

test "Time matches CMTime layout" {
    try std.testing.expectEqual(@sizeOf(c.CMTime), @sizeOf(CMTime));
    try std.testing.expectEqual(@alignOf(c.CMTime), @alignOf(CMTime));
    inline for (.{ "value", "timescale", "flags", "epoch" }) |field| {
        try std.testing.expectEqual(@offsetOf(c.CMTime, field), @offsetOf(CMTime, field));
    }
    const time = CMTime.make(1, 60);
    try std.testing.expectEqual(time.value, time.raw().value);
}

test "Time.add uses CoreMedia time arithmetic" {
    const time = CMTime.make(1, 2).add(CMTime.make(500_000_000, 1_000_000_000));
    try std.testing.expectEqual(@as(i128, time.timescale), @as(i128, time.value));
}
