const AutoReleasePool = @import("runtime").AutoReleasePool;
const std = @import("std");
const z = @import("macos").z;
const ns = @import("foundation");
const cg = @import("core-graphics");
const vn = @import("root.zig");
const VNRecognizedTextObservation = @import("VNRecognizedTextObservation.zig").VNRecognizedTextObservation;

pub const VNRequestTextRecognitionLevel = enum(z.VNRequestTextRecognitionLevel) {
    accurate = z.VNRequestTextRecognitionLevelAccurate,
    fast = z.VNRequestTextRecognitionLevelFast,
};

pub const VNRecognizeTextRequest = opaque {
    const Self = @This();
    const h = vn.ImageBasedRequest.Mixin(Self);

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

    pub const recognitionLevel = h._p("recognitionLevel", VNRequestTextRecognitionLevel).getter;
    pub const setRecognitionLevel = h._p("recognitionLevel", VNRequestTextRecognitionLevel).setter;
    pub const recognitionLanguages = h._p("recognitionLanguages", *ns.Array.With(ns.String)).getter;
    pub const setRecognitionLanguages = h._p("recognitionLanguages", *ns.Array.With(ns.String)).setter;
    pub const usesLanguageCorrection = h._p("usesLanguageCorrection", bool).getter;
    pub const setUsesLanguageCorrection = h._p("usesLanguageCorrection", bool).setter;
    pub const minimumTextHeight = h._p("minimumTextHeight", f32).getter;
    pub const setMinimumTextHeight = h._p("minimumTextHeight", f32).setter;
    pub const regionOfInterest = h.regionOfInterest;
    pub const setRegionOfInterest = h.setRegionOfInterest;

    /// Results are borrowed and remain null until the request has produced results.
    pub const results = h._p("results", ?*ns.Array.With(VNRecognizedTextObservation)).getter;
};

test "VNRecognizeTextRequest: configure recognition and region of interest" {
    const pool = AutoReleasePool.create();
    defer pool.release();
    const request = VNRecognizeTextRequest.new();
    defer request.release();

    try std.testing.expect(request.equal(request));
    try std.testing.expect(request.isKindOfClass(request.class()));

    request.setRecognitionLevel(.fast);
    request.setUsesLanguageCorrection(false);
    request.setMinimumTextHeight(0.125);
    const region: cg.Rect = .{
        .origin = .{ .x = 0.125, .y = 0.25 },
        .size = .{ .width = 0.5, .height = 0.5 },
    };
    request.setRegionOfInterest(region);

    try std.testing.expectEqual(.fast, request.recognitionLevel());
    try std.testing.expectEqual(false, request.usesLanguageCorrection());
    try std.testing.expectEqual(@as(f32, 0.125), request.minimumTextHeight());
    const actual = request.regionOfInterest();
    try std.testing.expectEqual(region.origin.x, actual.origin.x);
    try std.testing.expectEqual(region.origin.y, actual.origin.y);
    try std.testing.expectEqual(region.size.width, actual.size.width);
    try std.testing.expectEqual(region.size.height, actual.size.height);
    try std.testing.expect(request.results() == null);

    const language = ns.String.init("en-US").?;
    defer language.release();
    const languages = ns.Array.With(ns.String).init(&.{language});
    defer languages.release();
    request.setRecognitionLanguages(languages);

    const actual_languages = request.recognitionLanguages();
    try std.testing.expectEqual(1, actual_languages.count());
    try std.testing.expectEqualStrings("en-US", actual_languages.at(0).utf8String());
}
