const c = @import("macos").c;
const cf = @import("core-foundation");

pub const CMBlockBuffer = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn getDataLength(self: *Self) usize {
        return c.CMBlockBufferGetDataLength(self.raw());
    }

    pub fn copyDataBytes(self: *Self, offset: usize, data: []u8) bool {
        return c.CMBlockBufferCopyDataBytes(self.raw(), offset, data.len, data.ptr) == 0;
    }

    fn raw(self: *Self) c.CMBlockBufferRef {
        return @ptrCast(self);
    }
};
