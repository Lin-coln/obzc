const c = @import("macos").c;

pub const CFBoolean = opaque {
    const Self = @This();
    const h = @import("CFBase/CFType.zig").CFType.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;

    pub fn getTypeID() c.CFTypeID {
        return c.CFBooleanGetTypeID();
    }

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
        const raw: c.CFBooleanRef = switch (self) {
            inline else => |value| @field(c, "kCFBoolean" ++ @tagName(value)),
        };
        return @ptrCast(raw.?);
    }

    pub fn fromRaw(raw: c.CFBooleanRef) Self {
        return switch (c.CFBooleanGetValue(raw)) {
            0 => .False,
            else => .True,
        };
    }
};
