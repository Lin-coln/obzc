const std = @import("std");
const core = @import("core");
const Object = core.ffi.Object;
const ns = @import("foundation");
const vision = @import("vision");
const cv = @import("core-video");
const VNRequest = vision.VNRequest;
const VNRecognizeTextRequest = vision.VNRecognizeTextRequest;
const VNImageRequestHandler = vision.VNImageRequestHandler;

test "text recognition: encoded image data produces readable candidates" {
    const pool = core.AutoReleasePool.create();
    defer pool.release();
    const handler = blk: {
        const data = ns.Data.init(@embedFile("fixtures/text.png"));
        defer data.release();
        const options = ns.Dictionary(ns.String, Object).new();
        defer options.release();
        break :blk VNImageRequestHandler.initWithData(data, options);
    };
    defer handler.release();
    const request = VNRecognizeTextRequest.new();
    defer request.release();
    request.setRecognitionLevel(.fast);
    request.setUsesLanguageCorrection(false);
    const language = ns.String.init("en-US").?;
    defer language.release();
    const languages = ns.Array(ns.String).init(&.{language});
    defer languages.release();
    request.setRecognitionLanguages(languages);
    const requests = ns.Array(VNRequest).init(&.{@ptrCast(request)});
    defer requests.release();

    // The handler must keep the image source alive after its caller releases it.
    try handler.performRequests(requests);
    const results = request.results().?;
    try std.testing.expect(results.count() > 0);
    var recognized_hello = false;
    const tolerance = 0.000001;
    for (0..results.count()) |index| {
        const observation = results.objectAtIndex(index);
        try std.testing.expect(observation.confidence() >= 0 and observation.confidence() <= 1);
        const bounds = observation.boundingBox();
        try std.testing.expect(bounds.origin.x >= -tolerance and bounds.origin.x <= 1 + tolerance);
        try std.testing.expect(bounds.origin.y >= -tolerance and bounds.origin.y <= 1 + tolerance);
        try std.testing.expect(bounds.size.width > 0 and bounds.size.width <= 1 + tolerance);
        try std.testing.expect(bounds.size.height > 0 and bounds.size.height <= 1 + tolerance);
        try std.testing.expect(bounds.origin.x + bounds.size.width <= 1 + tolerance);
        try std.testing.expect(bounds.origin.y + bounds.size.height <= 1 + tolerance);
        const candidates = observation.topCandidates(1);
        try std.testing.expect(candidates.count() <= 1);
        for (0..candidates.count()) |candidate_index| {
            const candidate = candidates.objectAtIndex(candidate_index);
            try std.testing.expect(candidate.confidence() >= 0 and candidate.confidence() <= 1);
            const text = candidate.string().utf8String();
            try std.testing.expect(text.len > 0);
            if (std.mem.eql(u8, text, "HELLO")) recognized_hello = true;
        }
    }
    try std.testing.expect(recognized_hello);
}

test "text recognition: a blank pixel buffer produces an empty result" {
    const pool = core.AutoReleasePool.create();
    defer pool.release();
    const handler = created: {
        const pixel_buffer = cv.Buffer.create(256, 128, cv.c.kCVPixelFormatType_32BGRA, null) orelse
            return error.PixelBufferCreationFailed;
        defer pixel_buffer.release();
        {
            try std.testing.expect(pixel_buffer.lockBaseAddress(0));
            defer _ = pixel_buffer.unlockBaseAddress(0);
            const pixels = pixel_buffer.getBaseAddress().?;
            @memset(pixels[0..pixel_buffer.getDataSize()], 255);
        }
        const options = ns.Dictionary(ns.String, Object).new();
        defer options.release();
        break :created VNImageRequestHandler.initWithCVPixelBuffer(pixel_buffer, options);
    };
    defer handler.release();
    const request = VNRecognizeTextRequest.new();
    defer request.release();
    request.setRecognitionLevel(.fast);
    request.setUsesLanguageCorrection(false);
    const requests = ns.Array(VNRequest).init(&.{@ptrCast(request)});
    defer requests.release();

    // The handler owns the image source after the caller releases its pixel buffer.
    try handler.performRequests(requests);
    try std.testing.expectEqual(0, request.results().?.count());
}
