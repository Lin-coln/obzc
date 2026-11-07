const c = @import("macos").c;
const cf = @import("core-foundation");

pub const VTSession = opaque {
    const Self = @This();

    /// The property value is borrowed; VideoToolbox retains it when needed.
    pub fn setProperty(self: *Self, key: *const cf.String, value: ?*const cf.Type) c.OSStatus {
        return c.VTSessionSetProperty(@ptrCast(self), @ptrCast(key), @ptrCast(value));
    }
};
