const helpers = @import("../helpers/root.zig");

pub const CFBoolean = opaque {
    const Self = @This();
    const h = helpers.h(Self);
    const cast = h.cast;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn getValue(self: *const Self) bool {
        return self.cast().CFBooleanGetValue() != 0;
    }
};
