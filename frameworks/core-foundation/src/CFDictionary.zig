const std = @import("std");
const c = @import("../ffi/root.zig").c;
const helpers = @import("../helpers/root.zig");

pub const CFDictionary = opaque {
    const Self = @This();
    const h = helpers.h(Self);
    const cast = h.cast;

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn create() ?*Self {
        const dict = c.CFDictionaryCreateMutable(null, 0, &c.kCFTypeDictionaryKeyCallBacks, &c.kCFTypeDictionaryValueCallBacks) orelse return null;
        return @ptrCast(dict);
    }

    pub fn setValue(self: *Self, key: ?*const anyopaque, value: ?*const anyopaque) void {
        self.cast().CFDictionarySetValue(key, value);
    }

    pub fn getValue(self: *const Self, key: ?*const anyopaque, comptime T: type) ?*const T {
        const value = self.cast().CFDictionaryGetValue(key) orelse return null;
        return @ptrCast(value);
    }
};

test "mutable dictionary stores a value" {
    const dict = CFDictionary.create().?;
    defer dict.release();

    dict.setValue(@ptrCast(c.kCFBooleanTrue), @ptrCast(c.kCFBooleanFalse));
    const read_only: *const CFDictionary = dict;
    const value = read_only.getValue(@ptrCast(c.kCFBooleanTrue), anyopaque).?;
    try std.testing.expectEqual(@intFromPtr(c.kCFBooleanFalse.?), @intFromPtr(value));
}
