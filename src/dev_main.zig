const std = @import("std");
const builtin = @import("builtin");

const zs2 = @import("zs2.zig");
const ee = zs2.ee;
const gs = zs2.gs;

export fn __start() callconv(.{ .mips_o32 = .{} }) void {
    main();
}

pub fn main() void {
    gs.BGCOLOR.* = @bitCast(gs.RGB{ .r = 0, .g = 0, .b = 255 });
    while (true) {}
}
