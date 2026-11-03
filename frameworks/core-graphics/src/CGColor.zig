const c = @import("macos").c;

pub const CGColor = opaque {
    const Self = @This();

    pub fn getConst(color: kCGColor) ?*Self {
        const cgColor = c.CGColorGetConstantColor(color.unwrap()) orelse return null;
        return @ptrCast(cgColor);
    }
};

pub const kCGColor = enum {
    White,
    Black,
    Clear,
    const Self = @This();
    pub fn unwrap(self: Self) c.CFStringRef {
        return switch (self) {
            .White => c.kCGColorWhite,
            .Black => c.kCGColorBlack,
            .Clear => c.kCGColorClear,
        };
    }
};
