const c = @import("../ffi/root.zig").c;
const cf = @import("core-foundation");

pub const CGRect = extern struct {
    const Self = @This();
    origin: c.CGPoint,
    size: c.CGSize,

    pub fn makeWithDictionaryRepresentation(dict: *const cf.Dictionary) ?Self {
        var rect: Self = undefined;
        if (!c.CGRectMakeWithDictionaryRepresentation(@ptrCast(dict), @ptrCast(&rect)))
            return null;
        return rect;
    }
};
