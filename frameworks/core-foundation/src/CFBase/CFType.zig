const c = @import("macos").c;
const cf = @import("../root.zig");

pub const CFType = opaque {
    pub const Mixin = CFTypeMixin;

    const Self = @This();
    const h = Mixin(Self);
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const getTypeID = h.getTypeID;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;
};

fn CFTypeMixin(comptime T: type) type {
    return struct {
        pub fn retain(self: *const T) *const T {
            return @ptrCast(c.CFRetain(raw(self)).?);
        }

        pub fn release(self: *const T) void {
            c.CFRelease(raw(self));
        }

        pub fn equal(self: *const T, other: *const T) bool {
            return c.CFEqual(raw(self), raw(other)) != 0;
        }

        pub fn getTypeID(self: *const T) c.CFTypeID {
            return c.CFGetTypeID(raw(self));
        }

        pub fn hash(self: *const T) c.CFHashCode {
            return c.CFHash(raw(self));
        }

        pub fn getRetainCount(self: *const T) isize {
            return @intCast(c.CFGetRetainCount(raw(self)));
        }

        fn raw(self: *const T) c.CFTypeRef {
            if (@TypeOf(self) != *T and
                @TypeOf(self) != *const T)
            {
                @compileError("raw receiver must point to " ++ @typeName(T));
            }
            return @ptrCast(self);
        }
    };
}

test "CFType methods work on generic and concrete references" {
    const std = @import("std");
    const boolean: *const cf.Boolean = @ptrCast(c.kCFBooleanTrue.?);
    const generic: *const CFType = @ptrCast(boolean);

    try std.testing.expectEqual(c.CFBooleanGetTypeID(), cf.Boolean.getTypeID());
    try std.testing.expectEqual(cf.Boolean.getTypeID(), generic.getTypeID());
    try std.testing.expectEqual(c.CFHash(@ptrCast(boolean)), boolean.hash());
    try std.testing.expectEqual(boolean.hash(), generic.hash());
    try std.testing.expect(boolean.getRetainCount() > 0);
    try std.testing.expect(generic.getRetainCount() > 0);
}
