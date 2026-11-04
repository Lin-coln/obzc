const std = @import("std");
const core = @import("core");
const cf = @import("core-foundation");

pub fn NSArray(comptime T: type) type {
    return opaque {
        pub const metadata = core.Metadata.obj;
        const Self = @This();
        const h = core.h(Self);

        pub const retain = h.retain;
        pub const release = h.release;

        pub fn asCFArray(self: *const Self) *const cf.Array.With(T) {
            return @ptrCast(self);
        }

        pub fn init(objects: []const *T) *Self {
            const allocated: *Self = h.cls.alloc();
            return h.call(allocated, ?*Self, "initWithObjects:count:", .{ objects.ptr, objects.len }).?;
        }

        pub const count = h.prop("count", usize).getter;

        /// The returned object is borrowed from the array.
        pub fn objectAtIndex(self: *Self, index: usize) *T {
            return h.call(self, *T, "objectAtIndex:", .{index});
        }
    };
}

test "NSArray: create and read objects" {
    const NSString = @import("NSString.zig").NSString;
    const first = NSString.init("first").?;
    defer first.release();
    const second = NSString.init("second").?;
    defer second.release();

    const objects = [_]*NSString{ first, second };
    const array = NSArray(NSString).init(&objects);
    defer array.release();

    try std.testing.expectEqual(2, array.count());
    try std.testing.expectEqualStrings("first", array.objectAtIndex(0).utf8String());
    try std.testing.expectEqualStrings("second", array.objectAtIndex(1).utf8String());

    const cf_array = array.asCFArray();
    try std.testing.expectEqual(@as(usize, 2), cf_array.getCount());
    try std.testing.expectEqual(@intFromPtr(first), @intFromPtr(cf_array.getValueAtIndex(0).?));
}

test "NSArray: initialize an empty array" {
    const NSString = @import("NSString.zig").NSString;
    const array = NSArray(NSString).init(&.{});
    defer array.release();

    try std.testing.expectEqual(0, array.count());
}
