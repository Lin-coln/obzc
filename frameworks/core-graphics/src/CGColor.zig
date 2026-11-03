const c = @import("macos").c;

const kCGColor = enum {
    const Self = @This();
    White,
    Black,
    Clear,
    fn raw(self: Self) c.CFStringRef {
        return switch (self) {
            .White => c.kCGColorWhite,
            .Black => c.kCGColorBlack,
            .Clear => c.kCGColorClear,
        };
    }
};

pub const CGColor = opaque {
    const Self = @This();

    pub fn getConst(color: kCGColor) ?*Self {
        const cgColor = c.CGColorGetConstantColor(color.raw()) orelse return null;
        return @ptrCast(cgColor);
    }
};
