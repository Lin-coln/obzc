const std = @import("std");

pub const Time = @import("CMTime.zig").CMTime;
pub const BlockBuffer = @import("CMBlockBuffer.zig").CMBlockBuffer;
pub const SampleBuffer = @import("CMSampleBuffer.zig").CMSampleBuffer;
pub const SampleTimingInfo = @import("CMSampleTimingInfo.zig").CMSampleTimingInfo;

pub const kSampleAttachmentKey = @import("CMSample.zig").kCMSampleAttachmentKey;

test {
    std.testing.refAllDecls(@This());
}
