const std = @import("std");
const c = @import("macos").c;

pub const CFDictionary = opaque {
    pub const Mixin = CFDictionaryMixin;
    pub const WithKey = CFDictionary_WithKey;

    const Self = @This();
    const h = Mixin(Self);

    pub const createMutable = h.createMutable;

    pub const retain = h.retain;
    pub const release = h.release;
    pub const getTypeID = h.getTypeID;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;
    pub const set = h.set;
    pub const get = h.get;
};

fn CFDictionaryMixin(comptime T: type) type {
    return struct {
        const h = @import("CFType.zig").CFType.Mixin(T);

        pub fn createMutable() ?*T {
            const dict = c.CFDictionaryCreateMutable(null, 0, &c.kCFTypeDictionaryKeyCallBacks, &c.kCFTypeDictionaryValueCallBacks) orelse return null;
            return @ptrCast(dict);
        }

        pub const retain = h.retain;
        pub const release = h.release;
        pub const hash = h.hash;
        pub const getRetainCount = h.getRetainCount;

        pub fn getTypeID() c.CFTypeID {
            return c.CFDictionaryGetTypeID();
        }

        pub fn set(self: *T, key: *const anyopaque, value: *const anyopaque) void {
            c.CFDictionarySetValue(raw(self), key, value);
        }

        pub fn get(self: *const T, key: *const anyopaque) ?*const anyopaque {
            return c.CFDictionaryGetValue(raw(self), key);
        }

        fn raw(self: anytype) switch (@TypeOf(self)) {
            *T => c.CFMutableDictionaryRef,
            *const T => c.CFDictionaryRef,
            else => @compileError("raw receiver must point to " ++ @typeName(T)),
        } {
            return @ptrCast(self);
        }
    };
}

pub fn CFDictionary_WithKey(comptime K: type) type {
    return opaque {
        const Self = @This();
        const h = CFDictionaryMixin(Self);

        pub const createMutable = h.createMutable;

        pub const retain = h.retain;
        pub const release = h.release;
        pub const getTypeID = h.getTypeID;
        pub const hash = h.hash;
        pub const getRetainCount = h.getRetainCount;

        pub fn set(self: *Self, key: *const K, value: *const anyopaque) void {
            h.set(self, key, value);
        }

        pub fn get(self: *const Self, key: *const K, comptime V: type) ?*const V {
            const value = h.get(self, key) orelse return null;
            return @ptrCast(value);
        }
    };
}

test "mutable dictionary stores a value" {
    const Boolean = @import("CFBoolean.zig").CFBoolean;
    const dict = CFDictionary.createMutable().?;
    defer dict.release();

    const key: *const Boolean = @ptrCast(c.kCFBooleanTrue.?);
    const stored: *const Boolean = @ptrCast(c.kCFBooleanFalse.?);
    dict.set(key, stored);
    const read_only: *const CFDictionary = dict;
    const value = read_only.get(key).?;
    try std.testing.expectEqual(@intFromPtr(stored), @intFromPtr(value));
}

test "dictionary with typed keys stores a value" {
    const Boolean = @import("CFBoolean.zig").CFBoolean;
    const BooleanKeys = CFDictionary.WithKey(Boolean);
    const dict = BooleanKeys.createMutable().?;
    defer dict.release();

    const key: *const Boolean = @ptrCast(c.kCFBooleanTrue.?);
    const stored: *const Boolean = @ptrCast(c.kCFBooleanFalse.?);
    dict.set(key, stored);
    try std.testing.expect(!dict.get(key, Boolean).?.val());
}
