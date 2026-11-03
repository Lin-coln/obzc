const c = @import("macos").c;
const CVBuffer = @import("CVBuffer.zig").CVBuffer;

pub const CVImageBuffer = opaque {
    pub const Mixin = CVImageBufferMixin;

    const Self = @This();
    const h = Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub const getEncodedSize = h.getEncodedSize;
    pub const getDisplaySize = h.getDisplaySize;
    pub const getCleanRect = h.getCleanRect;
};

fn CVImageBufferMixin(comptime T: type) type {
    return struct {
        const h = CVBuffer.Mixin(T);

        pub const retain = h.retain;
        pub const release = h.release;

        pub fn getEncodedSize(self: *T) c.CGSize {
            return c.CVImageBufferGetEncodedSize(raw(self));
        }

        pub fn getDisplaySize(self: *T) c.CGSize {
            return c.CVImageBufferGetDisplaySize(raw(self));
        }

        pub fn getCleanRect(self: *T) c.CGRect {
            return c.CVImageBufferGetCleanRect(raw(self));
        }

        fn raw(self: *T) c.CVImageBufferRef {
            return @ptrCast(self);
        }
    };
}
