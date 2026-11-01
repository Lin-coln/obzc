const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run Metal tests");
    const cf, const cv, const ios, const core, const ns = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("core-foundation", opts).module("core-foundation"),
            b.dependency("core-video", opts).module("core-video"),
            b.dependency("io-surface", opts).module("io-surface"),
            b.dependency("core", opts).module("core"),
            b.dependency("ns", opts).module("ns"),
        };
    };

    const mtl_abi = blk: {
        const trans = b.addTranslateC(.{
            .root_source_file = b.path("translate/metal.h"),
            .target = target,
            .optimize = optimize,
        });
        const mod = trans.createModule();
        break :blk mod;
    };

    const mtl = blk: {
        const mod = b.addModule("mtl", .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "core", .module = core },
                .{ .name = "ns", .module = ns },
                .{ .name = "io-surface", .module = ios },
                .{ .name = "mtl-abi", .module = mtl_abi },
            },
        });

        mod.linkFramework("Metal", .{ .needed = true });

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    const tests = blk: {
        const mod = b.createModule(.{
            .root_source_file = b.path("tests/tests.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "core", .module = core },
                .{ .name = "ns", .module = ns },
                .{ .name = "mtl", .module = mtl },
                .{ .name = "core-foundation", .module = cf },
                .{ .name = "core-video", .module = cv },
                .{ .name = "io-surface", .module = ios },
            },
        });

        mod.linkFramework("CoreVideo", .{});
        mod.linkFramework("IOSurface", .{});

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = tests;
}
