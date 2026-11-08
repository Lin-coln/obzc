const ns = @import("foundation");
const z = @import("macos").z;
const mtl = @import("root.zig");

pub const MTLRenderPassAttachmentDescriptor = opaque {
    pub const Mixin = MTLRenderPassAttachmentDescriptorMixin;

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
    pub const texture = h.texture;
    pub const setTexture = h.setTexture;
    pub const loadAction = h.loadAction;
    pub const setLoadAction = h.setLoadAction;
    pub const storeAction = h.storeAction;
    pub const setStoreAction = h.setStoreAction;
};

fn MTLRenderPassAttachmentDescriptorMixin(comptime T: type) type {
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

        pub const texture = _p("texture", ?*mtl.Texture).getter;
        pub const setTexture = _p("texture", ?*mtl.Texture).setter;
        pub const loadAction = _p("loadAction", z.MTLLoadAction).getter;
        pub const setLoadAction = _p("loadAction", z.MTLLoadAction).setter;
        pub const storeAction = _p("storeAction", z.MTLStoreAction).getter;
        pub const setStoreAction = _p("storeAction", z.MTLStoreAction).setter;
    };
}
