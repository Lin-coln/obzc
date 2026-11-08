const std = @import("std");
const c = @import("macos").c;
const z = @import("macos").z;
const utils = @import("utils");
const Sel = @import("metadata.zig").Sel;
const Class = @import("Class.zig").Class;

pub fn NSObjectPrototype(comptime T: type) type {
    return struct {
        // mixin helpers
        pub const _encoding = "@";

        pub inline fn _cls(comptime Clazz: ?type) *Class {
            const class_name = comptime utils.resolveTypeName(@typeName(Clazz orelse T));
            return Class.lookup(class_name).?;
        }

        pub inline fn _call(self: *const T, comptime Return: type, comptime name: [:0]const u8, args: anytype) Return {
            return @import("call.zig").call(self, Return, name, args);
        }

        pub inline fn _callWithCallback(self: *const T, comptime Return: type, comptime name: [:0]const u8, ctx: anytype, args: anytype, comptime cb: anytype) Return {
            return @import("call.zig").callWithCallback(self, Return, name, ctx, args, cb);
        }
        pub inline fn _callSync(self: *const T, comptime Return: type, comptime name: [:0]const u8, args: anytype) Return {
            return @import("call.zig").callSync(self, Return, name, args);
        }

        pub fn _p(comptime name: [:0]const u8, comptime P: type) type {
            return struct {
                pub fn getter(self: *const T) P {
                    return @import("prop.zig").get(self, P, name);
                }
                pub fn setter(self: *T, value: P) void {
                    @import("prop.zig").set(self, P, name, value);
                }
            };
        }

        pub fn _ivar(comptime name: [:0]const u8, comptime P: type) type {
            return struct {
                pub fn getter(self: *T) P {
                    return @import("ivar.zig").get(self, P, name);
                }
                pub fn setter(self: *T, value: P) void {
                    @import("ivar.zig").set(self, P, name, value);
                }
            };
        }

        // methods
        pub fn retain(self: *T) *T {
            return @ptrCast(z.objc_retain(@ptrCast(self)).?);
        }

        pub fn release(self: *T) void {
            z.objc_release(@ptrCast(self));
        }

        pub fn equal(self: *const T, other: ?*const T) bool {
            return _call(self, bool, "isEqual:", .{other});
        }

        pub fn hash(self: *const T) z.NSUInteger {
            return _call(self, z.NSUInteger, "hash", .{});
        }

        pub fn class(self: *const T) *Class {
            return _call(self, *Class, "class", .{});
        }

        pub fn isKindOfClass(self: *const T, cls: *Class) bool {
            return _call(self, bool, "isKindOfClass:", .{cls});
        }

        pub fn respondsToSelector(self: *const T, sel: *Sel) bool {
            return _call(self, bool, "respondsToSelector:", .{sel});
        }
    };
}
