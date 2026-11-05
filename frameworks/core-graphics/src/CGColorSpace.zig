const c = @import("macos").c;
const cf = @import("core-foundation");

pub const kCGColorSpace = enum {
    DisplayP3,

    const Self = @This();

    pub fn unwrap(self: Self) *const cf.String {
        const raw: c.CFStringRef = switch (self) {
            inline else => |name| @field(c, "kCGColorSpace" ++ @tagName(name)),
        };
        return @ptrCast(raw.?);
    }

    pub fn fromRaw(raw: c.CFStringRef) ?Self {
        const name: *const cf.String = @ptrCast(raw orelse return null);
        return .wrap(name);
    }

    pub fn wrap(name: *const cf.String) ?Self {
        inline for (@import("std").meta.tags(Self)) |candidate| {
            if (name.equal(candidate.unwrap())) return candidate;
        }
        return null;
    }
};

pub const CGColorSpace = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
};

test "color space name converts from raw" {
    const std = @import("std");
    try std.testing.expectEqual(kCGColorSpace.DisplayP3, kCGColorSpace.fromRaw(@ptrCast(kCGColorSpace.DisplayP3.unwrap())).?);
}
