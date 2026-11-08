const core2 = @import("core2");
const std = @import("std");
const z = @import("macos").z;
const ns = @import("foundation");
const cg = @import("core-graphics");
const vn = @import("root.zig");
const VNRecognizedText = @import("VNRecognizedText.zig").VNRecognizedText;

pub const VNRecognizedTextObservation = opaque {
    const Self = @This();
    const h = vn.RectangleObservation.Mixin(Self);

    pub const _encoding = h._encoding;
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;

    pub const confidence = h.confidence;
    pub const boundingBox = h.boundingBox;
    pub const observationWithBoundingBox = h.observationWithBoundingBox;

    /// Returns a borrowed array with at most the requested number of candidates.
    pub fn topCandidates(self: *Self, count: z.NSUInteger) *ns.Array.With(VNRecognizedText) {
        return h._call(self, *ns.Array.With(VNRecognizedText), "topCandidates:", .{count});
    }
};

test "VNRecognizedTextObservation: read a bounding box and confidence" {
    const pool = core2.AutoReleasePool.create();
    defer pool.release();
    const bounds: cg.Rect = .{
        .origin = .{ .x = 0.125, .y = 0.25 },
        .size = .{ .width = 0.5, .height = 0.5 },
    };
    const observation = VNRecognizedTextObservation.observationWithBoundingBox(bounds);

    try std.testing.expect(observation.isKindOfClass(observation.class()));

    const actual = observation.boundingBox();
    try std.testing.expectEqual(bounds.origin.x, actual.origin.x);
    try std.testing.expectEqual(bounds.origin.y, actual.origin.y);
    try std.testing.expectEqual(bounds.size.width, actual.size.width);
    try std.testing.expectEqual(bounds.size.height, actual.size.height);
    try std.testing.expectEqual(@as(f32, 1), observation.confidence());
}
