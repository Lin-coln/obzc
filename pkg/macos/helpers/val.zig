const std = @import("std");
const c = @import("../ffi/root.zig").c;

pub fn val(comptime T: type) type {
    const O = resolveTypefromExternStruct(T);
    return struct {
        pub const raw = RawCaster(T, O).call;
        pub const wrap = WrapCaster(T, O).call;
    };
}

fn resolveTypefromExternStruct(comptime T: type) type {
    const full_name = @typeName(T);
    const start = if (std.mem.lastIndexOfScalar(u8, full_name, '.')) |i| i + 1 else 0;
    return @field(c, full_name[start..]);
}

fn RawCaster(comptime T: type, comptime O: type) type {
    return struct {
        pub fn call(self: T) O {
            return @as(*const O, @ptrCast(&self)).*;
        }
    };
}

fn WrapCaster(comptime T: type, comptime O: type) type {
    return struct {
        pub fn call(value: O) T {
            return @as(*const T, @ptrCast(&value)).*;
        }
    };
}
