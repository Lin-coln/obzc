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
        return self.raw().CMSampleBufferIsValid() != 0;
    }

    pub fn getImageBuffer(self: *Self) ?*cv.Buffer {
        const buffer = self.raw().CMSampleBufferGetImageBuffer() orelse return null;
        return @ptrCast(buffer);
    }

    pub fn getSampleAttachmentsArray(self: *Self, create: bool) ?*const cf.Array(cf.Dictionary(anyopaque, anyopaque)) {
        const arr = self.raw().CMSampleBufferGetSampleAttachmentsArray(@intFromBool(create)) orelse return null;
        return @ptrCast(arr);
    }

    pub fn getDataBuffer(self: *Self) ?*CMBlockBuffer {
        const buffer = self.raw().CMSampleBufferGetDataBuffer() orelse return null;
        return @ptrCast(buffer);
    }
};
