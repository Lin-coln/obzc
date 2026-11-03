const c = @import("macos").c;

pub const CVBuffer = opaque {
    pub const Mixin = CVBufferMixin;

    const Self = @This();
    const h = Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
};

fn CVBufferMixin(comptime T: type) type {
    return struct {
        pub fn retain(self: *T) *T {
            return @ptrCast(c.CVBufferRetain(raw(self)).?);
        }

        pub fn release(self: *T) void {
            c.CVBufferRelease(raw(self));
        }

        fn raw(self: *T) c.CVBufferRef {
            return @ptrCast(self);
        }
    };
}
