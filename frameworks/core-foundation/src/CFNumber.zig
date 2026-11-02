const c = @import("macos").c;

pub const kCFNumber = enum {
    const Self = @This();
    FloatType,
    const h = @import("macos").helpers.konst(Self);
    pub const raw = h.raw;
};

pub const CFNumber = opaque {
    const Self = @This();
    const h = @import("macos").helpers.ref(Self);
    const raw = h.raw;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn getValue(self: *const Self, comptime T: type) ?T {
        const number_type = if (T == f32) kCFNumber.FloatType.raw() else @compileError("unsupported CFNumber value type");
        var value: T = undefined;
        if (c.CFNumberGetValue(self.raw(), number_type, &value) == 0) return null;
        return value;
    }
};
