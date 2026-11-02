const std = @import("std");
const c = @import("../ffi/root.zig").c;

pub fn konst(comptime T: type) type {
    const O = resolveTypefromConstEnum(T);

    return struct {
        pub const raw = RawCaster(T, O).call;
    };
}

fn resolveTypefromConstEnum(comptime T: type) type {
    const name = resolveTypeName(T);
    const fields = @typeInfo(T).@"enum".field_names;
    if (fields.len == 0) @compileError("constant enum must contain a field");
    return @TypeOf(@field(c, name ++ fields[0]));
}

fn RawCaster(comptime T: type, comptime O: type) type {
    const name = resolveTypeName(T);

    return struct {
        pub fn call(self: T) O {
            return switch (self) {
                inline else => |value| @field(c, name ++ @tagName(value)),
            };
        }
    };
}

fn resolveTypeName(comptime T: type) []const u8 {
    const full_name = @typeName(T);
    const start = if (std.mem.lastIndexOfScalar(u8, full_name, '.')) |i| i + 1 else 0;
    return full_name[start..];
}
