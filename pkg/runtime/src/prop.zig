const std = @import("std");
const c = @import("macos").c;
const Class = @import("Class.zig").Class;
const call = @import("call.zig").call;

pub inline fn get(receiver: anytype, comptime P: type, name: [:0]const u8) P {
    const cls = call(receiver, *Class, "class", .{});
    const getter = if (getPropertyFromClass(cls, name)) |metadata| metadata.copyAttributeValue("G") else null;
    defer if (getter) |custom| std.c.free(custom.ptr);

    const selector = getter orelse name;
    return call(receiver, P, selector, .{});
}

pub inline fn set(
    receiver: anytype,
    comptime P: type,
    comptime name: [:0]const u8,
    value: P,
) void {
    const setter = "set" ++ [_]u8{std.ascii.toUpper(name[0])} ++ name[1..] ++ ":";
    call(receiver, void, setter, .{value});
}

inline fn getPropertyFromClass(class: *Class, name: [:0]const u8) ?*Property {
    return @ptrCast(c.class_getProperty(@ptrCast(class), name));
}

const Property = opaque {
    const Self = @This();

    pub fn name(self: *Self) [:0]const u8 {
        const val = c.property_getName(@ptrCast(self));
        return std.mem.span(val);
    }

    /// The returned string is allocated with `malloc` and must be freed with `std.c.free`.
    pub fn copyAttributeValue(self: *Self, attribute: [:0]const u8) ?[:0]u8 {
        const val = c.property_copyAttributeValue(@ptrCast(self), attribute) orelse return null;
        return std.mem.span(val);
    }
};
