const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run Foundation tests");
    const macos, const core, const core2, const cf = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("macos", opts).module("macos"),
            b.dependency("core", opts).module("core"),
            b.dependency("core2", opts).module("core2"),
            b.dependency("core-foundation", opts).module("core-foundation"),
        };
    };
    test_step.dependOn(addCompileErrorTests(b, target, optimize, macos, core));

    const ns = blk: {
        const mod = b.addModule("foundation", .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "macos", .module = macos },
                .{ .name = "core", .module = core },
                .{ .name = "core2", .module = core2 },
                .{ .name = "core-foundation", .module = cf },
            },
        });

        mod.linkFramework("Foundation", .{ .needed = true });

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = ns;
}

fn addCompileErrorTests(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    macos: *std.Build.Module,
    core: *std.Build.Module,
) *std.Build.Step {
    const step = b.step("test-compile-errors", "Check compile-time validation errors");
    inline for (@import("src/compile_test.zig").sources) |source| {
        inline for (source.CompileTestCases) |case| {
            const check = b.addTest(.{
                .name = "compile-test",
                .root_module = b.createModule(.{
                    .root_source_file = b.path("src/compile_test.zig"),
                    .target = target,
                    .optimize = optimize,
                    .imports = &.{
                        .{ .name = "macos", .module = macos },
                        .{ .name = "core", .module = core },
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
