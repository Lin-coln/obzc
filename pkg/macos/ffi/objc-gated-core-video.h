#ifndef OBZC_OBJC_GATED_CORE_VIDEO_H
#define OBZC_OBJC_GATED_CORE_VIDEO_H

// C ABI for the CoreVideo declarations hidden behind __OBJC__ in Apple's
// CVMetalTexture.h and CVMetalTextureCache.h. This header is included by c.h,
// so framework code can continue using macos.c.CVMetalTexture... directly.
// A future generator should emit these same names and C-compatible signatures.
// In Objective-C mode, use the SDK declarations instead of redefining them.
#if COREVIDEO_SUPPORTS_METAL && !defined(__OBJC__)
typedef CVImageBufferRef CVMetalTextureRef;
typedef struct __CVMetalTextureCache *CVMetalTextureCacheRef;

// id<MTLDevice> and id<MTLTexture> are object pointers at the C ABI boundary.
// MTLPixelFormat is unsigned long on the supported macOS targets.
CVReturn CVMetalTextureCacheCreate(
    CFAllocatorRef allocator,
    CFDictionaryRef cache_attributes,
    void *metal_device,
    CFDictionaryRef texture_attributes,
    CVMetalTextureCacheRef *cache_out
);
CVReturn CVMetalTextureCacheCreateTextureFromImage(
    CFAllocatorRef allocator,
    CVMetalTextureCacheRef texture_cache,
    CVImageBufferRef source_image,
    CFDictionaryRef texture_attributes,
    unsigned long pixel_format,
    size_t width,
    size_t height,
    size_t plane_index,
    CVMetalTextureRef *texture_out
);
void *CVMetalTextureGetTexture(CVMetalTextureRef image);
#endif

#endif
