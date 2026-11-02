const std = @import("std");

pub const Buffer = @import("CVBuffer.zig").CVBuffer;
pub const PixelBufferLockFlags = @import("CVPixelBufferLockFlags.zig").CVPixelBufferLockFlags;
pub const PixelFormat = @import("CVPixelFormat.zig").CVPixelFormat;

pub const k = struct {
    pub const PixelBuffer = @import("CVBuffer.zig").kCVPixelBuffer;
};

test {
    std.testing.refAllDecls(@This());
}
