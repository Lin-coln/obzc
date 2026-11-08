const std = @import("std");
const z = @import("macos").z;
const cf = @import("core-foundation");
const ns = @import("root.zig");

pub const NSString = opaque {
    pub const Mixin = NSStringMixin;

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
    pub const asCFString = h.asCFString;
    pub const stringWithUTF8String = h.stringWithUTF8String;
    pub const init = h.init;
    pub const length = h.length;
    pub const utf8String = h.utf8String;
};

fn NSStringMixin(comptime T: type) type {
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

        /// Number of UTF-16 code units, which may differ from the UTF-8 byte count.
        pub const length = _p("length", z.NSUInteger).getter;

        pub fn asCFString(self: *const T) *const cf.String {
            return @ptrCast(self);
        }

        /// Returns an autoreleased string. Use it within an autorelease pool.
        pub fn stringWithUTF8String(utf8: [*:0]const u8) ?*T {
            return _cls()._call(?*T, "stringWithUTF8String:", .{utf8});
        }

        pub fn init(utf8: []const u8) ?*T {
            const allocated = _cls()._call(*T, "alloc", .{});
            return _call(allocated, ?*T, "initWithBytes:length:encoding:", .{ utf8.ptr, @as(z.NSUInteger, @intCast(utf8.len)), z.NSUTF8StringEncoding });
        }

        /// Borrows UTF-8 bytes, including embedded NULs. Copy before leaving the current
        /// autorelease pool or releasing the string; the buffer may have a shorter lifetime.
        pub fn utf8String(self: *T) []const u8 {
            if (length(self) == 0) return "";
            const byte_count = _call(self, z.NSUInteger, "lengthOfBytesUsingEncoding:", .{z.NSUTF8StringEncoding});
            return _call(self, ?[*]const u8, "UTF8String", .{}).?[0..@intCast(byte_count)];
        }
    };
}

test "NSString: UTF-8 text and length" {
    const utf8: []const u8 = "café!"[0..5];
    const string = NSString.init(utf8).?;
    defer string.release();

    try std.testing.expectEqualStrings("café", string.utf8String());
    try std.testing.expectEqual(4, string.length());
    try std.testing.expect(string.equal(string));
    try std.testing.expect(string.isKindOfClass(string.class()));
    const readonly: *const NSString = string;
    try std.testing.expectEqual(4, readonly.length());
    try std.testing.expectEqual(4, readonly.asCFString().length());
}

test "NSString: embedded NUL and invalid UTF-8" {
    const string = NSString.init("A\x00B").?;
    defer string.release();
    try std.testing.expectEqual(3, string.length());
    try std.testing.expectEqualStrings("A\x00B", string.utf8String());

    const invalid = [_]u8{0xff};
    try std.testing.expect(NSString.init(&invalid) == null);
}

test "NSString: empty strings and UTF-16 surrogate pairs" {
    const empty = NSString.init("").?;
    defer empty.release();
    try std.testing.expectEqual(0, empty.length());
    try std.testing.expectEqualStrings("", empty.utf8String());

    const emoji = NSString.init("\u{1f600}").?;
    defer emoji.release();
    try std.testing.expectEqual(2, emoji.length());
    try std.testing.expectEqualStrings("\u{1f600}", emoji.utf8String());
}

test "NSString: init copies the caller's UTF-8 bytes" {
    var source = [_]u8{ 'c', 'o', 'p', 'y' };
    const string = NSString.init(&source).?;
    defer string.release();
    @memset(&source, 'x');

    try std.testing.expectEqualStrings("copy", string.utf8String());
}
