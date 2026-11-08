const std = @import("std");
const z = @import("macos").z;
const ns = @import("root.zig");

pub const NSDictionary = opaque {
    pub const Mixin = NSDictionaryMixin;
    pub const With = NSDictionary_With;

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
    pub const objectForKey = h.objectForKey;

    pub fn new() *Self {
        return h._cls()._call(*Self, "new", .{});
    }
};

fn NSDictionaryMixin(comptime T: type) type {
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

        /// Returns a borrowed value, or null when the key is absent.
        pub fn objectForKey(self: *T, key: *ns.Object) ?*ns.Object {
            return _call(self, ?*ns.Object, "objectForKey:", .{key});
        }
    };
}

pub fn NSDictionary_With(comptime Key: type, comptime Value: type) type {
    return opaque {
        const Self = @This();
        const h = NSDictionaryMixin(Self);

        pub const _encoding = h._encoding;
        pub const retain = h.retain;
        pub const release = h.release;
        pub const equal = h.equal;
        pub const hash = h.hash;
        pub const class = h.class;
        pub const isKindOfClass = h.isKindOfClass;
        pub const respondsToSelector = h.respondToSelector;
        pub const count = h.count;

        pub fn new() *Self {
            return @ptrCast(NSDictionary.new());
        }

        /// Copies the keys and retains the values. Keys must conform to NSCopying.
        pub fn init(objects: []const *Value, keys: []const *Key) *Self {
            std.debug.assert(objects.len == keys.len);
            const base = ns.Object.Mixin(NSDictionary);
            const allocated = base._cls()._call(*Self, "alloc", .{});
            return h._call(allocated, *Self, "initWithObjects:forKeys:count:", .{ objects.ptr, keys.ptr, @as(z.NSUInteger, @intCast(objects.len)) });
        }

        /// Returns a borrowed value, or null when the key is absent.
        pub fn objectForKey(self: *Self, key: *Key) ?*Value {
            return h._call(self, ?*Value, "objectForKey:", .{key});
        }
    };
}

test "NSDictionary: new and init create empty dictionaries" {
    const dictionary = NSDictionary.With(ns.String, ns.String).new();
    defer dictionary.release();
    const key = ns.String.init("missing").?;
    defer key.release();

    try std.testing.expectEqual(0, dictionary.count());
    try std.testing.expect(dictionary.objectForKey(key) == null);

    const initialized = NSDictionary.With(ns.String, ns.String).init(&.{}, &.{});
    defer initialized.release();
    try std.testing.expectEqual(0, initialized.count());
    try std.testing.expect(initialized.objectForKey(key) == null);
}

test "NSDictionary: init and objectForKey preserve key-value pairs" {
    const dictionary = initialized: {
        const first_key = ns.String.init("first dictionary key").?;
        defer first_key.release();
        const second_key = ns.String.init("second dictionary key").?;
        defer second_key.release();
        const first_value = ns.Number.init(z.NSInteger, 42);
        defer first_value.release();
        const second_value = ns.Number.init(z.NSInteger, 7);
        defer second_value.release();

        break :initialized NSDictionary.With(ns.String, ns.Number).init(&.{ first_value, second_value }, &.{ first_key, second_key });
    };
    defer dictionary.release();

    const first_key = ns.String.init("first dictionary key").?;
    defer first_key.release();
    const second_key = ns.String.init("second dictionary key").?;
    defer second_key.release();
    const missing_key = ns.String.init("missing").?;
    defer missing_key.release();

    try std.testing.expectEqual(2, dictionary.count());
    try std.testing.expect(dictionary.equal(dictionary));
    try std.testing.expect(dictionary.isKindOfClass(dictionary.class()));
    try std.testing.expectEqual(42, dictionary.objectForKey(first_key).?.as(z.NSInteger));
    try std.testing.expectEqual(7, dictionary.objectForKey(second_key).?.as(z.NSInteger));
    try std.testing.expect(dictionary.objectForKey(missing_key) == null);

    const untyped: *NSDictionary = @ptrCast(dictionary);
    try std.testing.expectEqual(2, untyped.count());
    try std.testing.expectEqual(@intFromPtr(dictionary.objectForKey(first_key).?), @intFromPtr(untyped.objectForKey(@ptrCast(first_key)).?));
}
