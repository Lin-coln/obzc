const c = @import("macos").c;
const cf = @import("core-foundation");
const CGPoint = @import("CGPoint.zig").CGPoint;
const CGSize = @import("CGSize.zig").CGSize;

pub const CGRect = extern struct {
    const Self = @This();
    origin: CGPoint,
    size: CGSize,

    pub fn makeWithDictionaryRepresentation(dict: *const cf.Dictionary) ?Self {
        var rect: Self = undefined;
        if (!c.CGRectMakeWithDictionaryRepresentation(@ptrCast(dict), @ptrCast(&rect)))
            return null;
        return rect;
    }
};
