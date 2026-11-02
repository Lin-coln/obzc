const std = @import("std");
const c = @import("../ffi/root.zig").c;

pub fn h(comptime T: type) type {
    const O = resolveTypefromOpaque(T);

    return struct {
        pub const raw = RawCaster(T, O).call;

        pub fn retain(self: *const T) *const T {
            return @ptrCast(c.CFRetain(@ptrCast(self)));
        }

        pub fn release(self: *const T) void {
            c.CFRelease(@ptrCast(self));
        }
    };
}

fn resolveTypefromOpaque(comptime T: type) type {
    const name = resolveTypeName(@typeName(T));
    const Ref = @field(c, std.fmt.comptimePrint("{s}Ref", .{name}));
    return @typeInfo(@typeInfo(Ref).optional.child).pointer.child;
}

fn RawCaster(comptime T: type, comptime O: type) type {
    return struct {
        pub fn call(self: anytype) if (@TypeOf(self) == *const T) *const O else *O {
            comptime {
                if (@TypeOf(self) != *T and @TypeOf(self) != *const T)
                    @compileError("raw receiver must point to " ++ @typeName(T));
            }
            return @ptrCast(self);
        }
    };
}

fn resolveTypeName(comptime full_name: []const u8) [:0]const u8 {
    var start: usize = 0;
    var end: usize = full_name.len;
    var depth: usize = 0;
    var quoted = false;
    var escaped = false;

    for (full_name, 0..) |char, i| {
        if (quoted) {
            if (escaped) {
                escaped = false;
            } else if (char == '\\') {
                escaped = true;
            } else if (char == '"') {
                quoted = false;
            }
            continue;
        }
        switch (char) {
            '"' => quoted = true,
            '(' => {
                if (depth == 0) end = i;
                depth += 1;
            },
            ')' => depth -= 1,
            '.' => if (depth == 0) {
                start = i + 1;
                end = full_name.len;
            },
            else => {},
        }
    }
    return std.fmt.comptimePrint("{s}", .{full_name[start..end]});
}
