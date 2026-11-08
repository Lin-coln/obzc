const Sel = @import("metadata.zig").Sel;
const cast = @import("metadata.zig").cast;
const send = @import("msg.zig").send;

pub fn call(receiver: anytype, comptime Return: type, name: [:0]const u8, args: anytype) Return {
    const fields = @typeInfo(@TypeOf(args)).@"struct".field_types;
    comptime var types: [fields.len]type = undefined;
    inline for (fields, 0..) |Field, i| types[i] = cast.type.z2c(Field);

    var c_args: @Tuple(&types) = undefined;
    inline for (args, 0..) |value, i| c_args[i] = cast.z2c(value);

    const result = send(receiver, cast.type.z2c(Return), Sel.get(name), c_args);
    return cast.c2z(result);
}
