const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run CoreGraphics tests");
    const cf = b.dependency("core-foundation", .{ .target = target, .optimize = optimize }).module("core-foundation");

    const cg_abi = blk: {
        const trans = b.addTranslateC(.{
            .root_source_file = b.path("ffi/c.h"),
            .target = target,
            .optimize = optimize,
        });
        break :blk trans.addModule("core-graphics-abi");
    };

    const cg = blk: {
        const mod = b.addModule("core-graphics", .{
            .root_source_file = b.path("root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "core-graphics-abi", .module = cg_abi },
                .{ .name = "core-foundation", .module = cf },
            },
        });
        mod.linkFramework("CoreGraphics", .{});

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = cg;
}
