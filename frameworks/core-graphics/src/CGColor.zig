const c = @import("macos").c;
const cf = @import("core-foundation");

pub const CGColor = opaque {
    const Self = @This();

    pub fn getConst(name: *const cf.String) ?*Self {
        const color = c.CGColorGetConstantColor(@ptrCast(name)) orelse return null;
        return @ptrCast(color);
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

pub inline fn kCGColor(value: enum {
    White,
    Black,
    Clear,
}) *const cf.String {
    const raw: c.CFStringRef = switch (value) {
        inline else => |color| @field(c, "kCGColor" ++ @tagName(color)),
    };
    return @ptrCast(raw.?);
}

test "constant color names resolve to colors" {
    const std = @import("std");
    inline for (.{ .White, .Black, .Clear }) |color| {
        try std.testing.expect(CGColor.getConst(kCGColor(color)) != null);
    }
}
