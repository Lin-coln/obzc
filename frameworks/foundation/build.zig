const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run Foundation tests");
    const macos, const rt, const cf = blk: {
        const opts = .{ .target = target, .optimize = optimize };
        break :blk .{
            b.dependency("macos", opts).module("macos"),
            b.dependency("runtime", opts).module("runtime"),
            b.dependency("core-foundation", opts).module("core-foundation"),
        };
    };
    const ns = blk: {
        const mod = b.addModule("foundation", .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "macos", .module = macos },
                .{ .name = "runtime", .module = rt },
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
