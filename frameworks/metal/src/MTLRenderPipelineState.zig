const mtl = @import("root.zig");

pub const MTLRenderPipelineState = opaque {
    const Self = @This();
    const h = mtl.Allocation.Mixin(Self);

    pub const _encoding = h._encoding;

    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;
};
