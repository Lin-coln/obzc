const std = @import("std");
const z = @import("macos").z;
const ns = @import("root.zig");

pub const NSNumber = opaque {
    pub const Mixin = NSNumberMixin;

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
    pub const init = h.init;
    pub const val = h.val;
};

fn NSNumberMixin(comptime T: type) type {
    return struct {
        const h = ns.Value.Mixin(T);

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
        pub const respondsToSelector = h.respondsToSelector;
        pub const objCType = h.objCType;
        pub const getValue = h.getValue;
        pub const isEqualToValue = h.isEqualToValue;

        pub fn init(comptime Value: type, value: Value) *T {
            const selector: [:0]const u8 = switch (Value) {
                z.NSInteger => "initWithInteger:",
                f64 => "initWithDouble:",
                bool => "initWithBool:",
                else => @compileError("NSNumber.init supports only NSInteger, f64, and bool"),
            };

            const allocated = _cls(null).alloc(T);
            return _call(allocated, ?*T, selector, .{value}).?;
        }

        pub fn val(self: *const T, comptime Value: type) Value {
            const name: [:0]const u8 = switch (Value) {
                z.NSInteger => "integerValue",
                f64 => "doubleValue",
                bool => "boolValue",
                else => @compileError("NSNumber.val supports only NSInteger, f64, and bool"),
            };

            return _p(name, Value).getter(self);
        }
    };
}

test "NSNumber: integer, double, and bool values" {
    const integer = ns.Number.init(z.NSInteger, 42);
    defer integer.release();
    const double = ns.Number.init(f64, 1.3);
    defer double.release();
    const yes = ns.Number.init(bool, true);
    defer yes.release();
    const no = ns.Number.init(bool, false);
    defer no.release();

    try std.testing.expectEqual(42, integer.val(z.NSInteger));
    try std.testing.expectEqual(1.3, double.val(f64));
    try std.testing.expectEqual(1, double.val(z.NSInteger));
    try std.testing.expect(yes.val(bool));
    try std.testing.expect(!no.val(bool));

    const retained = integer.retain();
    defer retained.release();
    try std.testing.expectEqual(integer, retained);
}

test "NSNumber: signed integer limits round-trip without narrowing" {
    for ([_]z.NSInteger{ std.math.minInt(z.NSInteger), -1, std.math.maxInt(z.NSInteger) }) |value| {
        const number = ns.Number.init(z.NSInteger, value);
        defer number.release();

        try std.testing.expectEqual(value, number.val(z.NSInteger));
    }
}
