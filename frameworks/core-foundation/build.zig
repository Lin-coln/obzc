const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const test_step = b.step("test", "Run CoreFoundation tests");

    const macos = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk b.dependency("macos", opts).module("macos");
    };

    const cf = blk: {
        const mod = b.addModule("core-foundation", .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "macos", .module = macos },
            },
        });
        mod.linkFramework("CoreFoundation", .{});

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = cf;
}
