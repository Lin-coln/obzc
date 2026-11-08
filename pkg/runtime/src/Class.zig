const std = @import("std");
const c = @import("macos").c;
const call = @import("call.zig").call;
const Sel = @import("metadata.zig").Sel;
const encodeType = @import("utils/encode").encodeType;
const encodeFunction = @import("utils/encode").encodeFunction;

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

    pub fn allocateClassPair(self: *Self, class_name: [:0]const u8) *ClassPair {
        const allocated = c.objc_allocateClassPair(self, class_name, 0) orelse
            return error.AllocateClassFailed;
        return @ptrCast(allocated);
    }
};

pub const ClassPair = opaque {
    pub const _encoding = "#";
    const Self = @This();

    pub fn dispose(self: *Self) void {
        c.objc_disposeClassPair(@ptrCast(self));
    }

    pub fn register(self: *Self) void {
        c.objc_registerClassPair(@ptrCast(self));
    }

    pub fn addProtocol(self: *Self, comptime name: [:0]const u8) !void {
        const ptc = c.objc_getProtocol(name) orelse return;
        const done = c.class_addProtocol(@ptrCast(self), ptc);
        if (done == c.YES) return;
        return error.AddProtocolFailed;
    }

    pub fn addIvar(self: *Self, comptime name: [:0]const u8, comptime Type: type) !void {
        const done = c.class_addIvar(
            @ptrCast(self),
            name,
            @sizeOf(Type),
            comptime std.math.log2_int(usize, @alignOf(Type)),
            comptime encodeType(Type),
        );
        if (done == c.YES) return;
        return error.AddIvarFailed;
    }

    pub fn addMethod(self: *Self, comptime name: [:0]const u8, comptime handler: anytype) !void {
        const Fn = @TypeOf(handler);
        const imp: c.IMP = @ptrCast(&handler);

        const done = c.class_addMethod(
            @ptrCast(self),
            @ptrCast(Sel.get(name)),
            imp,
            comptime encodeFunction(Fn),
        );
        if (done == c.YES) return;
        return error.AddMethodFailed;
    }

    pub fn addStaticMethod(self: *Self, comptime name: [:0]const u8, comptime handler: anytype) !void {
        const metaclass: c.Class = c.object_getClass(@ptrCast(self)) orelse
            return error.MetaClassNotFound;
        try addMethod(@ptrCast(metaclass), name, handler);
    }
};
