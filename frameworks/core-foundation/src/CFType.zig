const c = @import("macos").c;

pub const CFType = opaque {
    pub const Mixin = CFTypeMixin;

    const Self = @This();
    const h = Mixin(Self);
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
};

fn CFTypeMixin(comptime T: type) type {
    return struct {
        pub fn retain(self: *const T) *const T {
            return @ptrCast(c.CFRetain(raw(self)).?);
        }

        pub fn release(self: *const T) void {
            c.CFRelease(raw(self));
        }

        pub fn equal(self: *const T, other: *const T) bool {
            return c.CFEqual(raw(self), raw(other)) != 0;
        }

        fn raw(self: *const T) c.CFTypeRef {
            if (@TypeOf(self) != *T and
                @TypeOf(self) != *const T)
            {
                @compileError("raw receiver must point to " ++ @typeName(T));
            }
            return @ptrCast(self);
        }
    };
}
