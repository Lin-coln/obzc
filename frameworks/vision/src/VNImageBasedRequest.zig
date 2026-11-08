const cg = @import("core-graphics");
const vn = @import("root.zig");

pub const VNImageBasedRequest = opaque {
    pub const Mixin = VNImageBasedRequestMixin;

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
    pub const regionOfInterest = h.regionOfInterest;
    pub const setRegionOfInterest = h.setRegionOfInterest;
};

fn VNImageBasedRequestMixin(comptime T: type) type {
    return struct {
        const h = vn.Request.Mixin(T);

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

        pub const regionOfInterest = _p("regionOfInterest", cg.Rect).getter;
        pub const setRegionOfInterest = _p("regionOfInterest", cg.Rect).setter;
    };
}
