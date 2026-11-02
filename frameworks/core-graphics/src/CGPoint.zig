const c = @import("macos").c;

pub const CGPoint = extern struct {
    x: c.CGFloat,
    y: c.CGFloat,
};
