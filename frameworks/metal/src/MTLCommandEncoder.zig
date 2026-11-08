const ns = @import("foundation");

pub const MTLCommandEncoder = opaque {
    pub const Mixin = MTLCommandEncoderMixin;

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
    pub const endEncoding = h.endEncoding;
};

fn MTLCommandEncoderMixin(comptime T: type) type {
    return struct {
        const h = ns.Object.Mixin(T);

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

        pub fn endEncoding(self: *T) void {
            _call(self, void, "endEncoding", .{});
        }
    };
}
