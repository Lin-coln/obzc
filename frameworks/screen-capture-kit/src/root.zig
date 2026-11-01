const std = @import("std");
pub const c = @import("sck-abi");
pub const StreamConfiguration = @import("SCStreamConfiguration.zig").SCStreamConfiguration;
pub const CaptureResolutionType = @import("SCStreamConfiguration.zig").SCCaptureResolutionType;
pub const ShareableContent = @import("SCShareableContent.zig").SCShareableContent;
pub const Window = @import("SCWindow.zig").SCWindow;
pub const RunningApplication = @import("SCRunningApplication.zig").SCRunningApplication;
pub const ContentFilter = @import("SCContentFilter.zig").SCContentFilter;
pub const Stream = @import("SCStream.zig").SCStream;
pub const StreamOutputType = @import("SCStream.zig").SCStreamOutputType;
pub const StreamDelegate = @import("SCStreamDelegate.zig").SCStreamDelegate;
pub const StreamOutput = @import("SCStreamOutput.zig").SCStreamOutput;

test {
    std.testing.refAllDecls(@This());
}
