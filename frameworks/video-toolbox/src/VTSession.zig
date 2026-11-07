const c = @import("macos").c;
const cf = @import("core-foundation");

pub const VTSession = opaque {
    pub const Mixin = VTSessionMixin;

    const Self = @This();
    const h = Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const getTypeID = h.getTypeID;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;
    pub const setProperty = h.setProperty;
};
