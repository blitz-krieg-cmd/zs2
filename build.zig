const std = @import("std");

const target_EE: std.Target.Query = .{
    .cpu_arch = .mipsel,
    .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 },
    .os_tag = .freestanding,
    .ofmt = .elf,
    .dynamic_linker = .none,
    .cpu_features_add = std.Target.mips.cpu.mips2.features,
    .abi = .eabi,
};

pub const Mode = enum {
    Development,
    Release,
};

pub fn build(b: *std.Build) void {
    if (b.option(bool, "skipbuild", "skip all build jobs, false by default.")) |skip| {
        if (skip) return;
    }
}

pub fn createApplication(
    b: *std.Build,
    name: []const u8,
    src_root: []const u8,
    mode: Mode,
) *std.Build.Step.Compile {
    const target = b.resolveTargetQuery(target_EE);
    const optimize: std.builtin.OptimizeMode = if (mode == .Release) .ReleaseSafe else .Debug;

    const zs = getLibrary(b, target, optimize);

    const app = b.createModule(.{
        .root_source_file = b.path(src_root),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zs", .module = zs.root_module },
        },
    });

    // Create root module
    const builder = getBuilder(b);
    const root = b.createModule(.{
        .root_source_file = builder.path("src/entry.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zs", .module = zs.root_module },
            .{ .name = "app", .module = app },
        },
    });

    // Create executable
    const elf = builder.addExecutable(.{
        .name = std.fmt.allocPrint(b.allocator, "{s}.{s}", .{ name, "elf" }) catch unreachable,
        .root_module = root,
        .use_lld = true,
        .linkage = .static,
    });
    elf.linkLibrary(zs);
    elf.no_builtin = true;
    elf.link_emit_relocs = false;
    elf.bundle_compiler_rt = true;
    elf.bundle_ubsan_rt = true;
    elf.setLinkerScript(builder.path("link.ld"));

    return elf;
}

fn getLibrary(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step.Compile {
    const builder = getBuilder(b);

    const lib: *std.Build.Step.Compile = builder.addStaticLibrary(.{
        .name = "zs",
        .root_module = builder.createModule(.{
            .root_source_file = builder.path("src/zs.zig"),
            .target = target,
            .optimize = optimize,
        }),
        .use_lld = true,
    });

    return lib;
}

// Get jok's own builder from project's
fn getBuilder(b: *std.Build) *std.Build {
    return b.dependency("zs", .{ .skipbuild = true }).builder;
}
