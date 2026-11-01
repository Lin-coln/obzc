const std = @import("std");
const log = std.log.scoped(.build_test);

pub const Options = struct {
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
};

pub fn addTestStep(b: *std.Build, options: Options) !void {
    var suite = TestSuite.init(b, options);
    const packages = try selectPackages(b, suite.package_names);
    for (packages) |package| try suite.add(package);
}

const Package = struct {
    const Stage = enum { core, ns, rest };

    name: []const u8,
    stage: Stage,

    fn init(name: []const u8) Package {
        const stage: Stage = if (std.mem.eql(u8, name, "core"))
            .core
        else if (std.mem.eql(u8, name, "ns"))
            .ns
        else
            .rest;
        return .{ .name = name, .stage = stage };
    }

    fn lessThan(_: void, lhs: Package, rhs: Package) bool {
        if (lhs.stage != rhs.stage) return @backingInt(lhs.stage) < @backingInt(rhs.stage);
        return std.mem.lessThan(u8, lhs.name, rhs.name);
    }
};

const TestSuite = struct {
    build: *std.Build,
    step: *std.Build.Step,
    options: Options,
    package_names: ?[]const u8,
    prerequisite: ?*std.Build.Step = null,

    fn init(b: *std.Build, options: Options) TestSuite {
        return .{
            .build = b,
            .step = b.step("test", "Run package tests (optional: -Dpkg=mtl,sck)"),
            .options = options,
            .package_names = b.option([]const u8, "pkg", "Packages to test, comma separated (default: all)"),
        };
    }

    fn add(self: *TestSuite, package: Package) !void {
        const b = self.build;
        const dep = b.dependency(package.name, .{ .target = self.options.target, .optimize = self.options.optimize });

        const package_test = dep.builder.top_level_steps.get("test") orelse {
            log.err("pkg/{s} has no test step", .{package.name});
            return error.MissingTestStep;
        };
        const step = &package_test.step;
        if (self.prerequisite) |previous| step.dependOn(previous);
        self.step.dependOn(step);
        // Core and ns gate later stages; remaining packages can run together.
        if (package.stage != .rest) self.prerequisite = step;
    }
};

fn selectPackages(b: *std.Build, input: ?[]const u8) ![]Package {
    const Static = struct {
        fn containsName(names: []const []const u8, name: []const u8) bool {
            for (names) |candidate| {
                if (std.mem.eql(u8, candidate, name)) return true;
            }
            return false;
        }

        fn containsPackage(packages: []const Package, name: []const u8) bool {
            for (packages) |package| {
                if (std.mem.eql(u8, package.name, name)) return true;
            }
            return false;
        }
    };

    var requested: std.ArrayList([]const u8) = .empty;
    if (input) |names| {
        var parts = std.mem.splitScalar(u8, names, ',');
        while (parts.next()) |name| {
            if (name.len == 0) {
                log.err("empty package name in -Dpkg; example: -Dpkg=mtl,sck", .{});
                return error.EmptyPackageName;
            }
            if (!Static.containsName(requested.items, name)) try requested.append(b.allocator, name);
        }
    }

    const io = b.graph.io;
    b.dependOnDirectoryContents(b.path("pkg"));
    const dir = try b.root.openDir(io, "pkg", .{ .iterate = true });
    defer dir.close(io);

    var packages: std.ArrayList(Package) = .empty;
    var iterator = dir.iterate();
    while (try iterator.next(io)) |entry| {
        if (entry.kind != .directory) continue;
        if (input != null and !Static.containsName(requested.items, entry.name)) continue;
        try packages.append(b.allocator, .init(try b.allocator.dupe(u8, entry.name)));
    }

    if (input != null and packages.items.len != requested.items.len) {
        for (requested.items) |name| {
            if (Static.containsPackage(packages.items, name)) continue;
            log.err("unknown package '{s}'", .{name});
            return error.UnknownPackage;
        }
    }

    std.mem.sort(Package, packages.items, {}, Package.lessThan);
    return packages.items;
}
