const c = @import("../ffi/root.zig").c;

pub const SampleBuffer = opaque {
    const Self = @This();

    pub fn isValid(self: *Self) bool {
        return self.raw().?.CMSampleBufferIsValid() != 0;
    }

    pub fn getImageBuffer(self: *Self) c.CVImageBufferRef {
        return self.raw().?.CMSampleBufferGetImageBuffer();
    }

    pub fn getSampleAttachmentsArray(self: *Self, create_if_necessary: bool) c.CFArrayRef {
        return self.raw().?.CMSampleBufferGetSampleAttachmentsArray(@intFromBool(create_if_necessary));
    }

    fn raw(self: *Self) c.CMSampleBufferRef {
        return @ptrCast(self);
    }
};
