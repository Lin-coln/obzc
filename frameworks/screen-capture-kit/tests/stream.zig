const std = @import("std");
const core = @import("core");
const cg = @import("core-graphics");
const sck = @import("screen-capture-kit");

test "SCStream: update a window capture stream with a new configuration" {
    // Compile the remaining bindings without starting a capture session.
    std.testing.refAllDecls(sck.Stream);
    if (!cg.preflightScreenCaptureAccess()) return error.SkipZigTest;
    const pool = core.AutoReleasePool.create();
    defer pool.release();
    // Initialize CoreGraphics in this command-line test process before creating a filter.
    _ = cg.c.CGMainDisplayID();
    const content = try sck.ShareableContent.getShareableContentSync();
    defer content.release();
    const windows = content.windows();
    if (windows.count() == 0) return error.SkipZigTest;
    const filter = sck.ContentFilter.init(windows.objectAtIndex(0));
    defer filter.release();
    const configuration = sck.StreamConfiguration.new();
    defer configuration.release();
    configuration.setWidth(128);
    configuration.setHeight(72);
    const stream = sck.Stream.init(filter, configuration, null);
    defer stream.release();
    const updated = sck.StreamConfiguration.new();
    defer updated.release();
    updated.setWidth(256);
    updated.setHeight(144);
    updated.setQueueDepth(4);
    try stream.updateConfigurationSync(updated);
}
