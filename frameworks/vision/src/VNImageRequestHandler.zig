const AutoReleasePool = @import("runtime").AutoReleasePool;
const std = @import("std");
const builtin = @import("builtin");
const ns = @import("foundation");
const cv = @import("core-video");
const VNRequest = @import("VNRequest.zig").VNRequest;
const VNRecognizeTextRequest = @import("VNRecognizeTextRequest.zig").VNRecognizeTextRequest;

pub const VNImageRequestHandler = opaque {
    const Self = @This();
    const h = ns.Object.Mixin(Self);
    const Options = ns.Dictionary.WithKey(ns.String);

    pub const _encoding = h._encoding;
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;

    /// Retains the image source, which must not be modified while the handler is alive.
    pub fn initWithData(data: *const ns.Data, options: *Options) *Self {
        const allocated = h._cls(null).alloc(Self);
        return h._call(allocated, *Self, "initWithData:options:", .{ data, options });
    }

    /// Retains the image source, which must not be modified while the handler is alive.
    pub fn initWithCVPixelBuffer(pixel_buffer: ?*cv.PixelBuffer, options: *Options) *Self {
        const allocated = h._cls(null).alloc(Self);
        return h._call(allocated, *Self, "initWithCVPixelBuffer:options:", .{ pixel_buffer, options });
    }

    /// Runs the requests synchronously, logging the SDK error on failure.
    pub fn performRequests(self: *Self, requests: *ns.Array.With(VNRequest)) !void {
        var err: ?*ns.Error = null;
        const succeeded = h._call(self, bool, "performRequests:error:", .{ requests, &err });
        if (succeeded) return;

        if (err) |ns_error| ns_error.log() else if (!builtin.is_test)
            std.log.err("VNImageRequestHandler.performRequests failed without NSError", .{});
        return error.PerformRequestsFailed;
    }
};

test "VNImageRequestHandler: invalid image data fails without producing results" {
    const pool = AutoReleasePool.create();
    defer pool.release();
    const data = ns.Data.init("not an image");
    defer data.release();
    const options = ns.Dictionary.WithKey(ns.String).new();
    defer options.release();
    const handler = VNImageRequestHandler.initWithData(data, options);
    defer handler.release();
    const request = VNRecognizeTextRequest.new();
    defer request.release();
    const requests = ns.Array.With(VNRequest).init(&.{@ptrCast(request)});
    defer requests.release();

    try std.testing.expectError(error.PerformRequestsFailed, handler.performRequests(requests));
    try std.testing.expect(request.results() == null);
}
