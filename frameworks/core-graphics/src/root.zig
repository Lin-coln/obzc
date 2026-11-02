const std = @import("std");

pub const Color = @import("CGColor.zig").CGColor;
pub const Rect = @import("CGRect.zig").CGRect;
const c = @import("macos").c;

pub fn preflightScreenCaptureAccess() bool {
    return c.CGPreflightScreenCaptureAccess();
}

pub fn requestScreenCaptureAccess() bool {
    return c.CGRequestScreenCaptureAccess();
}

test {
    std.testing.refAllDecls(@This());
}
