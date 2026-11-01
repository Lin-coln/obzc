const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run ScreenCaptureKit tests");
    const cf, const cg, const cm, const cv, const core, const ns = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("core-foundation", opts).module("core-foundation"),
            b.dependency("core-graphics", opts).module("core-graphics"),
            b.dependency("core-media", opts).module("core-media"),
            b.dependency("core-video", opts).module("core-video"),
            b.dependency("core", opts).module("core"),
            b.dependency("ns", opts).module("ns"),
        };
    };

    const sck_abi = blk: {
        const trans = b.addTranslateC(.{
            .root_source_file = b.path("translate/sck.h"),
            .target = target,
            .optimize = optimize,
        });
        break :blk trans.createModule();
    };

    const sck = blk: {
        const opts: std.Build.Module.CreateOptions = .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "core", .module = core },
                .{ .name = "ns", .module = ns },
                .{ .name = "core-foundation", .module = cf },
                .{ .name = "core-graphics", .module = cg },
                .{ .name = "core-media", .module = cm },
                .{ .name = "core-video", .module = cv },
                .{ .name = "sck-abi", .module = sck_abi },
            },
        };

        const mod = b.addModule("sck", opts);
        mod.linkFramework("ScreenCaptureKit", .{ .needed = true });

        const test_mod = b.createModule(opts);
        test_mod.linkFramework("ScreenCaptureKit", .{ .needed = true });
        test_mod.linkFramework("CoreGraphics", .{});
        test_mod.linkFramework("CoreMedia", .{});

        const tests = b.addTest(.{ .root_module = test_mod });
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
                .{ .name = "sck", .module = sck },
                .{ .name = "core-graphics", .module = cg },
                .{ .name = "core-media", .module = cm },
            },
        });

        mod.linkFramework("CoreGraphics", .{});
        mod.linkFramework("CoreMedia", .{});

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = tests;
}
