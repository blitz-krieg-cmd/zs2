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

const target_IOP: std.Target.Query = .{
    .cpu_arch = .mipsel,
    .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips1 },
    .os_tag = .freestanding,
    .ofmt = .elf,
    .dynamic_linker = .none,
    .cpu_features_add = std.Target.mips.cpu.mips1.features,
    .abi = .eabi,
};

pub fn build(b: *std.Build) void {
    // Module

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(target_EE),
        .optimize = .Debug,
        .pic = false,
        .strip = false,
        .link_libc = false,
    });

    // Elf

    const elf = b.addExecutable(.{
        .name = "example_zig.elf",
        .root_module = exe_mod,
        .use_lld = true,
        .linkage = .static,
    });
    elf.no_builtin = true;
    elf.link_emit_relocs = false;
    elf.bundle_compiler_rt = true;
    elf.bundle_ubsan_rt = true;
    elf.setLinkerScript(b.path("src/link.ld"));
    b.installArtifact(elf);

    // Check

    const exe_check = b.addExecutable(.{
        .name = "check",
        .root_module = exe_mod,
    });
    const check = b.step("check", "Check if compiles");
    check.dependOn(&exe_check.step);

    // Test

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);

    // Run

    // const run_step = b.step("run", "run in pcsx2");

    // run_step.dependOn(&elf.step);
    // elf.no_builtin = true;
    // elf.link_emit_relocs = false;
    // elf.bundle_compiler_rt = true;
    // elf.bundle_ubsan_rt = true;
    // elf.setLinkerScript(b.path("src/link.ld"));
    // const tool_run = b.addSystemCommand(&.{"pcsx2-qt"});
    // tool_run.addArgs(&.{
    //     "-batch",
    //     "-elf",
    //     "-slowboot",
    // });
    // tool_run.addFileArg(b.path("zig-out/bin/example_zig.elf"));

    // run_step.dependOn(&tool_run.step);
}
