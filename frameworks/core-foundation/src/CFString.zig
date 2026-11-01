const helpers = @import("../helpers/root.zig");

pub const CFString = opaque {
    const Self = @This();
    const h = helpers.h(Self);
    const cast = h.cast;

    pub const retain = h.retain;
    pub const release = h.release;
};
