const ns = @import("foundation");
const SCWindow = @import("SCWindow.zig").SCWindow;

pub const SCContentFilter = opaque {
    const Self = @This();
    const h = ns.Object.Mixin(Self);

    pub const _encoding = h._encoding;
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;

    /// Creates an owned filter for the supplied desktop-independent window.
    pub fn init(window: *SCWindow) *Self {
        return h._call(h._cls(null).alloc(Self), *Self, "initWithDesktopIndependentWindow:", .{window});
    }
};
