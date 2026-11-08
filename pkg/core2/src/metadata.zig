const std = @import("std");
const c = @import("macos").c;
const z = @import("macos").z;

pub const Sel = opaque {
    pub const _encoding = ":";
    const Self = @This();

    pub fn get(str: [:0]const u8) *Self {
        return @ptrCast(c.sel_registerName(str).?);
    }
};

pub const cast = struct {
    pub const @"type" = struct {
        pub fn z2c(comptime T: type) type {
            if (T == bool) {
                return c.BOOL;
            } else {
                return T;
            }
        }

        pub fn c2z(comptime T: type) type {
            return if (T == c.BOOL) bool else T;
        }
    };

    pub fn z2c(val: anytype) @"type".z2c(@TypeOf(val)) {
        if (@TypeOf(val) == bool) {
            return if (val) c.YES else c.NO;
        } else {
            return val;
        }
    }

    pub fn c2z(val: anytype) @"type".c2z(@TypeOf(val)) {
        if (@TypeOf(val) == c.BOOL) {
            return val != c.NO;
        } else {
            return val;
        }
    }
};

// pub inline fn e(
//     comptime kind: enum {
//         cls, // #
//         obj, // @
//         sel, // :
//         blk, // @?
//     },
// ) []const u8 {
//     return switch (kind) {
//         .cls => "#",
//         .obj => "@",
//         .sel => ":",
//         .blk => "@?",
//     };
// }
