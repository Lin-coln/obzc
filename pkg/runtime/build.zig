const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run runtime tests");

    const macos, const utils = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("macos", opts).module("macos"),
            b.dependency("utils", opts).module("utils"),
        };
    };

    const rt = blk: {
        const mod = b.addModule("runtime", .{
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

    _ = rt;
}
