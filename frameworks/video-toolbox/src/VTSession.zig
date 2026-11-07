const c = @import("macos").c;
const cf = @import("core-foundation");

pub const VTSession = opaque {
    pub const Mixin = VTSessionMixin;

    const Self = @This();
    const h = Mixin(Self);

    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const getTypeID = h.getTypeID;
    pub const hash = h.hash;
    pub const getRetainCount = h.getRetainCount;
    pub const setProperty = h.setProperty;
};

fn VTSessionMixin(comptime T: type) type {
    return struct {
        const h = cf.Type.Mixin(T);

        pub const retain = h.retain;
        pub const release = h.release;
        pub const equal = h.equal;
        pub const getTypeID = h.getTypeID;
        pub const hash = h.hash;
        pub const getRetainCount = h.getRetainCount;

        /// The property value is borrowed; VideoToolbox retains it when needed.
        pub fn setProperty(self: *const T, key: *const cf.String, value: ?*const cf.Type) !void {
            if (c.VTSessionSetProperty(@ptrCast(self), @ptrCast(key), @ptrCast(value)) != c.noErr)
                return error.SetPropertyFailed;
        }
    };
}
