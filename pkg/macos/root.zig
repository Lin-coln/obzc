pub const ffi = @import("ffi/root.zig");
pub const c = ffi.c;

test {
    @import("std").testing.refAllDecls(@This());
}
