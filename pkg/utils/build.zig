const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const test_step = b.step("test", "Run utility and encoding tests");

    const utils = b.addModule("utils", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    const encode = b.addModule("encode", .{
        .root_source_file = b.path("encode/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "utils", .module = utils }},
    });

    test_step.dependOn(addCompileErrorTests(b, target, optimize, utils));
    test_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = utils })).step);
    test_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = encode })).step);
}

fn addCompileErrorTests(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    utils: *std.Build.Module,
) *std.Build.Step {
    const step = b.step("test-compile-errors", "Check compile-time validation errors");
    const no_imports: []const std.Build.Module.Import = &.{};
    const encode_imports: []const std.Build.Module.Import = &.{.{ .name = "utils", .module = utils }};
    inline for (.{
        .{
            .root = "src/compile_test.zig",
            .sources = @import("src/compile_test.zig").sources,
            .imports = no_imports,
        },
        .{
            .root = "encode/compile_test.zig",
            .sources = @import("encode/compile_test.zig").sources,
            .imports = encode_imports,
        },
    }) |group| {
        inline for (group.sources) |source| {
            inline for (source.CompileTestCases) |case| {
                const check = b.addTest(.{
                    .name = "compile-test",
                    .root_module = b.createModule(.{
                        .root_source_file = b.path(group.root),
                        .target = target,
                        .optimize = optimize,
                        .imports = group.imports,
                    }),
                    .filters = &.{case.name},
                });
                check.step.name = case.name;
                check.expect_errors = .{ .contains = case.expected_error };
                _ = check.getEmittedBin();
                step.dependOn(&check.step);
            }
        }
    }
    return step;
}
