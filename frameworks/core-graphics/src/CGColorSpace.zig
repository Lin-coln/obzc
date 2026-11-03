const c = @import("macos").c;
const cf = @import("core-foundation");

pub const kCGColorSpace = enum {
    DisplayP3,

    const Self = @This();

    pub fn unwrap(self: Self) c.CFStringRef {
        return switch (self) {
            .DisplayP3 => c.kCGColorSpaceDisplayP3,
        };
    }

    pub fn wrap(name: *const cf.String) ?Self {
        if (name.equal(@ptrCast(c.kCGColorSpaceDisplayP3))) return .DisplayP3;
        return null;
    }
};

pub const CGColorSpace = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
};
