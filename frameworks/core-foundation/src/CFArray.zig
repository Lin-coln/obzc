const c = @import("macos").c;

pub fn CFArray(comptime T: type) type {
    return opaque {
        const Self = @This();
        const h = @import("macos").helpers.ref(Self);
        const raw = h.raw;

        pub const retain = h.retain;
        pub const release = h.release;

        pub fn getCount(self: *const Self) c.CFIndex {
            return c.CFArrayGetCount(self.raw());
        }

        pub fn getValueAtIndex(self: *const Self, index: c.CFIndex) ?*const T {
            const value = c.CFArrayGetValueAtIndex(self.raw(), index) orelse return null;
            return @ptrCast(value);
        }
    };
}
