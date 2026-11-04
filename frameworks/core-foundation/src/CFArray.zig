const c = @import("macos").c;

pub const CFArray = opaque {
    pub const Mixin = CFArrayMixin;
    pub const With = CFArray_With;

    const Self = @This();
    const h = Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const getCount = h.getCount;
    pub const getValueAtIndex = h.getValueAtIndex;
};

fn CFArrayMixin(comptime T: type) type {
    return struct {
        const h = @import("CFType.zig").CFType.Mixin(T);

        pub const retain = h.retain;
        pub const release = h.release;

        pub fn getCount(self: *const T) usize {
            return @intCast(c.CFArrayGetCount(raw(self)));
        }

        pub fn getValueAtIndex(self: *const T, index: usize) ?*const T {
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
        pub const getCount = h.getCount;

        pub fn getValueAtIndex(self: *const Self, index: usize) ?*const T {
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
    try std.testing.expectEqual(@as(usize, 1), array.getCount());
    const retained = array.retain();
    retained.release();

    const Booleans = CFArray_With(@import("CFBoolean.zig").CFBoolean);
    const booleans: *const Booleans = @ptrCast(raw_array);
    try std.testing.expect(booleans.getValueAtIndex(0).?.getValue());
}
