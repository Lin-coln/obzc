const ns = @import("foundation");
const MTLRenderPassColorAttachmentDescriptorArray = @import("MTLRenderPassColorAttachmentDescriptorArray.zig").MTLRenderPassColorAttachmentDescriptorArray;

pub const MTLRenderPassDescriptor = opaque {
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

    /// Borrowed attachment array, owned by this descriptor.
    pub const colorAttachments = h._p("colorAttachments", *MTLRenderPassColorAttachmentDescriptorArray).getter;
};
