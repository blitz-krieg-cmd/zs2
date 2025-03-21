const ee = @import("ee.zig").ee;

pub const sif = @This();

// Registers
pub const SB_SMFLG = @as(*volatile u32, @ptrFromInt(0x1000_f230)); // SBUS Sub -> Main communication flag
