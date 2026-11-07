const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run Objective-C tests");

    const macos, const utils, const encode = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        const utils_dep = b.dependency("utils", opts);
        break :blk .{
            b.dependency("macos", opts).module("macos"),
            utils_dep.module("utils"),
            utils_dep.module("encode"),
        };
    };
    test_step.dependOn(addCompileErrorTests(b, target, optimize, macos, utils, encode));

    const core = blk: {
        const opts: std.Build.Module.CreateOptions = .{
            .root_source_file = b.path("root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "macos", .module = macos },
                .{ .name = "utils", .module = utils },
                .{ .name = "utils/encode", .module = encode },
            },
        };

        const mod = b.addModule("core", opts);
        mod.linkSystemLibrary("objc", .{});

        const test_mod = b.createModule(opts);
        test_mod.linkSystemLibrary("objc", .{});
        test_mod.linkFramework("Foundation", .{ .needed = true });

        const tests = b.addTest(.{ .root_module = test_mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);

        break :blk mod;
    };

    _ = core;
}

fn addCompileErrorTests(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    macos: *std.Build.Module,
    utils: *std.Build.Module,
    encode: *std.Build.Module,
) *std.Build.Step {
    const step = b.step("test-compile-errors", "Check compile-time validation errors");
    inline for (@import("compile_test.zig").sources) |source| {
        inline for (source.CompileTestCases) |case| {
            const check = b.addTest(.{
                .name = "compile-test",
                .root_module = b.createModule(.{
                    .root_source_file = b.path("compile_test.zig"),
                    .target = target,
                    .optimize = optimize,
                    .imports = &.{
                        .{ .name = "macos", .module = macos },
                        .{ .name = "utils", .module = utils },
                        .{ .name = "utils/encode", .module = encode },
                    },
                }),
                .filters = &.{case.name},
            });
            check.step.name = case.name;
            check.expect_errors = .{ .contains = case.expected_error };
            _ = check.getEmittedBin();
            step.dependOn(&check.step);
        }
    }
    return step;
}
