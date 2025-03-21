const ee = @import("ee.zig").ee;

pub const fifo = @This();

// Registers
pub const VIF0_FIFO = @as(*volatile u128, @ptrFromInt(0x1000_4000)); // VIF0 FIFO (write)
pub const VIF1_FIFO = @as(*volatile u128, @ptrFromInt(0x1000_5000)); // VIF1 FIFO (read/write)
pub const GIF_FIFO = @as(*volatile u128, @ptrFromInt(0x1000_6000)); // GIF FIFO (write)
pub const IPU_out_FIFO = @as(*volatile u128, @ptrFromInt(0x1000_7000)); // IPU FIFO (read)
pub const IPU_in_FIFO = @as(*volatile u128, @ptrFromInt(0x1000_7010)); // IPU FIFO (write)
