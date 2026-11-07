const std = @import("std");
const e = @import("metadata.zig").e;
const c = @import("macos").c;
const Property = @import("Property.zig").Property;
const Sel = @import("Sel.zig").Sel;

pub const Protocol = opaque {
    pub const _encoding = e(.obj);
    const Self = @This();

    pub fn lookup(name: [:0]const u8) ?*Self {
        return @ptrCast(c.objc_getProtocol(name));
    }
};
