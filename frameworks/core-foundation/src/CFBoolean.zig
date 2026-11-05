const c = @import("macos").c;

pub const CFBoolean = opaque {
    const Self = @This();
    const h = @import("CFType.zig").CFType.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn val(self: *const Self) bool {
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

    pub fn unwrap(self: Self) *const CFBoolean {
        const value: c.CFBooleanRef = switch (self) {
            .True => c.kCFBooleanTrue,
            .False => c.kCFBooleanFalse,
        };
        return @ptrCast(value.?);
    }

    pub fn fromRaw(raw: c.CFBooleanRef) Self {
        return switch (c.CFBooleanGetValue(raw)) {
            0 => .False,
            else => .True,
        };
    }
};
