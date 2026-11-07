const core = @import("core");
const e = core.ffi.metadata.e;

/// An Objective-C object conforming to the SCStreamDelegate protocol.
pub const SCStreamDelegate = opaque {
    pub const _encoding = e(.obj);
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;
};
