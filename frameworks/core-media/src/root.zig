const std = @import("std");

pub const Time = @import("CMTime.zig").CMTime;
pub const BlockBuffer = @import("CMBlockBuffer.zig").CMBlockBuffer;
pub const SampleBuffer = @import("CMSampleBuffer.zig").CMSampleBuffer;
pub const SampleTimingInfo = @import("CMSampleTimingInfo.zig").CMSampleTimingInfo;
pub const VideoFormatDescription = @import("CMVideoFormatDescription.zig").CMVideoFormatDescription;

pub const kSampleAttachmentKey = @import("CMSample.zig").kCMSampleAttachmentKey;
pub const kTime = @import("CMTime.zig").kCMTime;
pub const kVideoCodecType = @import("CMVideoCodecType.zig").kCMVideoCodecType;

test {
    std.testing.refAllDecls(@This());
}
