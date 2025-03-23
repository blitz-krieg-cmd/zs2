const ee = @import("ee/ee.zig").ee;
const gs = @import("gs/gs.zig");

export fn __start() callconv(.{ .mips_o32 = .{} }) void {
    gs.BGCOLOR.* = @bitCast(gs.RGB{ .r = 0, .g = 0, .b = 255 });
    while (true) {}
}
