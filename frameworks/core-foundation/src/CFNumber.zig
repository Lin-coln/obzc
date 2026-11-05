const c = @import("macos").c;
const cf = @import("root.zig");

pub const CFNumber = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;

    pub fn getTypeID() c.CFTypeID {
        return c.CFNumberGetTypeID();
    }

    pub fn val(self: *const Self, comptime T: type) ?T {
        var value: T = undefined;
        if (c.CFNumberGetValue(self.raw(), fromType(T), &value) == 0) return null;
        return value;
    }

    fn raw(self: *const Self) c.CFNumberRef {
        return @ptrCast(self);
    }
};

pub fn kCFNumberType(kind: enum {
    SInt8Type,
    SInt16Type,
    SInt32Type,
    SInt64Type,
    Float32Type,
    Float64Type,
    CharType,
    ShortType,
    IntType,
    LongType,
    LongLongType,
    FloatType,
    DoubleType,
    CFIndexType,
    NSIntegerType,
    CGFloatType,
}) c.CFNumberType {
    const raw: c.CFNumberType = switch (kind) {
        inline else => |value| @field(c, "kCFNumber" ++ @tagName(value)),
    };
    return raw;
}

fn fromType(comptime T: type) c.CFNumberType {
    return switch (T) {
        i8 => kCFNumberType(.SInt8Type),
        i16 => kCFNumberType(.SInt16Type),
        i32 => kCFNumberType(.SInt32Type),
        i64 => kCFNumberType(.SInt64Type),
        f32 => kCFNumberType(.FloatType),
        f64 => kCFNumberType(.DoubleType),
        c_char => kCFNumberType(.CharType),
        c_short => kCFNumberType(.ShortType),
        c_int => kCFNumberType(.IntType),
        c_long => kCFNumberType(.LongType),
        c_longlong => kCFNumberType(.LongLongType),
        isize => kCFNumberType(.CFIndexType),
        else => @compileError("unsupported CFNumber value type"),
    };
}

test "getValue reads supported number types" {
    const std = @import("std");
    inline for (.{
        @as(i8, 1),
        @as(i16, 2),
        @as(i32, 3),
        @as(i64, 4),
        @as(f32, 5.5),
        @as(f64, 6.5),
        @as(c_char, 7),
        @as(c_short, 8),
        @as(c_int, 9),
        @as(c_long, 10),
        @as(c_longlong, 11),
        @as(isize, 12),
    }) |value| {
        const T = @TypeOf(value);
        const raw_number = c.CFNumberCreate(null, fromType(T), &value) orelse return error.OutOfMemory;
        defer c.CFRelease(raw_number);

        const number: *const CFNumber = @ptrCast(raw_number);
        try std.testing.expectEqual(value, number.val(T).?);
    }
}
