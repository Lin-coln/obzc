const core2 = @import("core2");
const std = @import("std");
const ns = @import("foundation");
const MTLFunction = @import("MTLFunction.zig").MTLFunction;

pub const MTLLibrary = opaque {
    const Self = @This();
    const h = ns.Object.Mixin(Self);

    pub const _encoding = h._encoding;

    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;

    /// Returns an owned function, or null when the name is absent.
    pub fn newFunction(self: *Self, name: *ns.String) ?*MTLFunction {
        return h._call(self, ?*MTLFunction, "newFunctionWithName:", .{name});
    }
};

test "MTLLibrary: newFunction finds a named function and returns null for a missing name" {
    const MTLDevice = @import("MTLDevice.zig").MTLDevice;
    const pool = core2.AutoReleasePool.create();
    defer pool.release();
    const device = MTLDevice.createSystemDefaultDevice() orelse return error.SkipZigTest;
    defer device.release();
    const source = ns.String.init("kernel void available() {}").?;
    defer source.release();
    const library = try device.newLibrary(source, null);
    defer library.release();

    const name = ns.String.init("available").?;
    defer name.release();
    const function = library.newFunction(name).?;
    defer function.release();
    const missing = ns.String.init("missing_function").?;
    defer missing.release();
    try std.testing.expect(library.newFunction(missing) == null);
}
