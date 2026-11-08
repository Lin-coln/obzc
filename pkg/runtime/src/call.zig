const std = @import("std");
const Sel = @import("metadata.zig").Sel;
const cast = @import("metadata.zig").cast;
const send = @import("msg.zig").send;
const Block = @import("block/root.zig").Block;
const toSpreadedFn = @import("utils").toSpreadedFn;

pub fn call(
    receiver: anytype,
    comptime Return: type,
    name: [:0]const u8,
    args: anytype,
) Return {
    const fields = @typeInfo(@TypeOf(args)).@"struct".field_types;
    comptime var types: [fields.len]type = undefined;
    inline for (fields, 0..) |Field, i| types[i] = cast.type.z2c(Field);

    var c_args: @Tuple(&types) = undefined;
    inline for (args, 0..) |value, i| c_args[i] = cast.z2c(value);

    const result = send(receiver, cast.type.z2c(Return), Sel.get(name), c_args);
    return cast.c2z(result);
}

/// Appends a stack block whose handler receives `ctx` before the block arguments.
/// `ctx` must remain valid for every invocation, including after the method copies the block.
pub fn callWithCallback(
    receiver: anytype,
    comptime Return: type,
    name: [:0]const u8,
    ctx: anytype,
    args: anytype,
    comptime cb: anytype,
) Return {
    const Context = @TypeOf(ctx);
    const Handler = handlerType(Context, @TypeOf(cb));
    const info = @typeInfo(Handler).@"fn";

    comptime var params: [info.param_types.len - 1]type = undefined;
    inline for (info.param_types[1..], 0..) |Param, i| params[i] = Param.?;
    const Function = @Fn(&params, &@splat(.{}), info.return_type.?, .{});
    const B = Block(Context, Function);
    const CallbackArgs = std.meta.ArgsTuple(@typeInfo(@FieldType(B, "invoke")).pointer.child);

    const Callback = struct {
        fn invoke(block_args: CallbackArgs) info.return_type.? {
            var handler_args: std.meta.ArgsTuple(Handler) = undefined;
            handler_args[0] = block_args[0].context;
            inline for (1..info.param_types.len) |i| handler_args[i] = block_args[i];
            return @call(.auto, cb, handler_args);
        }
    };

    const block = B.init(ctx, toSpreadedFn(Callback.invoke, .{ .cc = .c }));
    return call(receiver, Return, name, args ++ .{&block});
}

fn handlerType(comptime Context: type, comptime Callback: type) type {
    if (@typeInfo(Context) != .pointer or @typeInfo(Context).pointer.size != .one)
        @compileError("block context must be a single-item pointer");

    const Handler = switch (@typeInfo(Callback)) {
        .@"fn" => Callback,
        .pointer => |pointer| if (@typeInfo(pointer.child) == .@"fn") pointer.child else @compileError("block handler must be a function"),
        else => @compileError("block handler must be a function"),
    };
    const info = @typeInfo(Handler).@"fn";
    if (info.is_generic or info.attrs.varargs)
        @compileError("block handler must have fixed, known parameter types");
    if (info.param_types.len == 0 or info.param_types[0].? != Context)
        @compileError("block handler's first parameter must match the context pointer type");
    if (info.param_types.len > 15)
        @compileError("block handler supports at most 14 block arguments, excluding context");
    return Handler;
}

test "callWithCallback passes method arguments and dispatches the block with its context" {
    const c = @import("macos").c;
    const z = @import("macos").z;
    const Class = @import("Class.zig").Class;
    const State = struct { value: i32 = 0 };
    const B = Block(*State, fn (i32) void);
    const Methods = struct {
        fn run(_: c.id, _: c.SEL, value: i32, block: *const B) callconv(.c) i32 {
            block.invoke(block, value + 1);
            return value * 2;
        }
        fn complete(state: *State, value: i32) void {
            state.value = value;
        }
    };

    const superclass = c.objc_getClass("NSObject") orelse return error.MissingNSObject;
    const cls = c.objc_allocateClassPair(superclass, "ObzcRuntimeCallWithCallbackTest", 0) orelse return error.ClassAllocFailed;
    defer c.objc_disposeClassPair(cls);
    try std.testing.expect(c.class_addMethod(cls, @ptrCast(Sel.get("run:completion:")), @ptrCast(&Methods.run), "i@:i@?") == c.YES);
    c.objc_registerClassPair(cls);

    const object = send(@as(*Class, @ptrCast(cls)), c.id, Sel.get("new"), .{}) orelse return error.ObjectAllocFailed;
    defer z.objc_release(object);
    var state: State = .{};
    const result = callWithCallback(object, i32, "run:completion:", &state, .{@as(i32, 7)}, Methods.complete);
    try std.testing.expectEqual(@as(i32, 14), result);
    try std.testing.expectEqual(@as(i32, 8), state.value);
}
