const std = @import("std");
const c = @import("macos").c;
const call = @import("call.zig").call;

pub const Class = opaque {
    pub const _encoding = "#";
    const Self = @This();

    pub fn lookup(name: [:0]const u8) ?*Self {
        return @ptrCast(c.objc_getClass(name));
    }

    pub inline fn alloc(self: *Self, comptime T: type) *T {
        return self._call(*T, "alloc", .{});
    }

    pub inline fn new(self: *Self, comptime T: type) *T {
        return self._call(*T, "new", .{});
    }

    pub inline fn _call(self: *Self, comptime Return: type, comptime name: [:0]const u8, args: anytype) Return {
        return call(self, Return, name, args);
    }

    pub inline fn _callWithCallback(self: *Self, comptime Return: type, comptime name: [:0]const u8, ctx: anytype, args: anytype, comptime cb: anytype) Return {
        return @import("call.zig").callWithCallback(self, Return, name, ctx, args, cb);
    }

    pub inline fn _callSync(self: *Self, comptime Return: type, comptime name: [:0]const u8, args: anytype) Return {
        return @import("call.zig").callSync(self, Return, name, args);
    }
};
