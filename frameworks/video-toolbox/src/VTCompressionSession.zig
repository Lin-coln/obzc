const c = @import("macos").c;
const cf = @import("core-foundation");
const cm = @import("core-media");
const cv = @import("core-video");
const vt = @import("root.zig");
const std = @import("std");

/// The sample buffer is borrowed for the duration of the callback.
pub const VTCompressionOutputCallback = *const fn (
    output_callback_refcon: ?*anyopaque,
    source_frame_refcon: ?*anyopaque,
    status: c.OSStatus,
    info_flags: c.VTEncodeInfoFlags,
    sample_buffer: ?*cm.SampleBuffer,
) callconv(.c) void;

pub const VTCompressionSession = opaque {
    const Self = @This();

    /// The returned session is owned. Invalidate it before releasing it.
    pub fn create(
        allocator: c.CFAllocatorRef,
        width: i32,
        height: i32,
        codec_type: c.CMVideoCodecType,
        encoder_specification: ?*const cf.Dictionary,
        source_image_buffer_attributes: ?*const cf.Dictionary,
        compressed_data_allocator: c.CFAllocatorRef,
        output_callback: ?VTCompressionOutputCallback,
        output_callback_refcon: ?*anyopaque,
        session_out: *?*Self,
    ) c.OSStatus {
        return c.VTCompressionSessionCreate(
            allocator,
            width,
            height,
            codec_type,
            @ptrCast(encoder_specification),
            @ptrCast(source_image_buffer_attributes),
            compressed_data_allocator,
            @ptrCast(output_callback),
            output_callback_refcon,
            @ptrCast(session_out),
        );
    }

    pub fn setProperty(self: *Self, key: *const cf.String, value: ?*const cf.Type) c.OSStatus {
        return vt.Session.setProperty(@ptrCast(self), key, value);
    }

    pub fn prepareToEncodeFrames(self: *Self) c.OSStatus {
        return c.VTCompressionSessionPrepareToEncodeFrames(@ptrCast(self));
    }

    pub fn encodeFrame(
        self: *Self,
        image_buffer: *cv.ImageBuffer,
        presentation_time_stamp: cm.Time,
        duration: cm.Time,
        frame_properties: ?*const cf.Dictionary,
        source_frame_refcon: ?*anyopaque,
        info_flags_out: ?*c.VTEncodeInfoFlags,
    ) c.OSStatus {
        return c.VTCompressionSessionEncodeFrame(
            @ptrCast(self),
            @ptrCast(image_buffer),
            rawTime(presentation_time_stamp),
            rawTime(duration),
            @ptrCast(frame_properties),
            source_frame_refcon,
            info_flags_out,
        );
    }

    /// A nonnumeric timestamp (such as kCMTimeInvalid) completes every pending frame.
    pub fn completeFrames(self: *Self, until: cm.Time) c.OSStatus {
        return c.VTCompressionSessionCompleteFrames(@ptrCast(self), rawTime(until));
    }

    pub fn invalidate(self: *Self) void {
        c.VTCompressionSessionInvalidate(@ptrCast(self));
    }

    pub fn retain(self: *Self) *Self {
        return @ptrCast(c.CFRetain(@ptrCast(self)).?);
    }

    pub fn release(self: *Self) void {
        c.CFRelease(@ptrCast(self));
    }
};

fn rawTime(time: cm.Time) c.CMTime {
    return @as(*const c.CMTime, @ptrCast(&time)).*;
}

pub inline fn kVTCompressionPropertyKey(key: enum { RealTime, AllowFrameReordering, ProfileLevel, ExpectedFrameRate }) *const cf.String {
    return @ptrCast(@field(c, "kVTCompressionPropertyKey_" ++ @tagName(key)).?);
}

pub inline fn kVTVideoEncoderSpecification(key: enum { RequireHardwareAcceleratedVideoEncoder }) *const cf.String {
    return @ptrCast(@field(c, "kVTVideoEncoderSpecification_" ++ @tagName(key)).?);
}

pub inline fn kVTProfileLevel(level: enum { H264_High_AutoLevel }) *const cf.String {
    return @ptrCast(@field(c, "kVTProfileLevel_" ++ @tagName(level)).?);
}

pub inline fn kVTEncodeInfo(flag: enum { FrameDropped }) c.VTEncodeInfoFlags {
    return @field(c, "kVTEncodeInfo_" ++ @tagName(flag));
}

test "compression constants match the SDK" {
    try std.testing.expectEqual(@intFromPtr(c.kVTCompressionPropertyKey_RealTime.?), @intFromPtr(kVTCompressionPropertyKey(.RealTime)));
    try std.testing.expectEqual(@intFromPtr(c.kVTCompressionPropertyKey_AllowFrameReordering.?), @intFromPtr(kVTCompressionPropertyKey(.AllowFrameReordering)));
    try std.testing.expectEqual(@intFromPtr(c.kVTCompressionPropertyKey_ProfileLevel.?), @intFromPtr(kVTCompressionPropertyKey(.ProfileLevel)));
    try std.testing.expectEqual(@intFromPtr(c.kVTCompressionPropertyKey_ExpectedFrameRate.?), @intFromPtr(kVTCompressionPropertyKey(.ExpectedFrameRate)));
    try std.testing.expectEqual(@intFromPtr(c.kVTVideoEncoderSpecification_RequireHardwareAcceleratedVideoEncoder.?), @intFromPtr(kVTVideoEncoderSpecification(.RequireHardwareAcceleratedVideoEncoder)));
    try std.testing.expectEqual(@intFromPtr(c.kVTProfileLevel_H264_High_AutoLevel.?), @intFromPtr(kVTProfileLevel(.H264_High_AutoLevel)));
    try std.testing.expectEqual(@as(c.VTEncodeInfoFlags, c.kVTEncodeInfo_FrameDropped), kVTEncodeInfo(.FrameDropped));
    try std.testing.expectEqual(@sizeOf(c.CMTime), @sizeOf(cm.Time));
    try std.testing.expectEqual(@alignOf(c.CMTime), @alignOf(cm.Time));
}

test "compression session accepts a callback and encodes a pixel buffer" {
    const Callback = struct {
        fn onFrame(_: ?*anyopaque, _: ?*anyopaque, _: c.OSStatus, _: c.VTEncodeInfoFlags, _: ?*cm.SampleBuffer) callconv(.c) void {}
    };

    var session: ?*VTCompressionSession = null;
    const status = VTCompressionSession.create(null, 16, 16, c.kCMVideoCodecType_H264, null, null, null, Callback.onFrame, null, &session);
    if (status != 0) return error.SkipZigTest;
    const encoder = session orelse return error.SessionCreationFailed;
    defer encoder.release();
    defer encoder.invalidate();

    const realtime: *const cf.Type = @ptrCast(cf.kBoolean(.True));
    try std.testing.expectEqual(@as(c.OSStatus, 0), encoder.setProperty(kVTCompressionPropertyKey(.RealTime), realtime));
    try std.testing.expectEqual(@as(c.OSStatus, 0), encoder.prepareToEncodeFrames());

    const buffer = cv.PixelBuffer.create(16, 16, cv.kPixelFormat(.BGRA32), null) orelse return error.PixelBufferCreationFailed;
    defer buffer.release();
    const time = cm.Time.make(0, 30);
    try std.testing.expectEqual(@as(c.OSStatus, 0), encoder.encodeFrame(@ptrCast(buffer), time, cm.Time.make(1, 30), null, null, null));
    try std.testing.expectEqual(@as(c.OSStatus, 0), encoder.completeFrames(time));
}
