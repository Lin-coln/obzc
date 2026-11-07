const std = @import("std");
const c = @import("macos").c;

pub const CMTime = extern struct {
    const Self = @This();

    value: c.CMTimeValue align(4),
    timescale: c.CMTimeScale,
    flags: c.CMTimeFlags,
    epoch: c.CMTimeEpoch align(4),

    pub fn make(value: i64, timescale: i32) Self {
        return wrap(c.CMTimeMake(value, timescale));
    }

    pub fn add(self: Self, other: Self) Self {
        return wrap(c.CMTimeAdd(self.raw(), other.raw()));
    }

    fn raw(self: Self) c.CMTime {
        return @as(*const c.CMTime, @ptrCast(&self)).*;
    }

    fn wrap(value: c.CMTime) Self {
        return @as(*const Self, @ptrCast(&value)).*;
    }
};

pub inline fn kCMTime(value: enum { Invalid }) CMTime {
    const raw: c.CMTime = switch (value) {
        .Invalid => c.kCMTimeInvalid,
    };
    return @as(*const CMTime, @ptrCast(&raw)).*;
}

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

test "kCMTime exposes CoreMedia time constants" {
    const invalid = kCMTime(.Invalid);
    try std.testing.expectEqual(c.kCMTimeInvalid.flags, invalid.flags);
    try std.testing.expectEqual(c.kCMTimeInvalid.timescale, invalid.timescale);
}
