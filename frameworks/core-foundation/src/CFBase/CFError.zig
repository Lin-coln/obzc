const c = @import("macos").c;
const cf = @import("../root.zig");

pub const CFError = opaque {
    const Self = @This();
    const h = cf.Type.Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;

    pub fn getTypeID() c.CFTypeID {
        return c.CFErrorGetTypeID();
    }

    pub fn domain(self: *const Self) *const cf.String {
        return @ptrCast(c.CFErrorGetDomain(self.raw()).?);
    }

    pub fn code(self: *const Self) isize {
        return @intCast(c.CFErrorGetCode(self.raw()));
    }

    pub fn copyDescription(self: *const Self) *const cf.String {
        return @ptrCast(c.CFErrorCopyDescription(self.raw()).?);
    }

    pub fn copyFailureReason(self: *const Self) ?*const cf.String {
        return @ptrCast(c.CFErrorCopyFailureReason(self.raw()));
    }

    pub fn copyRecoverySuggestion(self: *const Self) ?*const cf.String {
        return @ptrCast(c.CFErrorCopyRecoverySuggestion(self.raw()));
    }

    fn raw(self: *const Self) c.CFErrorRef {
        return @ptrCast(@constCast(self));
    }
};

pub inline fn kCFErrorDomain(value: enum {
    POSIX,
    OSStatus,
    Mach,
    Cocoa,
}) *const cf.String {
    const raw: c.CFErrorDomain = switch (value) {
        inline else => |domain| @field(c, "kCFErrorDomain" ++ @tagName(domain)),
    };
    return @ptrCast(raw.?);
}

test "CFError reads an error" {
    const std = @import("std");
    const domain_string = cf.kErrorDomain(.POSIX);
    const created = c.CFErrorCreate(null, @ptrCast(domain_string), 42, null) orelse return error.OutOfMemory;
    const err: *CFError = @ptrCast(created);
    defer err.release();

    try std.testing.expectEqual(CFError.getTypeID(), c.CFGetTypeID(@ptrCast(err)));
    try std.testing.expectEqual(@as(isize, 42), err.code());
    try std.testing.expect(err.domain().equal(domain_string));

    const description = err.copyDescription();
    defer description.release();
    try std.testing.expect(description.length() > 0);

    if (err.copyFailureReason()) |reason| reason.release();
    if (err.copyRecoverySuggestion()) |suggestion| suggestion.release();
}
