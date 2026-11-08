const std = @import("std");
const z = @import("macos").z;
const cf = @import("core-foundation");
const ns = @import("root.zig");

pub const NSArray = opaque {
    pub const Mixin = NSArrayMixin;
    pub const With = NSArray_With;

    const Self = @This();
    const h = Mixin(Self);

    pub const _encoding = h._encoding;
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;
    pub const count = h.count;
    pub const objectAtIndex = h.objectAtIndex;

    pub fn asCFArray(self: *const Self) *const cf.Array {
        return @ptrCast(self);
    }
};

fn NSArrayMixin(comptime T: type) type {
    return struct {
        const h = ns.Object.Mixin(T);

        pub const _encoding = h._encoding;
        pub const _cls = h._cls;
        pub const _call = h._call;
        pub const _p = h._p;

        pub const retain = h.retain;
        pub const release = h.release;
        pub const equal = h.equal;
        pub const hash = h.hash;
        pub const class = h.class;
        pub const isKindOfClass = h.isKindOfClass;
        pub const respondsToSelector = h.respondToSelector;

        pub fn count(self: *const T) z.NSUInteger {
            return _call(self, z.NSUInteger, "count", .{});
        }

        /// The returned object is borrowed from the array.
        pub fn objectAtIndex(self: *T, index: z.NSUInteger) *ns.Object {
            return _call(self, *ns.Object, "objectAtIndex:", .{index});
        }
    };
}

pub fn NSArray_With(comptime T: type) type {
    return opaque {
        const Self = @This();
        const h = NSArrayMixin(Self);

        pub const _encoding = h._encoding;
        pub const retain = h.retain;
        pub const release = h.release;
        pub const equal = h.equal;
        pub const hash = h.hash;
        pub const class = h.class;
        pub const isKindOfClass = h.isKindOfClass;
        pub const respondsToSelector = h.respondsToSelector;
        pub const count = h.count;

        pub fn asCFArray(self: *const Self) *const cf.Array.With(T) {
            return @ptrCast(self);
        }

        pub fn init(objects: []const *T) *Self {
            const allocated = h._cls(NSArray).alloc(Self);
            return h._call(allocated, ?*Self, "initWithObjects:count:", .{ objects.ptr, @as(z.NSUInteger, @intCast(objects.len)) }).?;
        }

        /// The returned object is borrowed from the array.
        pub fn objectAtIndex(self: *Self, index: z.NSUInteger) *T {
            return h._call(self, *T, "objectAtIndex:", .{index});
        }
    };
}

test "NSArray: create and read objects" {
    const first = ns.String.init("first").?;
    defer first.release();
    const second = ns.String.init("second").?;
    defer second.release();

    const objects = [_]*ns.String{ first, second };
    const array = NSArray.With(ns.String).init(&objects);
    defer array.release();

    try std.testing.expectEqual(2, array.count());
    try std.testing.expectEqual(@as(z.NSUInteger, 2), ns.Object.Mixin(NSArray.With(ns.String))._p("count", z.NSUInteger).getter(array));
    try std.testing.expect(array.equal(array));
    try std.testing.expect(array.isKindOfClass(array.class()));
    try std.testing.expectEqualStrings("first", array.objectAtIndex(0).utf8String());
    try std.testing.expectEqualStrings("second", array.objectAtIndex(1).utf8String());

    const cf_array = array.asCFArray();
    try std.testing.expectEqual(2, cf_array.count());
    try std.testing.expectEqual(@intFromPtr(first), @intFromPtr(cf_array.at(0).?));

    const untyped: *NSArray = @ptrCast(array);
    try std.testing.expectEqual(2, untyped.count());
    try std.testing.expectEqual(@intFromPtr(first), @intFromPtr(untyped.objectAtIndex(0)));
}

test "NSArray: initialize an empty array" {
    const array = NSArray.With(ns.String).init(&.{});
    defer array.release();

    try std.testing.expectEqual(0, array.count());
}
