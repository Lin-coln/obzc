const std = @import("std");
const c = @import("macos").c;

pub const Color = @import("CGColor.zig").CGColor;
pub const ColorSpace = @import("CGColorSpace.zig").CGColorSpace;
pub const Point = @import("CGPoint.zig").CGPoint;
pub const Size = @import("CGSize.zig").CGSize;
pub const Rect = @import("CGRect.zig").CGRect;

// const
pub const kColor = @import("CGColor.zig").kCGColor;
pub const kColorSpace = @import("CGColorSpace.zig").kCGColorSpace;

pub fn preflightScreenCaptureAccess() bool {
    return c.CGPreflightScreenCaptureAccess();
}

pub fn requestScreenCaptureAccess() bool {
    return c.CGRequestScreenCaptureAccess();
}

test {
    std.testing.refAllDecls(@This());
}
