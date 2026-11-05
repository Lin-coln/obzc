const c = @import("macos").c;
const cf = @import("core-foundation");

pub const CGColor = opaque {
    const Self = @This();

    pub fn getConst(color: kCGColor) ?*Self {
        const cgColor = c.CGColorGetConstantColor(@ptrCast(color.unwrap())) orelse return null;
        return @ptrCast(cgColor);
    }

    pub fn retain(self: *const Self) *const Self {
        return @ptrCast(c.CGColorRetain(self.raw()).?);
    }

    pub fn release(self: *const Self) void {
        c.CGColorRelease(self.raw());
    }

    pub fn equal(self: *const Self, other: *const Self) bool {
        return c.CGColorEqualToColor(self.raw(), other.raw());
    }

    fn raw(self: *const Self) c.CGColorRef {
        return @ptrCast(@constCast(self));
    }
};

pub const kCGColor = enum {
    White,
    Black,
    Clear,
    const Self = @This();
    pub fn unwrap(self: Self) *const cf.String {
        const raw: c.CFStringRef = switch (self) {
            inline else => |color| @field(c, "kCGColor" ++ @tagName(color)),
        };
        return @ptrCast(raw.?);
    }

    pub fn fromRaw(raw: c.CFStringRef) ?Self {
        const name: *const cf.String = @ptrCast(raw orelse return null);
        inline for (@import("std").meta.tags(Self)) |color| {
            if (name.equal(color.unwrap())) return color;
        }
        return null;
    }
};

test "constant color names convert from raw" {
    const std = @import("std");
    for (std.meta.tags(kCGColor)) |color| {
        try std.testing.expectEqual(color, kCGColor.fromRaw(@ptrCast(color.unwrap())).?);
    }
}
