const c = @import("macos").c;
const cf = @import("core-foundation");

pub const kCGColorSpace = enum {
    DisplayP3,

    const Self = @This();

    pub fn unwrap(self: Self) *const cf.String {
        const value: c.CFStringRef = switch (self) {
            .DisplayP3 => c.kCGColorSpaceDisplayP3,
        };
        return @ptrCast(value.?);
    }

    pub fn wrap(name: *const cf.String) ?Self {
        if (name.equal(Self.DisplayP3.unwrap())) return .DisplayP3;
        return null;
    }
};

pub const CGColorSpace = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
};
