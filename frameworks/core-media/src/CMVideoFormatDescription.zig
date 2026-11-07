const c = @import("macos").c;

pub const CMVideoFormatDescription = opaque {
    const Self = @This();

    pub fn getH264ParameterSetAtIndex(
        self: *const Self,
        index: usize,
        parameter_set_pointer_out: ?*?[*]const u8,
        parameter_set_size_out: ?*usize,
        parameter_set_count_out: ?*usize,
        nal_unit_header_length_out: ?*c_int,
    ) c.OSStatus {
        return c.CMVideoFormatDescriptionGetH264ParameterSetAtIndex(
            @ptrCast(self),
            index,
            @ptrCast(parameter_set_pointer_out),
            parameter_set_size_out,
            parameter_set_count_out,
            nal_unit_header_length_out,
        );
    }

    pub fn getDimensions(self: *const Self) c.CMVideoDimensions {
        return c.CMVideoFormatDescriptionGetDimensions(@ptrCast(self));
    }
};
