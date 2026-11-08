const std = @import("std");
const c = @import("macos").c;
const z = @import("macos").z;
const ns = @import("foundation");
const cf = @import("core-foundation");
const cg = @import("core-graphics");
const cm = @import("core-media");

/// SCCaptureResolutionType from ScreenCaptureKit/SCStream.h.
pub const SCCaptureResolutionType = enum(z.SCCaptureResolutionType) {
    automatic = z.SCCaptureResolutionAutomatic,
    best = z.SCCaptureResolutionBest,
    nominal = z.SCCaptureResolutionNominal,
};

pub const SCStreamConfiguration = opaque {
    const Self = @This();
    const h = ns.Object.Mixin(Self);

    pub const _encoding = h._encoding;
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;

    pub fn new() *Self {
        return h._cls(null).new(Self);
    }

    pub const width = h._p("width", usize).getter;
    pub const setWidth = h._p("width", usize).setter;
    pub const height = h._p("height", usize).getter;
    pub const setHeight = h._p("height", usize).setter;
    pub const queueDepth = h._p("queueDepth", z.NSInteger).getter;
    pub const setQueueDepth = h._p("queueDepth", z.NSInteger).setter;
    pub const showsCursor = h._p("showsCursor", bool).getter;
    pub const setShowsCursor = h._p("showsCursor", bool).setter;
    pub const capturesAudio = h._p("capturesAudio", bool).getter;
    pub const setCapturesAudio = h._p("capturesAudio", bool).setter;
    pub const minimumFrameInterval = h._p("minimumFrameInterval", cm.Time).getter;
    pub const setMinimumFrameInterval = h._p("minimumFrameInterval", cm.Time).setter;
    pub fn pixelFormat(self: *Self) c.OSType {
        return h._call(self, c.OSType, "pixelFormat", .{});
    }

    pub fn setPixelFormat(self: *Self, format: c.OSType) void {
        h._call(self, void, "setPixelFormat:", .{format});
    }
    pub const captureResolution = h._p("captureResolution", SCCaptureResolutionType).getter;
    pub const setCaptureResolution = h._p("captureResolution", SCCaptureResolutionType).setter;
    pub fn colorSpaceName(self: *Self) ?*const cf.String {
        return h._call(self, ?*const cf.String, "colorSpaceName", .{});
    }

    pub fn setColorSpaceName(self: *Self, name: ?*const cf.String) void {
        h._call(self, void, "setColorSpaceName:", .{name});
    }
    pub const backgroundColor = h._p("backgroundColor", ?*cg.Color).getter;
    pub const setBackgroundColor = h._p("backgroundColor", ?*cg.Color).setter;
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

    configuration.setCaptureResolution(.nominal);
    try std.testing.expectEqual(SCCaptureResolutionType.nominal, configuration.captureResolution());

    configuration.setColorSpaceName(cg.kColorSpace(.DisplayP3));
    const color = cg.Color.getConst(cg.kColor(.Clear)).?;
    const retained = color.retain();
    defer retained.release();
    configuration.setBackgroundColor(color);
    try std.testing.expect(configuration.colorSpaceName().?.equal(cg.kColorSpace(.DisplayP3)));
    try std.testing.expect(color.equal(configuration.backgroundColor().?));
}
