const core = @import("core");
const e = core.ffi.metadata.e;

pub const MTLRenderPipelineState = opaque {
    pub const _encoding = e(.obj);
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;
};
