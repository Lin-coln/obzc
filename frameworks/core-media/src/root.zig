const std = @import("std");

pub const CMTime = @import("CMTime.zig").CMTime;
pub const CMSampleBuffer = @import("CMSampleBuffer.zig").CMSampleBuffer;
pub const CMSampleTimingInfo = @import("CMSampleTimingInfo.zig").CMSampleTimingInfo;

test {
    std.testing.refAllDecls(@This());
}
