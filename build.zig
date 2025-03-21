const std = @import("std");
const mips3 = std.Target.mips.cpu.mips3;

const target: std.Target.Query = .{
    .cpu_arch = .mips64,
    .cpu_model = .{ .explicit = &mips3 },
    .os_tag = .freestanding,
    .dynamic_linker = .none,
    .ofmt = .elf,
    .abi = .eabi,

    .android_api_level = null,
    .glibc_version = null,

    // .cpu = .{
    //     .arch = .mips,
    //     .model = ,
    //     .features = mips3.features,
    // },
    // .os = .{ .tag = .freestanding, .version_range = .{ .none = {} } },
    // .abi = .eabi,
    // .ofmt = .elf,
    // .dynamic_linker = .none,
};

pub fn build(b: *std.Build) void {
    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(target),
        .optimize = .ReleaseFast,
        .pic = false,
        .dwarf_format = .@"64",
        .single_threaded = true,
        .strip = false,
    });

    const exe = b.addExecutable(.{
        .name = "example_zig.elf",
        .root_module = exe_mod,
    });

    b.installArtifact(exe);

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
