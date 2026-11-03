const std = @import("std");
const c = @import("macos").c;

pub const CFDictionary = opaque {
    pub const Mixin = CFDictionaryMixin;
    pub const WithKey = CFDictionary_WithKey;

    const Self = @This();
    const h = Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const setValue = h.setValue;
    pub const getValue = h.getValue;
};

fn CFDictionaryMixin(comptime T: type) type {
    return struct {
        const h = @import("CFType.zig").CFType.Mixin(T);

        pub const retain = h.retain;
        pub const release = h.release;

        pub fn setValue(self: *T, key: *const anyopaque, value: *const anyopaque) void {
            c.CFDictionarySetValue(raw(self), key, value);
        }

        pub fn getValue(self: *const T, key: *const anyopaque) ?*const anyopaque {
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

        pub const retain = h.retain;
        pub const release = h.release;

        pub fn setValue(self: *Self, key: *const K, value: *const anyopaque) void {
            h.setValue(self, key, value);
        }

        pub fn getValue(self: *const Self, key: *const K, comptime V: type) ?*const V {
            const value = h.getValue(self, key) orelse return null;
            return @ptrCast(value);
        }
    };
}

test "mutable dictionary stores a value" {
    const Boolean = @import("CFBoolean.zig").CFBoolean;
    const dict: *CFDictionary = @ptrCast(c.CFDictionaryCreateMutable(null, 0, &c.kCFTypeDictionaryKeyCallBacks, &c.kCFTypeDictionaryValueCallBacks).?);
    defer dict.release();

    const key: *const Boolean = @ptrCast(c.kCFBooleanTrue.?);
    const stored: *const Boolean = @ptrCast(c.kCFBooleanFalse.?);
    dict.setValue(key, stored);
    const read_only: *const CFDictionary = dict;
    const value = read_only.getValue(key).?;
    try std.testing.expectEqual(@intFromPtr(stored), @intFromPtr(value));
}

test "dictionary with typed keys stores a value" {
    const Boolean = @import("CFBoolean.zig").CFBoolean;
    const BooleanKeys = CFDictionary.WithKey(Boolean);
    const dict: *BooleanKeys = @ptrCast(c.CFDictionaryCreateMutable(null, 0, &c.kCFTypeDictionaryKeyCallBacks, &c.kCFTypeDictionaryValueCallBacks).?);
    defer dict.release();

    const key: *const Boolean = @ptrCast(c.kCFBooleanTrue.?);
    const stored: *const Boolean = @ptrCast(c.kCFBooleanFalse.?);
    dict.setValue(key, stored);
    try std.testing.expect(!dict.getValue(key, Boolean).?.getValue());
}
