const c = @import("../ffi/root.zig").c;

const resolveOpaqueType = @import("resolveOpaqueType.zig").resolveOpaqueType;

pub fn h(comptime T: type) type {
    const O = resolveOpaqueType(T);
    return struct {
        pub const raw = @import("cast.zig").raw(T, O);

        pub fn retain(self: *const T) *const T {
            return @ptrCast(c.CFRetain(@ptrCast(self)));
        }

        pub fn release(self: *const T) void {
            c.CFRelease(@ptrCast(self));
        }
    };
}
