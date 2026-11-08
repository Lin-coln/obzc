pub const AutoReleasePool = @import("AutoReleasePool.zig").AutoReleasePool;

pub const Block = @import("block/root.zig").Block;

pub const NSObjectPrototype = @import("NSObject.zig").NSObjectPrototype;

test {
    _ = @import("call.zig");
    _ = @import("block/root.zig");
    _ = @import("block/descriptor.zig");
}
