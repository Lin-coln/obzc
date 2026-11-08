const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run runtime tests");

    const macos, const utils, const encode = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        const utils = b.dependency("utils", opts);
        break :blk .{
            b.dependency("macos", opts).module("macos"),
            utils.module("utils"),
            utils.module("encode"),
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
                .{ .name = "utils/encode", .module = encode },
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
