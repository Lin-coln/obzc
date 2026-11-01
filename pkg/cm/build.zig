const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run CoreMedia tests");

    const cm_abi = blk: {
        const trans = b.addTranslateC(.{
            .root_source_file = b.path("ffi/c.h"),
            .target = target,
            .optimize = optimize,
        });
        break :blk trans.addModule("cm-abi");
    };

    const cm = blk: {
        const mod = b.addModule("cm", .{
            .root_source_file = b.path("root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "cm-abi", .module = cm_abi }},
        });
        mod.linkFramework("CoreMedia", .{});

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = cm;
}
