const std = @import("std");
const c = @import("macos").c;
const z = @import("macos").z;
const utils = @import("utils");
const Sel = @import("metadata.zig").Sel;
const Class = @import("Class.zig").Class;
const msg = @import("msg.zig");
const prop = @import("prop.zig");

pub fn NSObjectPrototype(comptime T: type) type {
    const class_name = comptime utils.resolveTypeName(@typeName(T));
    return struct {
        // mixin helpers
        pub const _encoding = "@";

        pub inline fn _cls() *Class {
            return Class.lookup(class_name).?;
        }

        pub inline fn _call(self: *const T, comptime Return: type, name: [:0]const u8, args: anytype) Return {
            return msg.call(self, Return, name, args);
        }

        pub fn _p(comptime name: [:0]const u8, comptime P: type) type {
            return struct {
                pub fn getter(self: *const T) P {
                    return prop.get(self, P, name, class_name);
                }
                pub fn setter(self: *T, value: P) void {
                    prop.set(self, P, name, value);
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
