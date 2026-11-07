// Keep objc_object opaque: tagged pointers do not satisfy isa's alignment.
typedef struct objc_class *Class;
typedef struct objc_object *id;
#define OBJC_TYPES_DEFINED 1
#include <objc/objc.h>
#undef OBJC_TYPES_DEFINED

#include <objc/runtime.h>
#include <objc/message.h>
#include <Block.h>

#include <CoreFoundation/CoreFoundation.h>
#include <CoreGraphics/CoreGraphics.h>
#include <CoreMedia/CoreMedia.h>
#include <CoreVideo/CoreVideo.h>
#include <IOSurface/IOSurface.h>
#include <VideoToolbox/VideoToolbox.h>
