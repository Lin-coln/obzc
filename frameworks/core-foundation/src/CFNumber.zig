const c = @import("macos").c;

pub const CFNumber = opaque {
    const Self = @This();
    const h = @import("CFBase/CFType.zig").CFType.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;

    pub fn getTypeID() c.CFTypeID {
        return c.CFNumberGetTypeID();
    }

    pub fn val(self: *const Self, comptime T: type) ?T {
        var value: T = undefined;
        if (c.CFNumberGetValue(self.raw(), kCFNumberType.fromType(T).unwrap(), &value) == 0) return null;
        return value;
    }

    fn raw(self: *const Self) c.CFNumberRef {
        return @ptrCast(self);
    }
};

pub const kCFNumberType = enum(c.CFNumberType) {
    const Self = @This();

    pub fn unwrap(self: Self) c.CFNumberType {
        return @backingInt(self);
    }

    pub fn fromRaw(raw: c.CFNumberType) ?Self {
        inline for (@typeInfo(Self).@"enum".field_names) |name| {
            if (raw == @field(c, "kCFNumber" ++ name)) return @field(Self, name);
        }
        return null;
    }

    pub fn fromType(comptime T: type) Self {
        return switch (T) {
            i8 => .SInt8Type,
            i16 => .SInt16Type,
            i32 => .SInt32Type,
            i64 => .SInt64Type,
            f32 => .FloatType,
            f64 => .DoubleType,
            c_char => .CharType,
            c_short => .ShortType,
            c_int => .IntType,
            c_long => .LongType,
            c_longlong => .LongLongType,
            isize => .CFIndexType,
            else => @compileError("unsupported CFNumber value type"),
        };
    }

    SInt8Type = c.kCFNumberSInt8Type,
    SInt16Type = c.kCFNumberSInt16Type,
    SInt32Type = c.kCFNumberSInt32Type,
    SInt64Type = c.kCFNumberSInt64Type,
    Float32Type = c.kCFNumberFloat32Type,
    Float64Type = c.kCFNumberFloat64Type,
    CharType = c.kCFNumberCharType,
    ShortType = c.kCFNumberShortType,
    IntType = c.kCFNumberIntType,
    LongType = c.kCFNumberLongType,
    LongLongType = c.kCFNumberLongLongType,
    FloatType = c.kCFNumberFloatType,
    DoubleType = c.kCFNumberDoubleType,
    CFIndexType = c.kCFNumberCFIndexType,
    NSIntegerType = c.kCFNumberNSIntegerType,
    CGFloatType = c.kCFNumberCGFloatType,
};

test "getValue reads supported number types" {
    const std = @import("std");
    for (std.meta.tags(kCFNumberType)) |kind| {
        try std.testing.expectEqual(kind, kCFNumberType.fromRaw(kind.unwrap()).?);
    }
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
        const raw_number = c.CFNumberCreate(null, kCFNumberType.fromType(T).unwrap(), &value) orelse return error.OutOfMemory;
        defer c.CFRelease(raw_number);

        const number: *const CFNumber = @ptrCast(raw_number);
        try std.testing.expectEqual(value, number.val(T).?);
    }
}
