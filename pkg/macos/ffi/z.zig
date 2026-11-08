const c = @import("c.zig").c;

// Apple Block ABI constants from libclosure's Block_private.h.
pub const BLOCK_HAS_COPY_DISPOSE: c_int = 1 << 25;
pub const BLOCK_USE_STRET: c_int = 1 << 29;
pub const BLOCK_HAS_SIGNATURE: c_int = 1 << 30;
pub const BLOCK_FIELD_IS_OBJECT: c_int = 3;

// libobjc exports these functions, but public SDK headers do not declare them.
// Signatures follow Apple's objc4 runtime/objc-internal.h.
pub extern fn objc_retain(obj: c.id) c.id;
pub extern fn objc_release(obj: c.id) void;
pub extern fn objc_autoreleasePoolPush() *anyopaque;
pub extern fn objc_autoreleasePoolPop(context: *anyopaque) void;

// objc/NSObjCRuntime.h selects long/unsigned long when __LP64__ is true,
// otherwise int/unsigned int. NS_BUILD_32_LIKE_64 can also select long,
// but neither the SDK nor this package defines that override.
// Zig evaluates these target ABI properties at compile time.
const __LP64__ = @bitSizeOf(usize) == 64 and @bitSizeOf(c_long) == 64;
pub const NSInteger = if (__LP64__) c_long else c_int;
pub const NSUInteger = if (__LP64__) c_ulong else c_uint;

// Foundation/NSString.h.
pub const NSStringEncoding = NSUInteger;
pub const NSUTF8StringEncoding: NSStringEncoding = 4;

// Metal/MTLPixelFormat.h, MTLTexture.h, and MTLResource.h.
pub const MTLPixelFormat = NSUInteger;
pub const MTLPixelFormatInvalid: MTLPixelFormat = 0;
pub const MTLPixelFormatBGRA8Unorm: MTLPixelFormat = 80;
pub const MTLPixelFormatRGBA16Float: MTLPixelFormat = 115;

pub const MTLTextureUsage = NSUInteger;
pub const MTLTextureUsageShaderRead: MTLTextureUsage = 0x0001;
pub const MTLTextureUsageRenderTarget: MTLTextureUsage = 0x0004;

pub const MTLStorageMode = NSUInteger;
pub const MTLStorageModeShared: MTLStorageMode = 0;
pub const MTLStorageModePrivate: MTLStorageMode = 2;

// Metal/MTLLibrary.h.
pub const MTLFunctionType = NSUInteger;
pub const MTLFunctionTypeVertex: MTLFunctionType = 1;
pub const MTLFunctionTypeFragment: MTLFunctionType = 2;
pub const MTLFunctionTypeKernel: MTLFunctionType = 3;

// Metal/MTLRenderPass.h.
pub const MTLClearColor = extern struct {
    red: f64,
    green: f64,
    blue: f64,
    alpha: f64,
};

pub const MTLLoadAction = NSUInteger;
pub const MTLLoadActionDontCare: MTLLoadAction = 0;
pub const MTLLoadActionLoad: MTLLoadAction = 1;
pub const MTLLoadActionClear: MTLLoadAction = 2;

pub const MTLStoreAction = NSUInteger;
pub const MTLStoreActionDontCare: MTLStoreAction = 0;
pub const MTLStoreActionStore: MTLStoreAction = 1;

// Metal/MTLRenderCommandEncoder.h and MTLCommandBuffer.h.
pub const MTLPrimitiveType = NSUInteger;
pub const MTLPrimitiveTypeTriangleStrip: MTLPrimitiveType = 4;

pub const MTLCommandBufferStatus = NSUInteger;
pub const MTLCommandBufferStatusCompleted: MTLCommandBufferStatus = 4;
pub const MTLCommandBufferStatusError: MTLCommandBufferStatus = 5;

// Metal/MTLDevice.h: the result is an owned Objective-C object pointer.
pub extern fn MTLCreateSystemDefaultDevice() c.id;

// ScreenCaptureKit/SCStream.h.
pub const SCStreamOutputType = NSInteger;
pub const SCStreamOutputTypeScreen: SCStreamOutputType = 0;
pub const SCStreamOutputTypeAudio: SCStreamOutputType = 1;
pub const SCStreamOutputTypeMicrophone: SCStreamOutputType = 2;

pub const SCCaptureResolutionType = NSInteger;
pub const SCCaptureResolutionAutomatic: SCCaptureResolutionType = 0;
pub const SCCaptureResolutionBest: SCCaptureResolutionType = 1;
pub const SCCaptureResolutionNominal: SCCaptureResolutionType = 2;

pub const SCStreamFrameInfo = c.id;
pub extern var SCStreamFrameInfoContentRect: SCStreamFrameInfo;
pub extern var SCStreamFrameInfoContentScale: SCStreamFrameInfo;
pub extern var SCStreamFrameInfoScaleFactor: SCStreamFrameInfo;

// Vision/VNRecognizeTextRequest.h.
pub const VNRequestTextRecognitionLevel = NSInteger;
pub const VNRequestTextRecognitionLevelAccurate: VNRequestTextRecognitionLevel = 0;
pub const VNRequestTextRecognitionLevelFast: VNRequestTextRecognitionLevel = 1;

// CoreVideo/CVMetalTexture.h and CVMetalTextureCache.h declare these only in
// Objective-C mode. The functions retain their C ABI.
pub const CVMetalTextureRef = c.CVImageBufferRef;
pub const CVMetalTextureCache = opaque {};
pub const CVMetalTextureCacheRef = ?*CVMetalTextureCache;

pub extern fn CVMetalTextureCacheCreate(
    allocator: c.CFAllocatorRef,
    cache_attributes: c.CFDictionaryRef,
    metal_device: *c.struct_objc_object,
    texture_attributes: c.CFDictionaryRef,
    cache_out: *CVMetalTextureCacheRef,
) c.CVReturn;

pub extern fn CVMetalTextureCacheCreateTextureFromImage(
    allocator: c.CFAllocatorRef,
    texture_cache: *CVMetalTextureCache,
    source_image: c.CVImageBufferRef,
    texture_attributes: c.CFDictionaryRef,
    pixel_format: MTLPixelFormat,
    width: usize,
    height: usize,
    plane_index: usize,
    texture_out: *CVMetalTextureRef,
) c.CVReturn;

pub extern fn CVMetalTextureGetTexture(image: CVMetalTextureRef) c.id;
