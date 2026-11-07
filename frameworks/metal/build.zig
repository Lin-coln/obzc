const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run Metal tests");
    const core, const ios, const ns = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("core", opts).module("core"),
            b.dependency("io-surface", opts).module("io-surface"),
            b.dependency("foundation", opts).module("foundation"),
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
        const mod = b.addModule("metal", .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "core", .module = core },
                .{ .name = "foundation", .module = ns },
                .{ .name = "io-surface", .module = ios },
                .{ .name = "mtl-abi", .module = mtl_abi },
            },
        });

        mod.linkFramework("Metal", .{ .needed = true });

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = mtl;
}
