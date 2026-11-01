const c = @import("../ffi/root.zig").c;

const resolveOpaqueType = @import("resolveOpaqueType.zig").resolveOpaqueType;

pub fn h(comptime T: type) type {
    const O = resolveOpaqueType(T, c);
    return struct {
        pub const cast = @import("cast.zig").cast(T, O);

        pub fn retain(self: *const T) *const T {
            _ = c.CFRetain(@ptrCast(self));
            return self;
        }

        pub fn release(self: *const T) void {
            c.CFRelease(@ptrCast(self));
        }
    };
}
