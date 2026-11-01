const c = @import("../ffi/root.zig").c;

pub const Number = opaque {
    const Self = @This();

    pub fn getValue(self: *const Self, comptime T: type) ?T {
        const number_type = if (T == f32) c.kCFNumberFloatType else @compileError("unsupported CFNumber value type");
        var value: T = undefined;
        if (self.raw().?.CFNumberGetValue(number_type, &value) == 0) return null;
        return value;
    }

    fn raw(self: *const Self) c.CFNumberRef {
        return @ptrCast(self);
    }
};
