const c = @import("../ffi/root.zig").c;

pub const Array = opaque {
    const Self = @This();

    pub fn getCount(self: *const Self) c.CFIndex {
        return self.raw().?.CFArrayGetCount();
    }

    pub fn getValueAtIndex(self: *const Self, index: c.CFIndex, comptime T: type) ?*const T {
        const value = self.raw().?.CFArrayGetValueAtIndex(index) orelse return null;
        return @ptrCast(value);
    }

    fn raw(self: *const Self) c.CFArrayRef {
        return @ptrCast(self);
    }
};
