const std = @import("std");
const ns = @import("foundation");
const z = @import("macos").z;
const MTLFunction = @import("MTLFunction.zig").MTLFunction;
const MTLRenderPipelineColorAttachmentDescriptorArray = @import("MTLRenderPipelineColorAttachmentDescriptorArray.zig").MTLRenderPipelineColorAttachmentDescriptorArray;

pub const MTLRenderPipelineDescriptor = opaque {
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

    pub fn new() *Self {
        return h._cls(null).new(Self);
    }

    pub const vertexFunction = h._p("vertexFunction", ?*MTLFunction).getter;
    pub const setVertexFunction = h._p("vertexFunction", ?*MTLFunction).setter;
    pub const fragmentFunction = h._p("fragmentFunction", ?*MTLFunction).getter;
    pub const setFragmentFunction = h._p("fragmentFunction", ?*MTLFunction).setter;
    /// Borrowed attachment array, owned by this descriptor.
    pub const colorAttachments = h._p("colorAttachments", *MTLRenderPipelineColorAttachmentDescriptorArray).getter;
};

test "MTLRenderPipelineDescriptor: new has empty function slots" {
    const descriptor = MTLRenderPipelineDescriptor.new();
    defer descriptor.release();

    try std.testing.expect(descriptor.vertexFunction() == null);
    try std.testing.expect(descriptor.fragmentFunction() == null);
}

test "MTLRenderPipelineDescriptor: function slots store and clear functions independently" {
    const MTLDevice = @import("MTLDevice.zig").MTLDevice;
    const pool = z.objc_autoreleasePoolPush();
    defer z.objc_autoreleasePoolPop(pool);
    const device = MTLDevice.createSystemDefaultDevice() orelse return error.SkipZigTest;
    defer device.release();
    const source = ns.String.init(
        \\#include <metal_stdlib>
        \\using namespace metal;
        \\vertex float4 vertex_main() { return float4(0); }
        \\fragment float4 fragment_main() { return float4(1); }
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
    try std.testing.expectEqual(vertex, descriptor.vertexFunction().?);
    try std.testing.expectEqual(fragment, descriptor.fragmentFunction().?);
    descriptor.setVertexFunction(null);
    try std.testing.expect(descriptor.vertexFunction() == null);
    try std.testing.expectEqual(fragment, descriptor.fragmentFunction().?);
    descriptor.setFragmentFunction(null);
    try std.testing.expect(descriptor.fragmentFunction() == null);
}
