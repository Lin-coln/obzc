const std = @import("std");
const ffi = @import("../../ffi/root.zig");
const e = @import("../../ffi/metadata.zig").e;
const encodeFunction = @import("utils/encode").encodeFunction;
const c = @import("macos").c;

pub fn method(comptime T: type) type {
    _ = T;

    return struct {
        /// Handler types follow the same encoding rules as `addMethod`.
        /// In particular, use `*ffi.Class` and `*ffi.Sel` for `self` and `_cmd`.
        pub fn addStaticMethod(
            cls: *ffi.Class,
            comptime name: [:0]const u8,
            comptime handler: anytype,
        ) !void {
            const metaclass = cls.metaclass() orelse
                return error.MetaClassNotFound;
            try addMethod(metaclass, name, handler);
        }

        /// Handler parameter and return types must have correct Objective-C encodings.
        /// Do not use `c.id`, `c.SEL`, or `c.Class`: the encoder treats them as
        /// ordinary opaque pointers. Use marked object types and `*ffi.Sel`.
        pub fn addMethod(
            cls: *ffi.Class,
            comptime name: [:0]const u8,
            comptime handler: anytype,
        ) !void {
            const Fn = @TypeOf(handler);
            const imp: c.IMP = @ptrCast(&handler);

            const done = c.class_addMethod(
                @ptrCast(cls),
                @ptrCast(ffi.Sel.get(name)),
                imp,
                comptime encodeFunction(Fn),
            );
            if (done == c.YES) return;
            return error.AddMethodFailed;
        }
    };
}

test "ClassFactory.method.addMethod: binds the function to the selector" {
    const T = opaque {
        pub const _encoding = e(.obj);
    };
    const Probe = struct {
        fn handle(_: *T, _: *ffi.Sel) callconv(.c) void {}
    };
    const raw = c.objc_allocateClassPair(c.objc_getClass("NSObject").?, "ObzcFactoryMethodProbe", 0).?;
    defer c.objc_disposeClassPair(raw);
    c.objc_registerClassPair(raw);
    const cls: *ffi.Class = @ptrCast(raw);
    const methods = method(T);
    try methods.addMethod(cls, "first", Probe.handle);
    const metadata = c.class_getInstanceMethod(raw, c.sel_registerName("first")).?;
    try std.testing.expectEqual(@as(c.IMP, @ptrCast(&Probe.handle)), c.method_getImplementation(metadata));
    try std.testing.expectEqualStrings("v@:", std.mem.span(c.method_getTypeEncoding(metadata)));
    try std.testing.expectError(error.AddMethodFailed, methods.addMethod(cls, "first", Probe.handle));
}

test "ClassFactory.method.addStaticMethod: targets the metaclass and propagates duplicate errors" {
    const T = opaque {};
    const Probe = struct {
        fn handle(_: *ffi.Class, _: *ffi.Sel) callconv(.c) void {}
    };
    const raw = c.objc_allocateClassPair(c.objc_getClass("NSObject").?, "ObzcFactoryStaticMethodProbe", 0).?;
    defer c.objc_disposeClassPair(raw);
    c.objc_registerClassPair(raw);
    const cls: *ffi.Class = @ptrCast(raw);
    const methods = method(T);
    try methods.addStaticMethod(cls, "factoryProbe", Probe.handle);
    const selector = c.sel_registerName("factoryProbe");
    try std.testing.expect(c.class_getClassMethod(raw, selector) != null);
    try std.testing.expectEqual(null, c.class_getInstanceMethod(raw, selector));
    try std.testing.expectEqualStrings("v#:", std.mem.span(c.method_getTypeEncoding(c.class_getClassMethod(raw, selector).?)));
    try std.testing.expectError(error.AddMethodFailed, methods.addStaticMethod(cls, "factoryProbe", Probe.handle));
}
