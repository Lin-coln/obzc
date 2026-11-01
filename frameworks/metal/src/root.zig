const std = @import("std");
pub const c = @import("mtl-abi");

pub const BlitCommandEncoder = @import("MTLBlitCommandEncoder.zig").MTLBlitCommandEncoder;
pub const CommandBuffer = @import("MTLCommandBuffer.zig").MTLCommandBuffer;
pub const CommandQueue = @import("MTLCommandQueue.zig").MTLCommandQueue;
pub const CompileOptions = @import("MTLCompileOptions.zig").MTLCompileOptions;
pub const Device = @import("MTLDevice.zig").MTLDevice;
pub const Function = @import("MTLFunction.zig").MTLFunction;
pub const Library = @import("MTLLibrary.zig").MTLLibrary;
pub const RenderCommandEncoder = @import("MTLRenderCommandEncoder.zig").MTLRenderCommandEncoder;
pub const RenderPassColorAttachmentDescriptor = @import("MTLRenderPassColorAttachmentDescriptor.zig").MTLRenderPassColorAttachmentDescriptor;
pub const RenderPassColorAttachmentDescriptorArray = @import("MTLRenderPassColorAttachmentDescriptorArray.zig").MTLRenderPassColorAttachmentDescriptorArray;
pub const RenderPassDescriptor = @import("MTLRenderPassDescriptor.zig").MTLRenderPassDescriptor;
pub const RenderPipelineColorAttachmentDescriptor = @import("MTLRenderPipelineColorAttachmentDescriptor.zig").MTLRenderPipelineColorAttachmentDescriptor;
pub const RenderPipelineColorAttachmentDescriptorArray = @import("MTLRenderPipelineColorAttachmentDescriptorArray.zig").MTLRenderPipelineColorAttachmentDescriptorArray;
pub const RenderPipelineDescriptor = @import("MTLRenderPipelineDescriptor.zig").MTLRenderPipelineDescriptor;
pub const RenderPipelineState = @import("MTLRenderPipelineState.zig").MTLRenderPipelineState;
pub const Texture = @import("MTLTexture.zig").MTLTexture;
pub const TextureDescriptor = @import("MTLTextureDescriptor.zig").MTLTextureDescriptor;

test {
    std.testing.refAllDecls(@This());
}
