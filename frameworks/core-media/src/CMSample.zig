const c = @import("macos").c;
const cf = @import("core-foundation");

pub inline fn kCMSampleAttachmentKey(value: enum {
    NotSync,
    PartialSync,
    HasRedundantCoding,
    IsDependedOnByOthers,
    DependsOnOthers,
    EarlierDisplayTimesAllowed,
    DisplayImmediately,
    DoNotDisplay,
    HEVCTemporalLevelInfo,
    HEVCTemporalSubLayerAccess,
    HEVCStepwiseTemporalSubLayerAccess,
    HEVCSyncSampleNALUnitType,
    AudioIndependentSampleDecoderRefreshCount,
    CryptorSubsampleAuxiliaryData,
    HDR10PlusPerFrameData,
    PostDecodeProcessingMetadata,
}) *const cf.String {
    const raw: c.CFStringRef = switch (value) {
        inline else => |key| @field(c, "kCMSampleAttachmentKey_" ++ @tagName(key)),
    };
    return @ptrCast(raw.?);
}

test "sample attachment keys resolve" {
    const std = @import("std");
    try std.testing.expect(kCMSampleAttachmentKey(.NotSync).equal(@ptrCast(c.kCMSampleAttachmentKey_NotSync.?)));
    try std.testing.expect(kCMSampleAttachmentKey(.HDR10PlusPerFrameData).equal(@ptrCast(c.kCMSampleAttachmentKey_HDR10PlusPerFrameData.?)));
}
