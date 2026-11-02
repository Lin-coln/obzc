const c = @import("macos").c;

pub const CFBoolean = opaque {
    const Self = @This();
    const h = @import("macos").helpers.ref(Self);
    const raw = h.raw;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn getValue(self: *const Self) bool {
        return c.CFBooleanGetValue(self.raw()) != 0;
    }
};
