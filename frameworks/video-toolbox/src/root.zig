const std = @import("std");

pub const Session = @import("VTSession.zig").VTSession;
pub const CompressionSession = @import("VTCompressionSession.zig").VTCompressionSession;
pub const CompressionOutputCallback = @import("VTCompressionSession.zig").VTCompressionOutputCallback;
pub const kEncodeInfoFlags = @import("VTErrors.zig").kVTEncodeInfoFlags;

pub const kPropertyErr = @import("VTErrors.zig").kVTPropertyErr;
pub const kCompressionPropertyKey = @import("VTCompressionProperties.zig").kVTCompressionPropertyKey;
pub const kVideoEncoderSpecification = @import("VTCompressionProperties.zig").kVTVideoEncoderSpecification;
pub const kProfileLevel = @import("VTCompressionProperties.zig").kVTProfileLevel;

test {
    std.testing.refAllDecls(@This());
}
