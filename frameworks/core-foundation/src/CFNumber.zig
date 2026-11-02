const c = @import("macos").c;

pub const CFNumber = opaque {
    const Self = @This();
    const h = @import("macos").helpers.h(Self);
    const raw = h.raw;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn getValue(self: *const Self, comptime T: type) ?T {
        const number_type = if (T == f32) c.kCFNumberFloatType else @compileError("unsupported CFNumber value type");
        var value: T = undefined;
        if (self.raw().CFNumberGetValue(number_type, &value) == 0) return null;
        return value;
    }
};
