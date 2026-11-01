const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run Vision tests");
    const core, const cg, const cv, const ns = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("core", opts).module("core"),
            b.dependency("core-graphics", opts).module("core-graphics"),
            b.dependency("core-video", opts).module("core-video"),
            b.dependency("foundation", opts).module("foundation"),
        };
    };

    const vision = blk: {
        const opts: std.Build.Module.CreateOptions = .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "core", .module = core },
                .{ .name = "foundation", .module = ns },
                .{ .name = "core-graphics", .module = cg },
                .{ .name = "core-video", .module = cv },
            },
        };

        const mod = b.addModule("vision", opts);
        mod.linkFramework("Vision", .{ .needed = true });

        const test_mod = b.createModule(opts);
        test_mod.linkFramework("Vision", .{ .needed = true });

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
                .{ .name = "foundation", .module = ns },
                .{ .name = "vision", .module = vision },
                .{ .name = "core-video", .module = cv },
            },
        });
        mod.linkFramework("CoreVideo", .{});

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = tests;
}
