const std = @import("std");
const core = @import("core");
const cm = @import("core-media");
const sck = @import("screen-capture-kit");

const Context = struct {
    calls: usize = 0,
    stream: ?*sck.Stream = null,
    sample_buffer: ?*cm.SampleBuffer = null,
    output_type: ?sck.StreamOutputType = null,
};

const SCKStreamOutputTest = opaque {
    pub const metadata = core.Metadata.obj;
    const Self = @This();
    const h = core.h(Self);
    pub const release = h.release;
    pub const context = h.ivar("context", *Context).getter;
    pub const setContext = h.ivar("context", *Context).setter;

    /// The caller must release every instance before disposing the registered class.
    pub fn registerClass() !*core.ffi.Class {
        const cls = try h.f.allocate("NSObject");
        errdefer cls.dispose();

        try h.f.addProtocol(cls, "SCStreamOutput");
        try h.f.addIvar(cls, "context", *Context);
        try h.f.addMethod(cls, "stream:didOutputSampleBuffer:ofType:", receive);

        cls.register();
        return cls;
    }

    pub fn new(ctx: *Context) *Self {
        const self = h.cls.new();
        self.setContext(ctx);
        return self;
    }

    fn receive(self: *Self, _: *core.ffi.Sel, stream: *sck.Stream, sample_buffer: ?*cm.SampleBuffer, output_type: sck.StreamOutputType) callconv(.c) void {
        const ctx = self.context();
        ctx.calls += 1;
        ctx.stream = stream;
        ctx.sample_buffer = sample_buffer;
        ctx.output_type = output_type;
    }
};

test "SCKStreamOutputTest: routes callback arguments to each instance context" {
    const cls = try SCKStreamOutputTest.registerClass();
    defer cls.dispose();

    var first_context: Context = .{};
    var second_context: Context = .{};
    const first = SCKStreamOutputTest.new(&first_context);
    defer first.release();
    const second = SCKStreamOutputTest.new(&second_context);
    defer second.release();

    // Opaque argument tokens: the callback only stores them and never dereferences them.
    const stream: *sck.Stream = @ptrFromInt(0x1000);
    const sample_buffer: ?*cm.SampleBuffer = @ptrFromInt(0x2000);
    const h = core.h(SCKStreamOutputTest);
    h.call(first, void, "stream:didOutputSampleBuffer:ofType:", .{ stream, sample_buffer, sck.StreamOutputType.screen });
    h.call(second, void, "stream:didOutputSampleBuffer:ofType:", .{ stream, sample_buffer, sck.StreamOutputType.audio });

    try std.testing.expectEqual(1, first_context.calls);
    try std.testing.expectEqual(1, second_context.calls);
    for ([_]*Context{ &first_context, &second_context }) |context| {
        try std.testing.expectEqual(stream, context.stream.?);
        try std.testing.expectEqual(sample_buffer, context.sample_buffer);
    }
    try std.testing.expectEqual(sck.StreamOutputType.screen, first_context.output_type.?);
    try std.testing.expectEqual(sck.StreamOutputType.audio, second_context.output_type.?);
}
