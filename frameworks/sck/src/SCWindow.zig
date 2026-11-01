const core = @import("core");
const Metadata = core.Metadata;
const ns = @import("foundation");
const cg = @import("core-graphics");
const SCRunningApplication = @import("SCRunningApplication.zig").SCRunningApplication;

pub const SCWindow = opaque {
    pub const metadata = Metadata.obj;
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub const windowID = h.prop("windowID", cg.c.CGWindowID).getter;
    pub const frame = h.prop("frame", cg.Rect).getter;
    pub const windowLayer = h.prop("windowLayer", isize).getter;
    pub const owningApplication = h.prop("owningApplication", ?*SCRunningApplication).getter;
    pub const title = h.prop("title", ?*ns.String).getter;
};
