const std = @import("std");
const core = @import("core");
const Metadata = core.Metadata;
const cf = @import("core-foundation");
const cg = @import("core-graphics");
const cm = @import("core-media");
const cv = @import("core-video");

/// SCCaptureResolutionType from ScreenCaptureKit/SCStream.h.
pub const SCCaptureResolutionType = enum(isize) {
    automatic = 0,
    best = 1,
    nominal = 2,
};

pub const SCStreamConfiguration = opaque {
    pub const metadata = Metadata.obj;
    const Self = @This();
    const h = core.h(Self);

    pub const new = h.cls.new;
    pub const retain = h.retain;
    pub const release = h.release;

    pub const width = h.prop("width", usize).getter;
    pub const setWidth = h.prop("width", usize).setter;
    pub const height = h.prop("height", usize).getter;
    pub const setHeight = h.prop("height", usize).setter;
    pub const queueDepth = h.prop("queueDepth", isize).getter;
    pub const setQueueDepth = h.prop("queueDepth", isize).setter;
    pub const showsCursor = h.prop("showsCursor", bool).getter;
    pub const setShowsCursor = h.prop("showsCursor", bool).setter;
    pub const capturesAudio = h.prop("capturesAudio", bool).getter;
    pub const setCapturesAudio = h.prop("capturesAudio", bool).setter;
    pub const minimumFrameInterval = h.prop("minimumFrameInterval", cm.Time).getter;
    pub const setMinimumFrameInterval = h.prop("minimumFrameInterval", cm.Time).setter;
    pub const pixelFormat = h.prop("pixelFormat", cv.c.OSType).getter;
    pub const setPixelFormat = h.prop("pixelFormat", cv.c.OSType).setter;
    pub const captureResolution = h.prop("captureResolution", SCCaptureResolutionType).getter;
    pub const setCaptureResolution = h.prop("captureResolution", SCCaptureResolutionType).setter;
    /// Borrowed CoreFoundation references.
    pub const colorSpaceName = h.prop("colorSpaceName", ?*const cf.String).getter;
    pub const setColorSpaceName = h.prop("colorSpaceName", ?*const cf.String).setter;
    pub const backgroundColor = h.prop("backgroundColor", ?*cg.Color).getter;
    pub const setBackgroundColor = h.prop("backgroundColor", ?*cg.Color).setter;
};

test "SCStreamConfiguration: configure video and audio properties" {
    const configuration = SCStreamConfiguration.new();
    defer configuration.release();

    configuration.setWidth(1280);
    configuration.setHeight(720);
    configuration.setQueueDepth(4);
    configuration.setShowsCursor(false);
    configuration.setCapturesAudio(true);

    try std.testing.expectEqual(1280, configuration.width());
    try std.testing.expectEqual(720, configuration.height());
    try std.testing.expectEqual(4, configuration.queueDepth());
    try std.testing.expectEqual(false, configuration.showsCursor());
    try std.testing.expectEqual(true, configuration.capturesAudio());

    configuration.setShowsCursor(true);
    configuration.setCapturesAudio(false);
    try std.testing.expectEqual(true, configuration.showsCursor());
    try std.testing.expectEqual(false, configuration.capturesAudio());
}

test "SCStreamConfiguration: time, pixel format, resolution and color properties" {
    const configuration = SCStreamConfiguration.new();
    defer configuration.release();

    const interval = cm.Time.make(1, 60);
    configuration.setMinimumFrameInterval(interval);
    const actual = configuration.minimumFrameInterval();
    try std.testing.expectEqual(interval.value, actual.value);
    try std.testing.expectEqual(interval.timescale, actual.timescale);
    try std.testing.expectEqual(interval.flags, actual.flags);
    try std.testing.expectEqual(interval.epoch, actual.epoch);

    configuration.setPixelFormat(cv.c.kCVPixelFormatType_64RGBAHalf);
    configuration.setCaptureResolution(.nominal);
    try std.testing.expectEqual(@as(cv.c.OSType, cv.c.kCVPixelFormatType_64RGBAHalf), configuration.pixelFormat());
    try std.testing.expectEqual(SCCaptureResolutionType.nominal, configuration.captureResolution());

    configuration.setColorSpaceName(@ptrCast(cg.c.kCGColorSpaceDisplayP3));
    const color = cg.Color.clear();
    configuration.setBackgroundColor(color);
    try std.testing.expect(cf.c.CFEqual(@ptrCast(cg.c.kCGColorSpaceDisplayP3), @ptrCast(configuration.colorSpaceName())) != 0);
    try std.testing.expect(cg.c.CGColorEqualToColor(@ptrCast(color), @ptrCast(configuration.backgroundColor())));
}
