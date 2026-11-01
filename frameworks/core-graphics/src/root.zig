const std = @import("std");

pub const CGColor = @import("CGColor.zig").CGColor;
pub const CGRect = @import("CGRect.zig").CGRect;
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
