const std = @import("std");
const c = @import("macos").c;

pub fn CFDictionary(comptime Key: type, comptime Value: type) type {
    return opaque {
        const Self = @This();
        const h = @import("macos").helpers.ref(Self);
        const raw = h.raw;

        pub const retain = h.retain;
        pub const release = h.release;

        pub fn create() ?*Self {
            const dict = c.CFDictionaryCreateMutable(null, 0, &c.kCFTypeDictionaryKeyCallBacks, &c.kCFTypeDictionaryValueCallBacks) orelse return null;
            return @ptrCast(dict);
        }

        pub fn setValue(self: *Self, key: *const Key, value: *const Value) void {
            c.CFDictionarySetValue(self.raw(), key, value);
        }

        pub fn getValue(self: *const Self, key: *const Key) ?*const Value {
            const value = c.CFDictionaryGetValue(self.raw(), key) orelse return null;
            return @ptrCast(value);
        }
    };
}

test "mutable dictionary stores a value" {
    const Boolean = @import("CFBoolean.zig").CFBoolean;
    const Dictionary = CFDictionary(Boolean, Boolean);
    const dict = Dictionary.create().?;
    defer dict.release();

    const key: *const Boolean = @ptrCast(c.kCFBooleanTrue.?);
    const stored: *const Boolean = @ptrCast(c.kCFBooleanFalse.?);
    dict.setValue(key, stored);
    const read_only: *const Dictionary = dict;
    const value = read_only.getValue(key).?;
    try std.testing.expectEqual(@intFromPtr(stored), @intFromPtr(value));
}
