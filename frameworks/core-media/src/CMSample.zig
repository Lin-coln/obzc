const c = @import("macos").c;
const cf = @import("core-foundation");

pub const kCMSampleAttachmentKey = enum {
    const Self = @This();

    pub fn unwrap(self: Self) *const cf.String {
        const raw: c.CFStringRef = switch (self) {
            inline else => |key| @field(c, "kCMSampleAttachmentKey_" ++ @tagName(key)),
        };
        return @ptrCast(raw.?);
    }

    pub fn fromRaw(raw: c.CFStringRef) ?Self {
        const key: *const cf.String = @ptrCast(raw orelse return null);
        inline for (@import("std").meta.tags(Self)) |candidate| {
            if (key.equal(candidate.unwrap())) return candidate;
        }
        return null;
    }

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
};

test "sample attachment keys resolve" {
    const std = @import("std");
    for (std.meta.tags(kCMSampleAttachmentKey)) |key| {
        try std.testing.expect(@intFromPtr(key.unwrap()) != 0);
        try std.testing.expectEqual(key, kCMSampleAttachmentKey.fromRaw(@ptrCast(key.unwrap())).?);
    }
}
