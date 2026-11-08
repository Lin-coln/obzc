const rt = @import("runtime");

/// The Objective-C root class declared in Foundation/NSObject.h.
pub const NSObject = opaque {
    pub const Mixin = rt.NSObjectPrototype;

    const Self = @This();

    const h = Mixin(Self);
    pub const _encoding = h._encoding;
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;

    pub fn alloc() *Self {
        return h._cls(null).alloc(Self);
    }

    pub fn new() *Self {
        return h._cls(null).new(Self);
    }

    pub fn init(self: *Self) ?*Self {
        return h._call(self, ?*Self, "init", .{});
    }
};
