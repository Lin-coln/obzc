const ns = @import("foundation");

pub const VNRecognizedText = opaque {
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

    pub const confidence = h._p("confidence", f32).getter;
    /// The string is borrowed from the recognized text.
    pub const string = h._p("string", *ns.String).getter;
};
