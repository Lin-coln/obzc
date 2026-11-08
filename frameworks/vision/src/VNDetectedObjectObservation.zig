const cg = @import("core-graphics");
const vn = @import("root.zig");

pub const VNDetectedObjectObservation = opaque {
    pub const Mixin = VNDetectedObjectObservationMixin;

    const Self = @This();
    const h = Mixin(Self);

    pub const _encoding = h._encoding;
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondToSelector;
    pub const confidence = h.confidence;
    pub const boundingBox = h.boundingBox;
    pub const observationWithBoundingBox = h.observationWithBoundingBox;
};

fn VNDetectedObjectObservationMixin(comptime T: type) type {
    return struct {
        const h = vn.Observation.Mixin(T);

        pub const _encoding = h._encoding;
        pub const _cls = h._cls;
        pub const _call = h._call;
        pub const _p = h._p;

        pub const retain = h.retain;
        pub const release = h.release;
        pub const equal = h.equal;
        pub const hash = h.hash;
        pub const class = h.class;
        pub const isKindOfClass = h.isKindOfClass;
        pub const respondsToSelector = h.respondToSelector;
        pub const confidence = h.confidence;

        pub const boundingBox = _p("boundingBox", cg.Rect).getter;

        pub fn observationWithBoundingBox(bounds: cg.Rect) *T {
            return _cls(null)._call(*T, "observationWithBoundingBox:", .{bounds});
        }
    };
}
