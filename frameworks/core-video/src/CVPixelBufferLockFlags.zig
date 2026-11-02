const c = @import("macos").c;

pub const CVPixelBufferLockFlags = enum(c.CVPixelBufferLockFlags) {
    none = 0,
    readOnly = c.kCVPixelBufferLock_ReadOnly,
    _,
};
