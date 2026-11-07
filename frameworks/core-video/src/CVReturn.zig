const c = @import("macos").c;
const std = @import("std");

pub inline fn kCVReturn(value: enum {
    Success,
    First,
    Error,
    InvalidArgument,
    AllocationFailed,
    Unsupported,
    InvalidDisplay,
    DisplayLinkAlreadyRunning,
    DisplayLinkNotRunning,
    DisplayLinkCallbacksNotSet,
    InvalidPixelFormat,
    InvalidSize,
    InvalidPixelBufferAttributes,
    PixelBufferNotOpenGLCompatible,
    PixelBufferNotMetalCompatible,
    WouldExceedAllocationThreshold,
    PoolAllocationFailed,
    InvalidPoolAttributes,
    Retry,
    Last,
}) c.CVReturn {
    return switch (value) {
        inline else => |result| @field(c, "kCVReturn" ++ @tagName(result)),
    };
}

test "CoreVideo return codes match the SDK" {
    try std.testing.expectEqual(@as(c.CVReturn, c.kCVReturnSuccess), kCVReturn(.Success));
    try std.testing.expectEqual(@as(c.CVReturn, c.kCVReturnPixelBufferNotMetalCompatible), kCVReturn(.PixelBufferNotMetalCompatible));
    try std.testing.expectEqual(@as(c.CVReturn, c.kCVReturnRetry), kCVReturn(.Retry));
}
