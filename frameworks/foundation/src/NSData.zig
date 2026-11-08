const std = @import("std");
const c = @import("macos").c;
const z = @import("macos").z;
const cf = @import("core-foundation");
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
    pub const createMutable = h.createMutable;
    pub const length = h.length;
    pub const bytes = h.bytes;
    pub const setLength = h.setLength;
    pub const appendBytes = h.appendBytes;
    pub const mutableBytes = h.mutableBytes;
    pub const asCFData = h.asCFData;
};

fn NSDataMixin(comptime T: type) type {
    return struct {
        const h = ns.Object.Mixin(T);

        pub const _encoding = h._encoding;
        pub const _cls = h._cls;
        pub const _call = h._call;
        pub const _p = h._p;

        pub fn retain(self: *const T) *const T {
            return h.retain(@constCast(self));
        }

        pub fn release(self: *const T) void {
            h.release(@constCast(self));
        }

        pub const equal = h.equal;
        pub const hash = h.hash;
        pub const class = h.class;
        pub const isKindOfClass = h.isKindOfClass;
        pub const respondsToSelector = h.respondsToSelector;

        pub fn asCFData(self: *const T) *const cf.Data {
            return @ptrCast(self);
        }

        pub fn new() *const T {
            return _cls(null).new(T);
        }

        /// Copies the bytes into immutable storage owned by the data object.
        pub fn init(contents: []const u8) *const T {
            const allocated = _cls(null).alloc(T);
            return _call(allocated, *T, "initWithBytes:length:", .{ contents.ptr, @as(z.NSUInteger, @intCast(contents.len)) });
        }

        pub fn createMutable() *T {
            // todo should be redesign
            const mutable_class: @TypeOf(_cls(null)) = @ptrCast(c.objc_getClass("NSMutableData").?);
            return mutable_class.new(T);
        }

        pub const length = _p("length", z.NSUInteger).getter;
        pub const setLength = _p("length", z.NSUInteger).setter;

        /// The returned slice is borrowed and remains valid while the data object is alive.
        pub fn bytes(self: *const T) []const u8 {
            const byte_count = length(self);
            if (byte_count == 0) return "";
            return _call(self, ?[*]const u8, "bytes", .{}).?[0..@intCast(byte_count)];
        }

        pub fn appendBytes(self: *T, appended_bytes: []const u8) void {
            if (appended_bytes.len == 0) return;
            _call(self, void, "appendBytes:length:", .{ appended_bytes.ptr, @as(z.NSUInteger, @intCast(appended_bytes.len)) });
        }

        /// The returned pointer is invalidated by mutation or release and may be null when empty.
        pub fn mutableBytes(self: *T) ?[*]u8 {
            return _call(self, ?[*]u8, "mutableBytes", .{});
        }
    };
}

test "NSData: new and init support empty data" {
    const created = NSData.new();
    defer created.release();
    const initialized = NSData.init("");
    defer initialized.release();

    try std.testing.expect(@TypeOf(created) == *const NSData);
    try std.testing.expect(@TypeOf(initialized) == *const NSData);
    try std.testing.expectEqual(0, created.length());
    try std.testing.expectEqual(0, created.asCFData().length());
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
    try std.testing.expectEqual(3, data.asCFData().length());
    try std.testing.expectEqualSlices(u8, "a\x00b", data.bytes());
    try std.testing.expect(data.equal(data));
    try std.testing.expect(data.isKindOfClass(data.class()));
}

test "NSData: mutable instance resizes, edits, and appends bytes" {
    const data = NSData.createMutable();
    defer data.release();

    try std.testing.expect(@TypeOf(data) == *NSData);
    try std.testing.expectEqual(0, data.length());
    try std.testing.expectEqualSlices(u8, "", data.bytes());

    data.setLength(4);
    try std.testing.expectEqualSlices(u8, &.{ 0, 0, 0, 0 }, data.bytes());
    @memcpy(data.mutableBytes().?[0..4], "zig!");
    try std.testing.expectEqualSlices(u8, "zig!", data.bytes());

    data.setLength(2);
    data.appendBytes("?");
    try std.testing.expectEqual(3, data.length());
    try std.testing.expectEqualSlices(u8, "zi?", data.bytes());

    data.appendBytes("");
    try std.testing.expectEqualSlices(u8, "zi?", data.bytes());
    data.setLength(0);
    try std.testing.expectEqual(0, data.length());
}
