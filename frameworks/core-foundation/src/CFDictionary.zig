const std = @import("std");
const c = @import("macos").c;

pub const CFDictionary = opaque {
    const Self = @This();
    const h = @import("macos").helpers.ref(Self);
    const raw = h.raw;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn setValue(self: *Self, key: *const anyopaque, value: *const anyopaque) void {
        c.CFDictionarySetValue(self.raw(), key, value);
    }

    pub fn getValue(self: *const Self, key: *const anyopaque) ?*const anyopaque {
        const value = c.CFDictionaryGetValue(self.raw(), key) orelse return null;
        return @ptrCast(value);
    }
};

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
