const std = @import("std");
const z = @import("macos").z;
const builtin = @import("builtin");
const ns = @import("root.zig");

pub const NSError = opaque {
    const Self = @This();
    const h = ns.Object.Mixin(Self);

    pub const _encoding = h._encoding;
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;

    pub fn init(domain_name: []const u8, error_code: z.NSInteger) ?*Self {
        const domain_string = ns.String.init(domain_name) orelse return null;
        defer domain_string.release();

        const allocated = h._cls()._call(*Self, "alloc", .{});
        return h._call(
            allocated,
            ?*Self,
            "initWithDomain:code:userInfo:",
            .{ domain_string, error_code, @as(?*ns.Dictionary(ns.String, ns.Object), null) },
        );
    }

    pub const code = h._p("code", z.NSInteger).getter;
    pub const domain = h._p("domain", *ns.String).getter;
    pub const localizedDescription = h._p("localizedDescription", *ns.String).getter;

    pub fn log(self: *Self) void {
        if (builtin.is_test) return;

        std.log.err("NSError domain={s} code={d} {s}", .{
            self.domain().utf8String(),
            self.code(),
            self.localizedDescription().utf8String(),
        });
    }
};

test "NSError: create and read Objective-C properties" {
    const pool = z.objc_autoreleasePoolPush();
    defer z.objc_autoreleasePoolPop(pool);

    const err = NSError.init("ObjcZigTestDomain", 42).?;
    defer err.release();

    try std.testing.expectEqual(42, err.code());
    try std.testing.expect(err.equal(err));
    try std.testing.expect(err.isKindOfClass(err.class()));

    try std.testing.expectEqualStrings("ObjcZigTestDomain", err.domain().utf8String());

    try std.testing.expect(err.localizedDescription().length() != 0);

    const invalid = [_]u8{0xff};
    try std.testing.expect(NSError.init(&invalid, 42) == null);
}

test "NSError: log is silent during tests" {
    const err = NSError.init("ObjcZigTestDomain", 42).?;
    defer err.release();

    err.log();
}
