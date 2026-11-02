const c = @import("macos").c;

pub const CVPixelFormat = enum(c_int) {
    @"32BGRA" = c.kCVPixelFormatType_32BGRA,
    _,
};
