pub const ffi = @import("ffi/root.zig");
pub const c = ffi.c;

test {
    @import("std").testing.refAllDecls(@This());
}

test "CoreVideo Metal C ABI remains stable for framework imports" {
    comptime {
        const CreateCache = fn (c.CFAllocatorRef, c.CFDictionaryRef, ?*anyopaque, c.CFDictionaryRef, [*c]c.CVMetalTextureCacheRef) callconv(.c) c.CVReturn;
        const CreateTexture = fn (c.CFAllocatorRef, c.CVMetalTextureCacheRef, c.CVImageBufferRef, c.CFDictionaryRef, c_ulong, usize, usize, usize, [*c]c.CVMetalTextureRef) callconv(.c) c.CVReturn;
        const GetTexture = fn (c.CVMetalTextureRef) callconv(.c) ?*anyopaque;
        if (@TypeOf(c.CVMetalTextureCacheCreate) != CreateCache or
            @TypeOf(c.CVMetalTextureCacheCreateTextureFromImage) != CreateTexture or
            @TypeOf(c.CVMetalTextureGetTexture) != GetTexture)
        {
            @compileError("CoreVideo Metal C ABI shape changed; preserve macos.c before changing framework bindings");
        }
    }
}
