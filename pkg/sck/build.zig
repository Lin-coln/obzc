const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run ScreenCaptureKit tests");
    const cf = b.dependency("core-foundation", .{ .target = target, .optimize = optimize }).module("core-foundation");
    const cg = b.dependency("core-graphics", .{ .target = target, .optimize = optimize }).module("core-graphics");
    const cm = b.dependency("core-media", .{ .target = target, .optimize = optimize }).module("core-media");
    const cv = b.dependency("core-video", .{ .target = target, .optimize = optimize }).module("core-video");
    const core = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core");
    const ns = b.dependency("ns", .{ .target = target, .optimize = optimize }).module("ns");

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
