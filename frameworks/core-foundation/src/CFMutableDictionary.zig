const std = @import("std");
const c = @import("../ffi/root.zig").c;

pub const CFMutableDictionary = opaque {
    const Self = @This();

    pub fn create() ?*Self {
        const dict = c.CFDictionaryCreateMutable(null, 0, &c.kCFTypeDictionaryKeyCallBacks, &c.kCFTypeDictionaryValueCallBacks) orelse return null;
        return @ptrCast(dict);
    }

    pub fn setValue(self: *Self, key: ?*const anyopaque, value: ?*const anyopaque) void {
        self.raw().?.CFDictionarySetValue(key, value);
    }

    fn raw(self: *Self) c.CFMutableDictionaryRef {
        return @ptrCast(self);
    }
};

test "mutable dictionary stores a value" {
    const dict = CFMutableDictionary.create().?;
    defer c.CFRelease(@ptrCast(dict));

    dict.setValue(@ptrCast(c.kCFBooleanTrue), @ptrCast(c.kCFBooleanFalse));
    const read_only: *const @import("CFDictionary.zig").CFDictionary = @ptrCast(dict);
    const value = read_only.getValue(@ptrCast(c.kCFBooleanTrue), anyopaque).?;
    try std.testing.expectEqual(@intFromPtr(c.kCFBooleanFalse.?), @intFromPtr(value));
}
