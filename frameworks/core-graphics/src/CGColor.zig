const c = @import("../ffi/root.zig").c;

pub const CGColor = opaque {
    const Self = @This();

    pub fn clear() ?*Self {
        const color = c.CGColorGetConstantColor(c.kCGColorClear) orelse return null;
        return @ptrCast(color);
    }
};
