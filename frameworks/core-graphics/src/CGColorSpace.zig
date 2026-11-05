const c = @import("macos").c;
const cf = @import("core-foundation");

pub const CGColorSpace = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
};

pub inline fn kCGColorSpace(value: enum {
    DisplayP3,
}) *const cf.String {
    const raw: c.CFStringRef = switch (value) {
        inline else => |name| @field(c, "kCGColorSpace" ++ @tagName(name)),
    };
    return @ptrCast(raw.?);
}

test "color space name resolves to the Core Graphics constant" {
    const std = @import("std");
    try std.testing.expect(kCGColorSpace(.DisplayP3).equal(@ptrCast(c.kCGColorSpaceDisplayP3.?)));
}
