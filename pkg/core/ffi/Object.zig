const e = @import("metadata.zig").e;

/// An Objective-C instance. Opaque so tagged pointers require no object alignment.
pub const Object = opaque {
    pub const _encoding = e(.obj);
    const Self = @This();
};
