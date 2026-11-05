const c = @import("macos").c;

pub inline fn kCFStringEncoding(kind: enum {
    MacRoman,
    WindowsLatin1,
    ISOLatin1,
    NextStepLatin,
    ASCII,
    Unicode,
    UTF8,
    NonLossyASCII,
    UTF16,
    UTF16BE,
    UTF16LE,
    UTF32,
    UTF32BE,
    UTF32LE,
}) c.CFStringEncoding {
    return switch (kind) {
        inline else => |value| @field(c, "kCFStringEncoding" ++ @tagName(value)),
    };
}

test "built-in string encodings use the Core Foundation values" {
    const std = @import("std");
    try std.testing.expectEqual(@as(c.CFStringEncoding, c.kCFStringEncodingUTF8), kCFStringEncoding(.UTF8));
    try std.testing.expectEqual(kCFStringEncoding(.Unicode), kCFStringEncoding(.UTF16));
}
