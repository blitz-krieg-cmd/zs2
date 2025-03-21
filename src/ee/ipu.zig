const ee = @import("ee.zig").ee;

pub const ipu = @This();

// Registers
pub const IPU_CMD = @as(*volatile u32, @ptrFromInt(0x1000_2000)); // IPU command
pub const IPU_CTRL = @as(*volatile u32, @ptrFromInt(0x1000_2010)); // IPU control
pub const IPU_BP = @as(*volatile u32, @ptrFromInt(0x1000_2020)); // IPU input FIFO control // might be u128 since fifo
pub const IPU_TOP = @as(*volatile u32, @ptrFromInt(0x1000_2030)); // IPU First data of bit stream
