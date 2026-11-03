const std = @import("std");
const c = @import("macos").c;
const core = @import("core");
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
    pub const metadata = core.Metadata.obj;
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
    pub fn pixelFormat(self: *Self) cv.kPixelFormat {
        return cv.kPixelFormat.wrap(h.call(self, c.OSType, "pixelFormat", .{}));
    }

    pub fn setPixelFormat(self: *Self, format: cv.kPixelFormat) void {
        h.call(self, void, "setPixelFormat:", .{format.unwrap()});
    }
    pub const captureResolution = h.prop("captureResolution", SCCaptureResolutionType).getter;
    pub const setCaptureResolution = h.prop("captureResolution", SCCaptureResolutionType).setter;
    pub fn colorSpaceName(self: *Self) ?cg.kColorSpace {
        const name = h.call(self, ?*const cf.String, "colorSpaceName", .{}) orelse return null;
        return cg.kColorSpace.wrap(name);
    }

    pub fn setColorSpaceName(self: *Self, name: ?cg.kColorSpace) void {
        const string: ?*const cf.String = if (name) |value| value.unwrap() else null;
        h.call(self, void, "setColorSpaceName:", .{string});
    }
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

    configuration.setPixelFormat(.RGBA64Half);
    configuration.setCaptureResolution(.nominal);
    try std.testing.expectEqual(cv.kPixelFormat.RGBA64Half, configuration.pixelFormat());
    try std.testing.expectEqual(SCCaptureResolutionType.nominal, configuration.captureResolution());

    configuration.setColorSpaceName(.DisplayP3);
    const color = cg.Color.getConst(.Clear).?;
    const retained = color.retain();
    defer retained.release();
    configuration.setBackgroundColor(color);
    try std.testing.expect(configuration.colorSpaceName().? == .DisplayP3);
    try std.testing.expect(color.equal(configuration.backgroundColor().?));
}
