
pub const CFString = opaque {
    const Self = @This();
    const h = @import("macos").helpers.ref(Self);
    const raw = h.raw;

    pub const retain = h.retain;
    pub const release = h.release;
};
