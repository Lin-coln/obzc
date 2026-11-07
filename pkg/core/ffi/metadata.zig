pub inline fn e(
    comptime kind: enum {
        cls, // #
        obj, // @
        sel, // :
        blk, // @?
    },
) []const u8 {
    return switch (kind) {
        .cls => "#",
        .obj => "@",
        .sel => ":",
        .blk => "@?",
    };
}
