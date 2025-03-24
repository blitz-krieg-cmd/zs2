const std = @import("std");
const builtin = @import("builtin");

const zs2 = @import("zs2.zig");

export fn __start() callconv(.{ .mips_o32 = .{} }) void {
    main();
}

pub fn main() void {

}
