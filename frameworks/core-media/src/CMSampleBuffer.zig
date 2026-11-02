const cf = @import("core-foundation");
const cv = @import("core-video");
const c = @import("macos").c;
const CMBlockBuffer = @import("CMBlockBuffer.zig").CMBlockBuffer;

pub const CMSampleBuffer = opaque {
    const Self = @This();

    pub fn isValid(self: *Self) bool {
        return self.raw().?.CMSampleBufferIsValid() != 0;
    }

    pub fn getImageBuffer(self: *Self) ?*cv.Buffer {
        const buffer = self.raw().?.CMSampleBufferGetImageBuffer() orelse return null;
        return @ptrCast(buffer);
    }

    pub fn getSampleAttachmentsArray(self: *Self, create: bool) ?*const cf.Array(cf.Dictionary(anyopaque, anyopaque)) {
        const arr = self.raw().?.CMSampleBufferGetSampleAttachmentsArray(@intFromBool(create)) orelse return null;
        return @ptrCast(arr);
    }

    pub fn getDataBuffer(self: *Self) ?*CMBlockBuffer {
        const buffer = self.raw().?.CMSampleBufferGetDataBuffer() orelse return null;
        return @ptrCast(buffer);
    }

    fn raw(self: *Self) c.CMSampleBufferRef {
        return @ptrCast(self);
    }
};
