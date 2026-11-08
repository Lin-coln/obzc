const AutoReleasePool = @import("runtime").AutoReleasePool;
const std = @import("std");
const z = @import("macos").z;
const mtl = @import("root.zig");

pub const MTLRenderPassColorAttachmentDescriptor = opaque {
    const Self = @This();
    const h = mtl.RenderPassAttachmentDescriptor.Mixin(Self);

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

    pub const texture = h.texture;
    pub const setTexture = h.setTexture;
    pub const loadAction = h.loadAction;
    pub const setLoadAction = h.setLoadAction;
    pub const storeAction = h.storeAction;
    pub const setStoreAction = h.setStoreAction;
    pub const clearColor = h._p("clearColor", z.MTLClearColor).getter;
    pub const setClearColor = h._p("clearColor", z.MTLClearColor).setter;
};

test "MTLRenderPassColorAttachmentDescriptor: clear color struct and attachment actions" {
    const color = MTLRenderPassColorAttachmentDescriptor.new();
    defer color.release();
    try std.testing.expect(color.texture() == null);
    color.setLoadAction(z.MTLLoadActionClear);
    color.setStoreAction(z.MTLStoreActionStore);
    color.setClearColor(.{ .red = 0.25, .green = 0.5, .blue = 0.75, .alpha = 1 });

    try std.testing.expectEqual(@as(z.MTLLoadAction, z.MTLLoadActionClear), color.loadAction());
    try std.testing.expectEqual(@as(z.MTLStoreAction, z.MTLStoreActionStore), color.storeAction());
    const clear = color.clearColor();
    try std.testing.expectEqual(0.25, clear.red);
    try std.testing.expectEqual(0.5, clear.green);
    try std.testing.expectEqual(0.75, clear.blue);
    try std.testing.expectEqual(1, clear.alpha);
}

test "MTLRenderPassColorAttachmentDescriptor: texture can be assigned and cleared" {
    const MTLDevice = @import("MTLDevice.zig").MTLDevice;
    const MTLTextureDescriptor = @import("MTLTextureDescriptor.zig").MTLTextureDescriptor;
    const pool = AutoReleasePool.create();
    defer pool.release();
    const device = MTLDevice.createSystemDefaultDevice() orelse return error.SkipZigTest;
    defer device.release();
    const descriptor = MTLTextureDescriptor.texture2DDescriptor(z.MTLPixelFormatBGRA8Unorm, 8, 4, false);
    const texture = device.newTexture(descriptor).?;
    defer texture.release();
    const color = MTLRenderPassColorAttachmentDescriptor.new();
    defer color.release();

    color.setTexture(texture);
    try std.testing.expectEqual(texture, color.texture().?);
    color.setTexture(null);
    try std.testing.expect(color.texture() == null);
}
