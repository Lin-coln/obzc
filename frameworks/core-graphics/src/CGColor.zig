const c = @import("macos").c;

pub const kCGColor = enum {
    const Self = @This();
    Clear,
    const h = @import("macos").helpers.konst(Self);
    pub const raw = h.raw;
};

pub const CGColor = opaque {
    const Self = @This();

    pub fn getConstantColor(color: kCGColor) ?*Self {
        const cgColor = c.CGColorGetConstantColor(color.raw()) orelse return null;
        return @ptrCast(cgColor);
    }
};
