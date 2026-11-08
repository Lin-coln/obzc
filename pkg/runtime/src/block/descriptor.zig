const std = @import("std");
const c = @import("macos").c;
const z = @import("macos").z;

/// Descriptor for a block with a signature and no copy/dispose helpers.
pub fn Descriptor(comptime Block: type) type {
    return extern struct {
        const Self = @This();

        reserved: c_ulong,
        size: c_ulong,
        signature: [*:0]const u8,
        pub fn init(signature: [*:0]const u8) Self {
            return .{
                .reserved = 0,
                .size = @sizeOf(Block),
                .signature = signature,
            };
        }
    };
}

// Descriptor with ownership callbacks for a context that is itself an Objective-C object pointer.
// Currently not selected by `Block`; this does not traverse fields of aggregate contexts.
// pub fn DescriptorWithHelpers(comptime Block: type) type {
//     return extern struct {
//         const Self = @This();
//         reserved: c_ulong,
//         size: c_ulong,
//         copy_helper: *const fn (dst: *Block, src: *const Block) callconv(.c) void,
//         dispose_helper: *const fn (src: *const Block) callconv(.c) void,
//         signature: [*:0]const u8,
//
//         pub fn init(signature: [*:0]const u8) Self {
//             return .{
//                 .reserved = 0,
//                 .size = @sizeOf(Block),
//                 .copy_helper = &copyHelper,
//                 .dispose_helper = &disposeHelper,
//                 .signature = signature,
//             };
//         }
//
//         /// Called by `_Block_copy` on the new heap block after copying `src` into it bytewise.
//         fn copyHelper(dst: *Block, src: *const Block) callconv(.c) void {
//             c._Block_object_assign(@ptrCast(&dst.context), src.context, z.BLOCK_FIELD_IS_OBJECT);
//         }
//
//         /// Called by the last `_Block_release` of a heap block before freeing it.
//         fn disposeHelper(src: *const Block) callconv(.c) void {
//             c._Block_object_dispose(src.context, z.BLOCK_FIELD_IS_OBJECT);
//         }
//     };
// }

test "Descriptor.init: reserved, block size and signature" {
    const B = extern struct { header: usize, context: i32 };
    const signature: [:0]const u8 = "v@?";
    const descriptor = Descriptor(B).init(signature);
    try std.testing.expectEqual(@as(c_ulong, 0), descriptor.reserved);
    try std.testing.expectEqual(@as(c_ulong, @sizeOf(B)), descriptor.size);
    try std.testing.expectEqual(signature.ptr, descriptor.signature);
}
