const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run CoreVideo tests");
    const cf, const ios = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("core-foundation", opts).module("core-foundation"),
            b.dependency("io-surface", opts).module("io-surface"),
        };
    };

    const cv_abi = blk: {
        const trans = b.addTranslateC(.{
            .root_source_file = b.path("ffi/c.h"),
            .target = target,
            .optimize = optimize,
        });
        break :blk trans.addModule("core-video-abi");
    };

    const cv = blk: {
        const mod = b.addModule("core-video", .{
            .root_source_file = b.path("root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "core-video-abi", .module = cv_abi },
                .{ .name = "core-foundation", .module = cf },
                .{ .name = "io-surface", .module = ios },
            },
        });
        mod.linkFramework("CoreVideo", .{});

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = cv;
}
