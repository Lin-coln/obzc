const c = @import("../ffi/root.zig").c;

pub const CFBoolean = opaque {
    const Self = @This();

    pub fn getValue(self: *const Self) bool {
        return self.raw().?.CFBooleanGetValue() != 0;
    }

    fn raw(self: *const Self) c.CFBooleanRef {
        return @ptrCast(self);
    }
};
