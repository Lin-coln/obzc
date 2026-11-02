pub const kCFBoolean = enum {
    const Self = @This();
    True,
    False,
    const h = @import("macos").helpers.konst(Self);
    pub const raw = h.raw;
};

pub const CFBoolean = opaque {
    const Self = @This();
    const h = @import("macos").helpers.ref(Self);
    const raw = h.raw;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn getValue(self: *const Self) bool {
        return self.raw().CFBooleanGetValue() != 0;
    }
};
