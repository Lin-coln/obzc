const c = @import("../ffi/root.zig").c;

pub const Dictionary = opaque {
    const Self = @This();

    pub fn getValue(self: *const Self, key: ?*const anyopaque, comptime T: type) ?*const T {
        const value = self.raw().?.CFDictionaryGetValue(key) orelse return null;
        return @ptrCast(value);
    }

    fn raw(self: *const Self) c.CFDictionaryRef {
        return @ptrCast(self);
    }
};
