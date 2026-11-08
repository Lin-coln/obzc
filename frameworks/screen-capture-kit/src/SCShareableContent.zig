const AutoReleasePool = @import("runtime").AutoReleasePool;
const std = @import("std");
const z = @import("macos").z;
const ns = @import("foundation");
const cg = @import("core-graphics");
const SCWindow = @import("SCWindow.zig").SCWindow;

pub const SCShareableContent = opaque {
    const Self = @This();
    const h = ns.Object.Mixin(Self);

    pub const _encoding = h._encoding;
    pub const retain = h.retain;
    pub const release = h.release;
    pub const equal = h.equal;
    pub const hash = h.hash;
    pub const class = h.class;
    pub const isKindOfClass = h.isKindOfClass;
    pub const respondsToSelector = h.respondsToSelector;

    pub const windows = h._p("windows", *ns.Array.With(SCWindow)).getter;

    /// The context pointer must remain valid until the completion handler returns.
    pub fn getShareableContent(ctx: anytype, comptime cb: *const fn (@TypeOf(ctx), ?*Self, ?*ns.Error) void) void {
        h._cls(null)._callWithCallback(void, "getShareableContentWithCompletionHandler:", ctx, .{}, cb);
    }

    /// Returns retained content. The caller must release the result.
    pub fn getShareableContentSync() anyerror!*Self {
        return h._cls(null)._callSync(anyerror!*Self, "getShareableContentWithCompletionHandler:", .{});
    }
};

test "SCShareableContent: getShareableContent invokes a Zig completion" {
    // Preflight checks Screen Recording permission without requesting it.
    if (!cg.preflightScreenCaptureAccess()) return error.SkipZigTest;
    const pool = AutoReleasePool.create();
    defer pool.release();

    const State = struct {
        const Self = @This();

        ready: std.Io.Semaphore = .{},
        received_content: bool = false,
        error_code: ?z.NSInteger = null,

        fn complete(state: *Self, content: ?*SCShareableContent, err: ?*ns.Error) void {
            state.received_content = content != null;
            if (err) |value| state.error_code = value.code();
            state.ready.post(std.testing.io);
        }
    };

    const Storage = struct {
        // The SDK may finish after the timeout; its context must remain valid.
        var state: State = .{};
    };
    const state = &Storage.state;
    SCShareableContent.getShareableContent(state, State.complete);
    try state.ready.waitTimeout(std.testing.io, .{ .duration = .{
        .raw = .fromSeconds(10),
        .clock = .awake,
    } });

    if (state.error_code) |code| {
        std.debug.print("SCShareableContent failed with NSError code {d}\n", .{code});
        return error.ShareableContentFailed;
    }
    try std.testing.expect(state.received_content);
}
