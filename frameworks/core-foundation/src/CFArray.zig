const c = @import("../ffi/root.zig").c;
const helpers = @import("../helpers/root.zig");

pub fn CFArray(comptime T: type) type {
    return opaque {
        const Self = @This();
        const h = helpers.h(Self);
        const cast = h.cast;

        pub const retain = h.retain;
        pub const release = h.release;

        pub fn getCount(self: *const Self) c.CFIndex {
            return self.cast().CFArrayGetCount();
        }

        pub fn getValueAtIndex(self: *const Self, index: c.CFIndex) ?*const T {
            const value = self.cast().CFArrayGetValueAtIndex(index) orelse return null;
            return @ptrCast(value);
        }
    };
}
