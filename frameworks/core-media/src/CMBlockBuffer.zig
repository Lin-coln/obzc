pub const CMBlockBuffer = opaque {
    const Self = @This();
    const h = @import("macos").helpers.ref(Self);
    const raw = h.raw;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn getDataLength(self: *Self) usize {
        return self.raw().CMBlockBufferGetDataLength();
    }

    pub fn copyDataBytes(self: *Self, offset: usize, data: []u8) bool {
        return self.raw().CMBlockBufferCopyDataBytes(offset, data.len, data.ptr) == 0;
    }
};
