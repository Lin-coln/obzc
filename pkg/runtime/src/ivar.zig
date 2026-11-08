const c = @import("macos").c;

pub inline fn get(receiver: anytype, comptime P: type, name: [:0]const u8) P {
    var raw: ?*anyopaque = null;
    _ = c.object_getInstanceVariable(@ptrCast(receiver), name, &raw).?;
    const value: P = @ptrCast(@alignCast(raw.?));
    return value;
}

pub inline fn set(
    receiver: anytype,
    comptime P: type,
    comptime name: [:0]const u8,
    value: P,
) void {
    _ = c.object_setInstanceVariable(@ptrCast(receiver), name, value).?;
}
