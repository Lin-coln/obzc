const c = @import("macos").c;

pub const CFBoolean = opaque {
    const Self = @This();
    const h = @import("CFType.zig").CFType.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn getValue(self: *const Self) bool {
        return c.CFBooleanGetValue(self.raw()) != 0;
    }

    fn raw(self: *const Self) c.CFBooleanRef {
        return @ptrCast(self);
    }
};

pub const kCFBoolean = enum {
    True,
    False,
    const Self = @This();
    pub fn unwrap(self: Self) c.CFBooleanRef {
        return switch (self) {
            .True => c.kCFBooleanTrue,
            .False => c.kCFBooleanFalse,
        };
    }
};
