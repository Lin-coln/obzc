const AutoReleasePool = @import("runtime").AutoReleasePool;
const std = @import("std");
const ns = @import("foundation");
const z = @import("macos").z;

pub const MTLFunction = opaque {
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

    pub const functionType = h._p("functionType", z.MTLFunctionType).getter;
};

test "MTLFunction: functionType identifies a compute function" {
    const MTLDevice = @import("MTLDevice.zig").MTLDevice;
    const pool = AutoReleasePool.create();
    defer pool.release();
    const device = MTLDevice.createSystemDefaultDevice() orelse return error.SkipZigTest;
    defer device.release();
    const source = ns.String.init("kernel void compute() {}").?;
    defer source.release();
    const library = try device.newLibrary(source, null);
    defer library.release();
    const name = ns.String.init("compute").?;
    defer name.release();
    const function = library.newFunction(name).?;
    defer function.release();

    try std.testing.expectEqual(@as(z.MTLFunctionType, z.MTLFunctionTypeKernel), function.functionType());
}
