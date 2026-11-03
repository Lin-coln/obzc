const c = @import("macos").c;

pub const CFArray = opaque {
    pub const Mixin = CFArrayMixin;
    const Self = @This();
    const h = Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const getCount = h.getCount;
    pub const getValueAtIndex = h.getValueAtIndex;
};

fn CFArrayMixin(comptime T: type) type {
    return struct {
        const h = @import("CFType.zig").CFType.Mixin(T);

        pub const retain = h.retain;
        pub const release = h.release;

        pub fn getCount(self: *const T) c.CFIndex {
            return c.CFArrayGetCount(raw(self));
        }

        pub fn getValueAtIndex(self: *const T, index: c.CFIndex) ?*const T {
            const value = c.CFArrayGetValueAtIndex(raw(self), index) orelse return null;
            return @ptrCast(value);
        }

        fn raw(self: *const T) c.CFArrayRef {
            // ...
        }
    };
}

pub fn CFArray_With(comptime T: type) type {
    return opaque {
        const Self = @This();
        const h = CFArrayMixin(Self);

        pub const retain = h.retain;
        pub const release = h.release;
        pub const getCount = h.getCount;

        pub fn getValueAtIndex() {}
    };
}
