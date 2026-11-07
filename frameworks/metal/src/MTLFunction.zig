const std = @import("std");
const core = @import("core");
const e = core.ffi.metadata.e;
const z = @import("macos").z;

pub const MTLFunction = opaque {
    pub const _encoding = e(.obj);
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    pub fn functionType(self: *Self) z.MTLFunctionType {
        return h.call(self, z.MTLFunctionType, "functionType", .{});
    }
};

test "MTLFunction: functionType identifies a compute function" {
    const ns = @import("foundation");
    const MTLDevice = @import("MTLDevice.zig").MTLDevice;
    const pool = core.AutoReleasePool.create();
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
