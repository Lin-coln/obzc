const std = @import("std");

pub const Color = @import("Color.zig").Color;
pub const Rect = @import("Rect.zig").Rect;
const c = @import("../ffi/root.zig").c;

pub fn preflightScreenCaptureAccess() bool {
    return c.CGPreflightScreenCaptureAccess();
}

pub fn requestScreenCaptureAccess() bool {
    return c.CGRequestScreenCaptureAccess();
}

test {
    std.testing.refAllDecls(@This());
}
