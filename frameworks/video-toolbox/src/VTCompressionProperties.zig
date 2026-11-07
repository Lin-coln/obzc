const c = @import("macos").c;
const cf = @import("core-foundation");
const std = @import("std");

pub inline fn kVTCompressionPropertyKey(key: enum { RealTime, AllowFrameReordering, ProfileLevel, ExpectedFrameRate }) *const cf.String {
    return @ptrCast(@field(c, "kVTCompressionPropertyKey_" ++ @tagName(key)).?);
}

pub inline fn kVTVideoEncoderSpecification(key: enum { RequireHardwareAcceleratedVideoEncoder }) *const cf.String {
    return @ptrCast(@field(c, "kVTVideoEncoderSpecification_" ++ @tagName(key)).?);
}

pub inline fn kVTProfileLevel(level: enum { H264_High_AutoLevel }) *const cf.String {
    return @ptrCast(@field(c, "kVTProfileLevel_" ++ @tagName(level)).?);
}

test "compression property constants match the SDK" {
    try std.testing.expectEqual(@intFromPtr(c.kVTCompressionPropertyKey_RealTime.?), @intFromPtr(kVTCompressionPropertyKey(.RealTime)));
    try std.testing.expectEqual(@intFromPtr(c.kVTCompressionPropertyKey_AllowFrameReordering.?), @intFromPtr(kVTCompressionPropertyKey(.AllowFrameReordering)));
    try std.testing.expectEqual(@intFromPtr(c.kVTCompressionPropertyKey_ProfileLevel.?), @intFromPtr(kVTCompressionPropertyKey(.ProfileLevel)));
    try std.testing.expectEqual(@intFromPtr(c.kVTCompressionPropertyKey_ExpectedFrameRate.?), @intFromPtr(kVTCompressionPropertyKey(.ExpectedFrameRate)));
    try std.testing.expectEqual(@intFromPtr(c.kVTVideoEncoderSpecification_RequireHardwareAcceleratedVideoEncoder.?), @intFromPtr(kVTVideoEncoderSpecification(.RequireHardwareAcceleratedVideoEncoder)));
    try std.testing.expectEqual(@intFromPtr(c.kVTProfileLevel_H264_High_AutoLevel.?), @intFromPtr(kVTProfileLevel(.H264_High_AutoLevel)));
}
