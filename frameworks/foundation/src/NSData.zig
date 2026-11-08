const std = @import("std");
const z = @import("macos").z;
const ns = @import("root.zig");

pub const NSData = opaque {
    pub const Mixin = NSDataMixin;

    const Self = @This();
    const h = Mixin(Self);

    pub const _encoding = h._encoding;
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;
    pub const new = h.new;
    pub const init = h.init;
    pub const length = h.length;
    pub const bytes = h.bytes;
};

fn NSDataMixin(comptime T: type) type {
    return struct {
        const h = ns.Object.Mixin(T);

        pub const _encoding = h._encoding;
        pub const _cls = h._cls;
        pub const _call = h._call;
        pub const _p = h._p;

        pub const retain = h.retain;
        pub const release = h.release;
        pub const equal = h.equal;
        pub const hash = h.hash;
        pub const class = h.class;
        pub const isKindOfClass = h.isKindOfClass;
        pub const respondsToSelector = h.respondsToSelector;

        pub fn new() *T {
            return _cls()._call(*T, "new", .{});
        }

        /// Copies the bytes into immutable storage owned by the data object.
        pub fn init(contents: []const u8) *T {
            const allocated = _cls()._call(*T, "alloc", .{});
            return _call(allocated, *T, "initWithBytes:length:", .{ contents.ptr, @as(z.NSUInteger, @intCast(contents.len)) });
        }

        pub const length = _p("length", z.NSUInteger).getter;

        /// The returned slice is borrowed and remains valid while the data object is alive.
        pub fn bytes(self: *const T) []const u8 {
            const byte_count = length(self);
            if (byte_count == 0) return "";
            return _call(self, ?[*]const u8, "bytes", .{}).?[0..@intCast(byte_count)];
        }
    };
}

test "NSData: new and init support empty data" {
    const created = NSData.new();
    defer created.release();
    const initialized = NSData.init("");
    defer initialized.release();

    try std.testing.expectEqual(0, created.length());
    try std.testing.expectEqualSlices(u8, "", created.bytes());
    try std.testing.expectEqual(0, initialized.length());
    try std.testing.expectEqualSlices(u8, "", initialized.bytes());
}

test "NSData: init copies bytes including embedded NUL" {
    var source = [_]u8{ 'a', 0, 'b' };
    const data = NSData.init(&source);
    defer data.release();
    source[0] = 'x';

    try std.testing.expectEqual(3, data.length());
    try std.testing.expectEqualSlices(u8, "a\x00b", data.bytes());
    try std.testing.expect(data.equal(data));
    try std.testing.expect(data.isKindOfClass(data.class()));
}
