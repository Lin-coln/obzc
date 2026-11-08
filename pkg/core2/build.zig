const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run core2 tests");

    const macos, const utils = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("macos", opts).module("macos"),
            b.dependency("utils", opts).module("utils"),
        };
    };

    const core2 = blk: {
        const mod = b.addModule("core2", .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "macos", .module = macos },
                .{ .name = "utils", .module = utils },
            },
        });
        mod.linkSystemLibrary("objc", .{});
        mod.linkFramework("Foundation", .{});

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);

        break :blk mod;
    };

    _ = core2;
}
