const std = @import("std");

pub const ffi = @import("ffi/root.zig");
pub const c = ffi.c;

const src = @import("src/root.zig");
pub const BlockBuffer = src.CMBlockBuffer;
pub const Time = src.CMTime;
pub const SampleBuffer = src.CMSampleBuffer;
pub const SampleTimingInfo = src.CMSampleTimingInfo;

test {
    std.testing.refAllDecls(@This());
}
