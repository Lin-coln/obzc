const c = @import("macos").c;
const cf = @import("core-foundation");
const cg = @import("root.zig");

pub const CGRect = extern struct {
    const Self = @This();
    origin: cg.Point,
    size: cg.Size,

    pub fn makeWithDictionaryRepresentation(dict: *const cf.Dictionary) ?Self {
        var rect: Self = undefined;
        if (!c.CGRectMakeWithDictionaryRepresentation(@ptrCast(dict), @ptrCast(&rect)))
            return null;
        return rect;
    }
};
