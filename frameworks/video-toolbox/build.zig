const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const test_step = b.step("test", "Run VideoToolbox tests");
    const macos, const cf, const cm, const cv = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("macos", opts).module("macos"),
            b.dependency("core-foundation", opts).module("core-foundation"),
            b.dependency("core-media", opts).module("core-media"),
            b.dependency("core-video", opts).module("core-video"),
        };
    };

    const vt = blk: {
        const mod = b.addModule("video-toolbox", .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "macos", .module = macos },
                .{ .name = "core-foundation", .module = cf },
                .{ .name = "core-media", .module = cm },
                .{ .name = "core-video", .module = cv },
            },
        });
        mod.linkFramework("VideoToolbox", .{ .needed = true });

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = vt;
}
