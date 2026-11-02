const c = @import("macos").c;

pub const kCGColor = enum {
    const Self = @This();
    Clear,
    const k = @import("macos").helpers.k(Self);
    pub const raw = k.raw;
};

pub const CGColor = opaque {
    const Self = @This();

    pub fn getConstantColor(color: kCGColor) ?*Self {
        const cgColor = c.CGColorGetConstantColor(color.raw()) orelse return null;
        return @ptrCast(cgColor);
    }
};
