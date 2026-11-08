const vn = @import("root.zig");

pub const VNRectangleObservation = opaque {
    pub const Mixin = VNRectangleObservationMixin;

    const Self = @This();
    const h = Mixin(Self);

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
};

fn VNRectangleObservationMixin(comptime T: type) type {
    return struct {
        const h = vn.DetectedObjectObservation.Mixin(T);

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
        pub const respondsToSelector = h.respondsToSelector;
        pub const confidence = h.confidence;
        pub const boundingBox = h.boundingBox;
        pub const observationWithBoundingBox = h.observationWithBoundingBox;
    };
}
