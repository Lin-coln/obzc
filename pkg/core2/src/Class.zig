const std = @import("std");
const c = @import("macos").c;
const msg = @import("msg.zig");

pub const Class = opaque {
    pub const _encoding = "#";
    const Self = @This();

    pub fn lookup(name: [:0]const u8) ?*Self {
        return @ptrCast(c.objc_getClass(name));
    }

    pub inline fn _call(self: *Self, comptime Return: type, name: [:0]const u8, args: anytype) Return {
        return msg.call(self, Return, name, args);
    }
};
