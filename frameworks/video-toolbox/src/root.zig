const std = @import("std");
const c = @import("macos").c;

pub const Session = @import("VTSession.zig").VTSession;
pub const CompressionSession = @import("VTCompressionSession.zig").VTCompressionSession;
pub const CompressionOutputCallback = @import("VTCompressionSession.zig").VTCompressionOutputCallback;
pub const EncodeInfoFlags = c.VTEncodeInfoFlags;

pub const kCompressionPropertyKey = @import("VTCompressionSession.zig").kVTCompressionPropertyKey;
pub const kVideoEncoderSpecification = @import("VTCompressionSession.zig").kVTVideoEncoderSpecification;
pub const kProfileLevel = @import("VTCompressionSession.zig").kVTProfileLevel;
pub const kEncodeInfo = @import("VTCompressionSession.zig").kVTEncodeInfo;

test {
    std.testing.refAllDecls(@This());
}
