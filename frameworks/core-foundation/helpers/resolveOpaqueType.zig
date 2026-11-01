const std = @import("std");

pub fn resolveOpaqueType(comptime T: type, comptime c: type) type {
    const name = resolveTypeName(@typeName(T));
    const Ref = @field(c, std.fmt.comptimePrint("{s}Ref", .{name}));
    return @typeInfo(@typeInfo(Ref).optional.child).pointer.child;
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
