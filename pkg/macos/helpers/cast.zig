pub fn raw(comptime T: type, comptime O: type) @TypeOf(RawCaster(T, O).call) {
    return RawCaster(T, O).call;
}

fn RawCaster(comptime T: type, comptime O: type) type {
    return struct {
        pub fn call(self: anytype) if (@TypeOf(self) == *const T) *const O else *O {
            comptime {
                if (@TypeOf(self) != *T and @TypeOf(self) != *const T)
                    @compileError("cast receiver must point to " ++ @typeName(T));
            }
            return @ptrCast(self);
        }
    };
}
