const c = @import("macos").c;
const core = @import("core");
const ns = @import("foundation");
const cg = @import("core-graphics");
const SCRunningApplication = @import("SCRunningApplication.zig").SCRunningApplication;

pub const SCWindow = opaque {
    pub const metadata = core.Metadata.obj;
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn windowID(self: *Self) u32 {
        return h.call(self, u32, "windowID", .{});
    }

    pub const frame = h.prop("frame", cg.Rect).getter;
    pub const windowLayer = h.prop("windowLayer", isize).getter;
    pub const owningApplication = h.prop("owningApplication", ?*SCRunningApplication).getter;
    pub const title = h.prop("title", ?*ns.String).getter;
};
