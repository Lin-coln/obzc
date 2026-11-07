const c = @import("macos").c;

pub inline fn kCMVideoCodecType(value: enum { H264 }) c.CMVideoCodecType {
    return @field(c, "kCMVideoCodecType_" ++ @tagName(value));
}
