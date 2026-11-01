const std = @import("std");

pub const ffi = @import("ffi/root.zig");
pub const c = ffi.c;

const src = @import("src/root.zig");
pub const Color = src.CGColor;
pub const Rect = src.CGRect;
pub const preflightScreenCaptureAccess = src.preflightScreenCaptureAccess;
pub const requestScreenCaptureAccess = src.requestScreenCaptureAccess;

test {
    std.testing.refAllDecls(@This());
}
