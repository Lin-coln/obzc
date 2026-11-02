const std = @import("std");
const c = @import("macos").c;

pub const Color = @import("CGColor.zig").CGColor;
pub const Point = @import("CGPoint.zig").CGPoint;
pub const Size = @import("CGSize.zig").CGSize;
pub const Rect = @import("CGRect.zig").CGRect;

pub fn preflightScreenCaptureAccess() bool {
    return c.CGPreflightScreenCaptureAccess();
}

pub fn requestScreenCaptureAccess() bool {
    return c.CGRequestScreenCaptureAccess();
}

test {
    std.testing.refAllDecls(@This());
}
