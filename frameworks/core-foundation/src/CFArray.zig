const c = @import("macos").c;
const cf = @import("root.zig");

pub const CFArray = opaque {
    pub const Mixin = CFArrayMixin;
    pub const With = CFArray_With;

    const Self = @This();
    const h = Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const getTypeID = h.getTypeID;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;
    pub const count = h.count;
    pub const at = h.at;
};

fn CFArrayMixin(comptime T: type) type {
    return struct {
        const h = cf.Type.Mixin(T);

        pub const retain = h.retain;
        pub const release = h.release;
        pub const hash = h.hash;
        pub const getRetainCount = h.getRetainCount;

        pub fn getTypeID() c.CFTypeID {
            return c.CFArrayGetTypeID();
        }

        pub fn count(self: *const T) usize {
            return @intCast(c.CFArrayGetCount(raw(self)));
        }

        pub fn at(self: *const T, index: usize) ?*const T {
            const value = c.CFArrayGetValueAtIndex(raw(self), @intCast(index)) orelse return null;
            return @ptrCast(value);
        }

        fn raw(self: *const T) c.CFArrayRef {
            return @ptrCast(self);
        }
    };
}

pub fn CFArray_With(comptime T: type) type {
    return opaque {
        const Self = @This();
        const h = CFArrayMixin(Self);

        pub const retain = h.retain;
        pub const release = h.release;
        pub const getTypeID = h.getTypeID;
        pub const hash = h.hash;
        pub const getRetainCount = h.getRetainCount;
        pub const count = h.count;

        pub fn at(self: *const Self, index: usize) ?*const T {
            const value = c.CFArrayGetValueAtIndex(h.raw(self), @intCast(index)) orelse return null;
            return @ptrCast(value);
        }
    };
}

test "CFArray uses CFType mixin" {
    const std = @import("std");
    var values = [_]?*const anyopaque{c.kCFBooleanTrue};
    const raw_array = c.CFArrayCreate(null, &values, values.len, &c.kCFTypeArrayCallBacks) orelse return error.OutOfMemory;
    defer c.CFRelease(raw_array);

    const array: *const CFArray = @ptrCast(raw_array);
    try std.testing.expectEqual(@as(usize, 1), array.count());
    const retained = array.retain();
    retained.release();

    const Booleans = CFArray_With(cf.Boolean);
    const booleans: *const Booleans = @ptrCast(raw_array);
    try std.testing.expect(booleans.at(0).?.val());
}
