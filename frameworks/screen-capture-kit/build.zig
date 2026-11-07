const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run ScreenCaptureKit tests");
    const macos, const core, const cf, const cg, const cm, const ns = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("macos", opts).module("macos"),
            b.dependency("core", opts).module("core"),
            b.dependency("core-foundation", opts).module("core-foundation"),
            b.dependency("core-graphics", opts).module("core-graphics"),
            b.dependency("core-media", opts).module("core-media"),
            b.dependency("foundation", opts).module("foundation"),
        };
    };

    const sck = blk: {
        const opts: std.Build.Module.CreateOptions = .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "macos", .module = macos },
                .{ .name = "core", .module = core },
                .{ .name = "foundation", .module = ns },
                .{ .name = "core-foundation", .module = cf },
                .{ .name = "core-graphics", .module = cg },
                .{ .name = "core-media", .module = cm },
            },
        };

        const mod = b.addModule("screen-capture-kit", opts);
        mod.linkFramework("ScreenCaptureKit", .{ .needed = true });

        const test_mod = b.createModule(opts);
        test_mod.linkFramework("ScreenCaptureKit", .{ .needed = true });
        test_mod.linkFramework("CoreGraphics", .{});
        test_mod.linkFramework("CoreMedia", .{});

        const tests = b.addTest(.{ .root_module = test_mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = sck;
}
