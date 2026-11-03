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
        const value: c.CFStringRef = switch (self) {
            .White => c.kCGColorWhite,
            .Black => c.kCGColorBlack,
            .Clear => c.kCGColorClear,
        };
        return @ptrCast(value.?);
    }
};
