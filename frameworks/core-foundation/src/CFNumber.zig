const c = @import("../ffi/root.zig").c;
const helpers = @import("../helpers/root.zig");

pub const CFNumber = opaque {
    const Self = @This();
    const h = helpers.h(Self);
    const cast = h.cast;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn getValue(self: *const Self, comptime T: type) ?T {
        const number_type = if (T == f32) c.kCFNumberFloatType else @compileError("unsupported CFNumber value type");
        var value: T = undefined;
        if (self.cast().CFNumberGetValue(number_type, &value) == 0) return null;
        return value;
    }
};
