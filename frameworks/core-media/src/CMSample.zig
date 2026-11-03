const c = @import("macos").c;
const cf = @import("core-foundation");

pub const kCMSampleAttachmentKey = enum {
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

    const Self = @This();

    pub fn unwrap(self: Self) *const cf.String {
        const value: c.CFStringRef = switch (self) {
            .NotSync => c.kCMSampleAttachmentKey_NotSync,
            .PartialSync => c.kCMSampleAttachmentKey_PartialSync,
            .HasRedundantCoding => c.kCMSampleAttachmentKey_HasRedundantCoding,
            .IsDependedOnByOthers => c.kCMSampleAttachmentKey_IsDependedOnByOthers,
            .DependsOnOthers => c.kCMSampleAttachmentKey_DependsOnOthers,
            .EarlierDisplayTimesAllowed => c.kCMSampleAttachmentKey_EarlierDisplayTimesAllowed,
            .DisplayImmediately => c.kCMSampleAttachmentKey_DisplayImmediately,
            .DoNotDisplay => c.kCMSampleAttachmentKey_DoNotDisplay,
            .HEVCTemporalLevelInfo => c.kCMSampleAttachmentKey_HEVCTemporalLevelInfo,
            .HEVCTemporalSubLayerAccess => c.kCMSampleAttachmentKey_HEVCTemporalSubLayerAccess,
            .HEVCStepwiseTemporalSubLayerAccess => c.kCMSampleAttachmentKey_HEVCStepwiseTemporalSubLayerAccess,
            .HEVCSyncSampleNALUnitType => c.kCMSampleAttachmentKey_HEVCSyncSampleNALUnitType,
            .AudioIndependentSampleDecoderRefreshCount => c.kCMSampleAttachmentKey_AudioIndependentSampleDecoderRefreshCount,
            .CryptorSubsampleAuxiliaryData => c.kCMSampleAttachmentKey_CryptorSubsampleAuxiliaryData,
            .HDR10PlusPerFrameData => c.kCMSampleAttachmentKey_HDR10PlusPerFrameData,
            .PostDecodeProcessingMetadata => c.kCMSampleAttachmentKey_PostDecodeProcessingMetadata,
        };
        return @ptrCast(value.?);
    }
};

test "sample attachment keys resolve" {
    const std = @import("std");
    for (std.meta.tags(kCMSampleAttachmentKey)) |key| {
        try std.testing.expect(@intFromPtr(key.unwrap()) != 0);
    }
}
