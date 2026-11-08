const std = @import("std");
const builtin = @import("builtin");
const z = @import("macos").z;
const ns = @import("foundation");
const SCContentFilter = @import("SCContentFilter.zig").SCContentFilter;
const SCStreamConfiguration = @import("SCStreamConfiguration.zig").SCStreamConfiguration;
const SCStreamDelegate = @import("SCStreamDelegate.zig").SCStreamDelegate;
const SCStreamOutput = @import("SCStreamOutput.zig").SCStreamOutput;
const dispatch = std.c.dispatch;

/// SCStreamOutputType from ScreenCaptureKit/SCStream.h.
pub const SCStreamOutputType = enum(z.SCStreamOutputType) {
    screen = z.SCStreamOutputTypeScreen,
    audio = z.SCStreamOutputTypeAudio,
    microphone = z.SCStreamOutputTypeMicrophone,
};

pub const SCStream = opaque {
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

    /// Creates an owned stream. The delegate is optional and borrowed by this call.
    pub fn init(filter: *SCContentFilter, configuration: *SCStreamConfiguration, delegate: ?*SCStreamDelegate) *Self {
        return h._call(h._cls(null).alloc(Self), *Self, "initWithFilter:configuration:delegate:", .{ filter, configuration, delegate });
    }

    /// Adds an output, logging the SDK error on failure.
    pub fn addStreamOutput(self: *Self, output: *SCStreamOutput, output_type: SCStreamOutputType, sample_handler_queue: ?dispatch.queue_t) !void {
        var err: ?*ns.Error = null;
        const succeeded = h._call(self, bool, "addStreamOutput:type:sampleHandlerQueue:error:", .{ output, output_type, sample_handler_queue, &err });
        if (succeeded) return;

        if (err) |ns_error| ns_error.log() else if (!builtin.is_test)
            std.log.err("SCStream.addStreamOutput failed without NSError", .{});
        return error.AddStreamOutputFailed;
    }

    /// Removes an output, logging the SDK error on failure.
    pub fn removeStreamOutput(self: *Self, output: *SCStreamOutput, output_type: SCStreamOutputType) !void {
        var err: ?*ns.Error = null;
        const succeeded = h._call(self, bool, "removeStreamOutput:type:error:", .{ output, output_type, &err });
        if (succeeded) return;

        if (err) |ns_error| ns_error.log() else if (!builtin.is_test)
            std.log.err("SCStream.removeStreamOutput failed without NSError", .{});
        return error.RemoveStreamOutputFailed;
    }

    pub fn startCapture(self: *Self, ctx: anytype, comptime cb: *const fn (@TypeOf(ctx), ?*ns.Error) void) void {
        h._callWithCallback(self, void, "startCaptureWithCompletionHandler:", ctx, .{}, cb);
    }

    pub fn stopCapture(self: *Self, ctx: anytype, comptime cb: *const fn (@TypeOf(ctx), ?*ns.Error) void) void {
        h._callWithCallback(self, void, "stopCaptureWithCompletionHandler:", ctx, .{}, cb);
    }

    pub fn updateContentFilter(self: *Self, ctx: anytype, filter: *SCContentFilter, comptime cb: *const fn (@TypeOf(ctx), ?*ns.Error) void) void {
        h._callWithCallback(self, void, "updateContentFilter:completionHandler:", ctx, .{filter}, cb);
    }

    pub fn updateConfiguration(self: *Self, ctx: anytype, configuration: *SCStreamConfiguration, comptime cb: *const fn (@TypeOf(ctx), ?*ns.Error) void) void {
        h._callWithCallback(self, void, "updateConfiguration:completionHandler:", ctx, .{configuration}, cb);
    }

    /// Waits for completion. The calling thread must not be needed to deliver the callback.
    pub fn startCaptureSync(self: *Self) anyerror!void {
        return h._callSync(self, anyerror!void, "startCaptureWithCompletionHandler:", .{});
    }

    pub fn stopCaptureSync(self: *Self) anyerror!void {
        return h._callSync(self, anyerror!void, "stopCaptureWithCompletionHandler:", .{});
    }

    pub fn updateContentFilterSync(self: *Self, filter: *SCContentFilter) anyerror!void {
        return h._callSync(self, anyerror!void, "updateContentFilter:completionHandler:", .{filter});
    }

    pub fn updateConfigurationSync(self: *Self, configuration: *SCStreamConfiguration) anyerror!void {
        return h._callSync(self, anyerror!void, "updateConfiguration:completionHandler:", .{configuration});
    }
};
