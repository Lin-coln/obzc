const core = @import("core");
const e = core.ffi.metadata.e;
const MTLTexture = @import("MTLTexture.zig").MTLTexture;

pub const MTLBlitCommandEncoder = opaque {
    pub const _encoding = e(.obj);
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn copyFromTexture(self: *Self, source: *MTLTexture, destination: *MTLTexture) void {
        h.call(self, void, "copyFromTexture:toTexture:", .{ source, destination });
    }

    pub fn endEncoding(self: *Self) void {
        h.call(self, void, "endEncoding", .{});
    }
};
