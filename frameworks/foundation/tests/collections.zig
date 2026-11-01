const std = @import("std");
const core = @import("core");
const ns = @import("foundation");

test "NSDictionary: nested arrays survive their creators and autorelease pool" {
    const Strings = ns.Array(ns.String);
    const Dictionary = ns.Dictionary(ns.String, Strings);
    const dictionary = created: {
        const pool = core.AutoReleasePool.create();
        defer pool.release();
        const key = ns.String.init("nested collection contents").?;
        defer key.release();
        const first = ns.String.init("first retained collection element").?;
        defer first.release();
        const second = ns.String.init("second retained collection element").?;
        defer second.release();
        const strings = Strings.init(&.{ first, second });
        defer strings.release();

        break :created Dictionary.init(&.{strings}, &.{key});
    };
    defer dictionary.release();

    // Look up an equal key created after the original key and pool were released.
    const key = ns.String.init("nested collection contents").?;
    defer key.release();
    const strings = dictionary.objectForKey(key).?;
    try std.testing.expectEqual(1, dictionary.count());
    try std.testing.expectEqual(2, strings.count());
    try std.testing.expectEqualStrings("first retained collection element", strings.objectAtIndex(0).utf8String());
    try std.testing.expectEqualStrings("second retained collection element", strings.objectAtIndex(1).utf8String());
}
