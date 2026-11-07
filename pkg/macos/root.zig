pub const ffi = @import("ffi/root.zig");
pub const c = ffi.c;
pub const z = ffi.z;

test {
    @import("std").testing.refAllDecls(@This());
}
