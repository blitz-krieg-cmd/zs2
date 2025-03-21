const ee = @import("ee/ee.zig").ee;

export fn __start() void {
    const x = 2;
    const y = 3;

    const result = x + y;

    _ = result; // autofix
}
