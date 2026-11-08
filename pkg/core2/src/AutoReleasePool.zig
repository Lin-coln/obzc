const std = @import("std");
const c = @import("macos").c;
const z = @import("macos").z;

pub const AutoReleasePool = opaque {
    const Self = @This();

    pub fn create() *Self {
        return @ptrCast(z.objc_autoreleasePoolPush());
    }

    pub fn release(self: *Self) void {
        z.objc_autoreleasePoolPop(self);
    }
};
