const std = @import("std");
const z = @import("macos").z;
const ns = @import("root.zig");

pub const NSValue = opaque {
    pub const Mixin = NSValueMixin;

    const Self = @This();
    const h = Mixin(Self);

    pub const _encoding = h._encoding;
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;
    pub const objCType = h.objCType;
    pub const getValue = h.getValue;
    pub const isEqualToValue = h.isEqualToValue;
};

fn NSValueMixin(comptime T: type) type {
    return struct {
        const h = ns.Object.Mixin(T);

        pub const _encoding = h._encoding;
        pub const _cls = h._cls;
        pub const _call = h._call;
        pub const _p = h._p;

        pub const retain = h.retain;
        pub const release = h.release;
        pub const equal = h.equal;
        pub const hash = h.hash;
        pub const class = h.class;
        pub const isKindOfClass = h.isKindOfClass;
        pub const respondsToSelector = h.respondToSelector;

        pub const objCType = _p("objCType", [*:0]const u8).getter;

        pub fn getValue(self: *const T, out: []u8) void {
            _call(self, void, "getValue:size:", .{ out.ptr, @as(z.NSUInteger, @intCast(out.len)) });
        }

        pub fn isEqualToValue(self: *const T, other: *const ns.Value) bool {
            return _call(self, bool, "isEqualToValue:", .{other});
        }
    };
}

test "NSValue exposes values held by NSNumber" {
    const number = ns.Number.init(z.NSInteger, 42);
    defer number.release();

    const value: *const NSValue = @ptrCast(number);
    try std.testing.expect(value.isKindOfClass(value.class()));
    try std.testing.expect(value.isEqualToValue(value));
    try std.testing.expect(std.mem.len(value.objCType()) != 0);

    var extracted: z.NSInteger = 0;
    value.getValue(std.mem.asBytes(&extracted));
    try std.testing.expectEqual(42, extracted);
}
