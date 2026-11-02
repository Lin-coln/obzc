const c = @import("macos").c;
const cf = @import("core-foundation");
const cv = @import("core-video");
const CMBlockBuffer = @import("CMBlockBuffer.zig").CMBlockBuffer;

pub const CMSampleBuffer = opaque {
    const Self = @This();
    const h = @import("macos").helpers.ref(Self);
    const raw = h.raw;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn isValid(self: *Self) bool {
        return c.CMSampleBufferIsValid(self.raw()) != 0;
    }

    pub fn getImageBuffer(self: *Self) ?*cv.Buffer {
        const buffer = c.CMSampleBufferGetImageBuffer(self.raw()) orelse return null;
        return @ptrCast(buffer);
    }

    pub fn getSampleAttachmentsArray(self: *Self, create: bool) ?*const cf.Array(cf.Dictionary(anyopaque, anyopaque)) {
        const arr = c.CMSampleBufferGetSampleAttachmentsArray(self.raw(), @intFromBool(create)) orelse return null;
        return @ptrCast(arr);
    }

    pub fn getDataBuffer(self: *Self) ?*CMBlockBuffer {
        const buffer = c.CMSampleBufferGetDataBuffer(self.raw()) orelse return null;
        return @ptrCast(buffer);
    }
};
