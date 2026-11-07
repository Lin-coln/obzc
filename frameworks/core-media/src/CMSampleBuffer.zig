const c = @import("macos").c;
const cf = @import("core-foundation");
const cv = @import("core-video");
const cm = @import("root.zig");

pub const CMSampleBuffer = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn isValid(self: *Self) bool {
        return c.CMSampleBufferIsValid(self.raw()) != 0;
    }

    pub fn getImageBuffer(self: *Self) ?*cv.ImageBuffer {
        const buffer = c.CMSampleBufferGetImageBuffer(self.raw()) orelse return null;
        return @ptrCast(buffer);
    }

    pub fn getSampleAttachmentsArray(self: *Self, create: bool) ?*const cf.Array.With(cf.Dictionary) {
        const arr = c.CMSampleBufferGetSampleAttachmentsArray(self.raw(), @intFromBool(create)) orelse return null;
        return @ptrCast(arr);
    }

    pub fn getDataBuffer(self: *Self) ?*cm.BlockBuffer {
        const buffer = c.CMSampleBufferGetDataBuffer(self.raw()) orelse return null;
        return @ptrCast(buffer);
    }

    pub fn getFormatDescription(self: *Self) ?*const cm.VideoFormatDescription {
        const format = c.CMSampleBufferGetFormatDescription(self.raw()) orelse return null;
        return @ptrCast(format);
    }

    fn raw(self: *Self) c.CMSampleBufferRef {
        return @ptrCast(self);
    }
};
