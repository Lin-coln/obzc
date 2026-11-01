const c = @import("../ffi/root.zig").c;

pub const CMBlockBuffer = opaque {
    const Self = @This();

    pub fn getDataLength(self: *Self) usize {
        return self.raw().?.CMBlockBufferGetDataLength();
    }

    pub fn copyDataBytes(self: *Self, offset: usize, data: []u8) bool {
        return self.raw().?.CMBlockBufferCopyDataBytes(offset, data.len, data.ptr) == 0;
    }

    fn raw(self: *Self) c.CMBlockBufferRef {
        return @ptrCast(self);
    }
};
