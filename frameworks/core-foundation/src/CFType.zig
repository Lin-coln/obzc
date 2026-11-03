const c = @import("macos").c;

pub const CFType = opaque {
    pub const Mixin = CFTypeMixin;

    const Self = @This();
    const h = Mixin(Self);
    pub const retain = h.retain;
    pub const release = h.release;
};

fn CFTypeMixin(comptime T: type) type {
    return struct {
        pub fn retain(self: *const T) *const T {
            return @ptrCast(c.CFRetain(raw(self)).?);
        }

        pub fn release(self: *const T) void {
            c.CFRelease(raw(self));
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
