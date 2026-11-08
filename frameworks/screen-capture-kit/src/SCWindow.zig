const c = @import("macos").c;
const z = @import("macos").z;
const ns = @import("foundation");
const cg = @import("core-graphics");
const SCRunningApplication = @import("SCRunningApplication.zig").SCRunningApplication;

pub const SCWindow = opaque {
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

    pub fn windowID(self: *Self) c.CGWindowID {
        return h._call(self, c.CGWindowID, "windowID", .{});
    }

    pub const frame = h._p("frame", cg.Rect).getter;
    pub const windowLayer = h._p("windowLayer", z.NSInteger).getter;
    pub const owningApplication = h._p("owningApplication", ?*SCRunningApplication).getter;
    pub const title = h._p("title", ?*ns.String).getter;
};
