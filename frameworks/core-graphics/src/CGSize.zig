const c = @import("macos").c;

pub const CGSize = extern struct {
    width: c.CGFloat,
    height: c.CGFloat,
};
