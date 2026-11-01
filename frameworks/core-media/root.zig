const std = @import("std");

pub const ffi = @import("ffi/root.zig");
pub const c = ffi.c;

const src = @import("src/root.zig");
pub const Time = src.Time;
pub const SampleBuffer = src.SampleBuffer;
pub const SampleTimingInfo = src.SampleTimingInfo;

test {
    std.testing.refAllDecls(@This());
}
