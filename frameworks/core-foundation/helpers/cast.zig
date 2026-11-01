pub fn cast(comptime T: type, comptime O: type) @TypeOf(Caster(T, O).call) {
    return Caster(T, O).call;
}

fn Caster(comptime T: type, comptime O: type) type {
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
