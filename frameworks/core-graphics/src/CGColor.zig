const c = @import("macos").c;
const cf = @import("core-foundation");

pub const CGColor = opaque {
    const Self = @This();

    pub fn getConst(color: kCGColor) ?*Self {
        const cgColor = c.CGColorGetConstantColor(@ptrCast(color.unwrap())) orelse return null;
        return @ptrCast(cgColor);
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
