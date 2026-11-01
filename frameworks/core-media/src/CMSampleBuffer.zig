const cf = @import("core-foundation");
const cv = @import("core-video");
const c = @import("../ffi/root.zig").c;
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

    pub fn getSampleAttachmentsArray(self: *Self, create_if_necessary: bool) ?*const cf.Array {
        const array = self.raw().?.CMSampleBufferGetSampleAttachmentsArray(@intFromBool(create_if_necessary)) orelse return null;
        return @ptrCast(array);
    }

    pub fn getDataBuffer(self: *Self) ?*CMBlockBuffer {
        const buffer = self.raw().?.CMSampleBufferGetDataBuffer() orelse return null;
        return @ptrCast(buffer);
    }

    fn raw(self: *Self) c.CMSampleBufferRef {
        return @ptrCast(self);
    }
};
