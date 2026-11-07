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
    const h = vt.Session.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const getTypeID = h.getTypeID;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;
    pub const setProperty = h.setProperty;

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
};

fn rawTime(time: cm.Time) c.CMTime {
    return @as(*const c.CMTime, @ptrCast(&time)).*;
}

test "compression session uses the CoreMedia time layout" {
    try std.testing.expectEqual(@sizeOf(c.CMTime), @sizeOf(cm.Time));
    try std.testing.expectEqual(@alignOf(c.CMTime), @alignOf(cm.Time));
}

test "compression session accepts a callback and encodes a pixel buffer" {
    const Callback = struct {
        fn onFrame(_: ?*anyopaque, _: ?*anyopaque, _: c.OSStatus, _: c.VTEncodeInfoFlags, _: ?*cm.SampleBuffer) callconv(.c) void {}
    };

    var session: ?*VTCompressionSession = null;
    const status = VTCompressionSession.create(null, 16, 16, c.kCMVideoCodecType_H264, null, null, null, Callback.onFrame, null, &session);
    if (status != c.noErr) return error.SkipZigTest;
    const encoder = session orelse return error.SessionCreationFailed;
    defer encoder.release();
    defer encoder.invalidate();

    const retained = encoder.retain();
    defer retained.release();
    try std.testing.expect(retained.equal(encoder));
    try std.testing.expectEqual(encoder.getTypeID(), retained.getTypeID());
    const base: *vt.Session = @ptrCast(encoder);
    try std.testing.expectEqual(encoder.getTypeID(), base.getTypeID());

    const realtime: *const cf.Type = @ptrCast(cf.kBoolean(.True));
    try encoder.setProperty(vt.kCompressionPropertyKey(.RealTime), realtime);
    try base.setProperty(vt.kCompressionPropertyKey(.RealTime), realtime);
    try std.testing.expectEqual(@as(c.OSStatus, c.noErr), encoder.prepareToEncodeFrames());

    const buffer = cv.PixelBuffer.create(16, 16, cv.kPixelFormat(.BGRA32), null) orelse return error.PixelBufferCreationFailed;
    defer buffer.release();
    const time = cm.Time.make(0, 30);
    try std.testing.expectEqual(@as(c.OSStatus, c.noErr), encoder.encodeFrame(@ptrCast(buffer), time, cm.Time.make(1, 30), null, null, null));
    try std.testing.expectEqual(@as(c.OSStatus, c.noErr), encoder.completeFrames(time));
}
