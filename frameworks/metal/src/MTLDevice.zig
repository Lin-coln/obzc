const std = @import("std");
const builtin = @import("builtin");
const core = @import("core");
const e = core.ffi.metadata.e;
const ns = @import("foundation");
const ios = @import("io-surface");
const z = @import("macos").z;
const MTLCommandQueue = @import("MTLCommandQueue.zig").MTLCommandQueue;
const MTLTextureDescriptor = @import("MTLTextureDescriptor.zig").MTLTextureDescriptor;
const MTLTexture = @import("MTLTexture.zig").MTLTexture;
const MTLCompileOptions = @import("MTLCompileOptions.zig").MTLCompileOptions;
const MTLLibrary = @import("MTLLibrary.zig").MTLLibrary;
const MTLRenderPipelineDescriptor = @import("MTLRenderPipelineDescriptor.zig").MTLRenderPipelineDescriptor;
const MTLRenderPipelineState = @import("MTLRenderPipelineState.zig").MTLRenderPipelineState;

pub const MTLDevice = opaque {
    pub const _encoding = e(.obj);
    const Self = @This();
    const h = core.h(Self);

    pub const retain = h.retain;
    pub const release = h.release;

    /// Returns an owned default device, or null if Metal is unavailable.
    pub fn createSystemDefaultDevice() ?*Self {
        return @ptrCast(z.MTLCreateSystemDefaultDevice());
    }

    pub fn newCommandQueue(self: *Self) ?*MTLCommandQueue {
        return h.call(self, ?*MTLCommandQueue, "newCommandQueue", .{});
    }

    pub fn newTexture(self: *Self, descriptor: *MTLTextureDescriptor) ?*MTLTexture {
        return h.call(self, ?*MTLTexture, "newTextureWithDescriptor:", .{descriptor});
    }

    pub fn newTextureWithIOSurface(self: *Self, descriptor: *MTLTextureDescriptor, surface: ?*ios.Surface, plane: z.NSUInteger) ?*MTLTexture {
        return h.call(self, ?*MTLTexture, "newTextureWithDescriptor:iosurface:plane:", .{ descriptor, surface, plane });
    }

    /// Returns an owned library. Logs the SDK error when compilation fails.
    pub fn newLibrary(self: *Self, source: *ns.String, options: ?*MTLCompileOptions) !*MTLLibrary {
        var err: ?*ns.Error = null;
        const library = h.call(self, ?*MTLLibrary, "newLibraryWithSource:options:error:", .{ source, options, &err });
        if (library) |value| return value;

        if (err) |ns_error| ns_error.log() else if (!builtin.is_test)
            std.log.err("MTLDevice.newLibrary failed without NSError", .{});
        return error.NewLibraryFailed;
    }

    /// Returns an owned pipeline state. Logs the SDK error when creation fails.
    pub fn newRenderPipelineState(self: *Self, descriptor: *MTLRenderPipelineDescriptor) !*MTLRenderPipelineState {
        var err: ?*ns.Error = null;
        const pipeline = h.call(self, ?*MTLRenderPipelineState, "newRenderPipelineStateWithDescriptor:error:", .{ descriptor, &err });
        if (pipeline) |value| return value;

        if (err) |ns_error| ns_error.log() else if (!builtin.is_test)
            std.log.err("MTLDevice.newRenderPipelineState failed without NSError", .{});
        return error.NewRenderPipelineStateFailed;
    }
};

test "MTLDevice: newLibrary rejects invalid shader source" {
    const pool = core.AutoReleasePool.create();
    defer pool.release();
    const device = MTLDevice.createSystemDefaultDevice() orelse return error.SkipZigTest;
    defer device.release();
    const source = ns.String.init("this is not a Metal shader").?;
    defer source.release();
    try std.testing.expectError(error.NewLibraryFailed, device.newLibrary(source, null));
}

test "MTLDevice: newRenderPipelineState reports incompatible shader interfaces" {
    const pool = core.AutoReleasePool.create();
    defer pool.release();
    const device = MTLDevice.createSystemDefaultDevice() orelse return error.SkipZigTest;
    defer device.release();
    const source = ns.String.init(
        \\#include <metal_stdlib>
        \\using namespace metal;
        \\struct VertexOutput { float4 position [[position]]; float2 coordinate [[user(locn0)]]; };
        \\vertex VertexOutput vertex_main() { return {float4(0), float2(0)}; }
        \\struct FragmentInput { float3 coordinate [[user(locn0)]]; };
        \\fragment float4 fragment_main(FragmentInput input [[stage_in]]) { return float4(input.coordinate, 1); }
    ).?;
    defer source.release();
    const library = try device.newLibrary(source, null);
    defer library.release();
    const vertex_name = ns.String.init("vertex_main").?;
    defer vertex_name.release();
    const vertex = library.newFunction(vertex_name).?;
    defer vertex.release();
    const fragment_name = ns.String.init("fragment_main").?;
    defer fragment_name.release();
    const fragment = library.newFunction(fragment_name).?;
    defer fragment.release();
    const descriptor = MTLRenderPipelineDescriptor.new();
    defer descriptor.release();
    descriptor.setVertexFunction(vertex);
    descriptor.setFragmentFunction(fragment);
    descriptor.colorAttachments().objectAtIndexedSubscript(0).setPixelFormat(z.MTLPixelFormatBGRA8Unorm);

    try std.testing.expectError(error.NewRenderPipelineStateFailed, device.newRenderPipelineState(descriptor));
}
