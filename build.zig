const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // pkg/* and frameworks/*
    inline for (.{
        // core
        "macos",
        "core",
        "core2",

        // foundation
        "foundation",
        "core-foundation",

        // c frameworks
        "core-media",
        "core-graphics",
        "core-video",
        "io-surface",
        "video-toolbox",

        // objc frameworks
        "screen-capture-kit",
        "metal",
        "vision",
    }) |name| {
        const dep = b.dependency(name, .{ .target = target, .optimize = optimize });
        try b.modules.put(b.graph.arena, name, dep.module(name));
    }
}
