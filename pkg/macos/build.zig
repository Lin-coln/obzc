const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run macOS tests");

    const abi = blk: {
        const trans = b.addTranslateC(.{
            .root_source_file = b.path("ffi/c.h"),
            .target = target,
            .optimize = optimize,
        });
        break :blk trans.addModule("macos-abi");
    };

    const macos = blk: {
        const mod = b.addModule("macos", .{
            .root_source_file = b.path("root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "macos-abi", .module = abi },
            },
        });
        mod.linkFramework("CoreFoundation", .{});
        mod.linkFramework("CoreGraphics", .{});
        mod.linkFramework("CoreMedia", .{});
        mod.linkFramework("CoreVideo", .{});
        mod.linkFramework("IOSurface", .{});

        const tests = b.addTest(.{ .root_module = mod });
        test_step.dependOn(&b.addRunArtifact(tests).step);
        break :blk mod;
    };

    _ = macos;
}
