const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run Metal tests");
    const macos, const core2, const ios, const ns = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("macos", opts).module("macos"),
            b.dependency("core2", opts).module("core2"),
            b.dependency("io-surface", opts).module("io-surface"),
            b.dependency("foundation", opts).module("foundation"),
        };
    };

    const mtl = blk: {
        const opts: std.Build.Module.CreateOptions = .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "macos", .module = macos },
                .{ .name = "foundation", .module = ns },
                .{ .name = "io-surface", .module = ios },
            },
        };
        const mod = b.addModule("metal", opts);

        mod.linkFramework("Metal", .{ .needed = true });

        const test_mod = b.createModule(opts);
        test_mod.addImport("core2", core2);
        test_mod.linkFramework("Metal", .{ .needed = true });

        const tests = b.addTest(.{ .root_module = test_mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = mtl;
}
