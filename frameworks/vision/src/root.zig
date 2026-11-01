const std = @import("std");
pub const Request = @import("VNRequest.zig").VNRequest;
pub const RecognizeTextRequest = @import("VNRecognizeTextRequest.zig").VNRecognizeTextRequest;
pub const RequestTextRecognitionLevel = @import("VNRecognizeTextRequest.zig").VNRequestTextRecognitionLevel;
pub const ImageRequestHandler = @import("VNImageRequestHandler.zig").VNImageRequestHandler;
pub const RecognizedTextObservation = @import("VNRecognizedTextObservation.zig").VNRecognizedTextObservation;
pub const RecognizedText = @import("VNRecognizedText.zig").VNRecognizedText;

test {
    std.testing.refAllDecls(@This());
}
