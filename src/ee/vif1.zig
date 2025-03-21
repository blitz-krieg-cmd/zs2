const ee = @import("ee.zig").ee;

pub const vif1 = @This();

// Registers
pub const VIF1_STAT = @as(*volatile u32, @ptrFromInt(0x1000_3c00)); // Status
pub const VIF1_FBRST = @as(*volatile u32, @ptrFromInt(0x1000_3c10)); // Operation control
pub const VIF1_ERR = @as(*volatile u32, @ptrFromInt(0x1000_3c20)); // Error status
pub const VIF1_MARK = @as(*volatile u32, @ptrFromInt(0x1000_3c30)); // Mark value
pub const VIF1_CYCLE = @as(*volatile u32, @ptrFromInt(0x1000_3c40)); // Data write cycle
pub const VIF1_MODE = @as(*volatile u32, @ptrFromInt(0x1000_3c50)); // ADD mode
pub const VIF1_NUM = @as(*volatile u32, @ptrFromInt(0x1000_3c60)); // Amount of non-transferred data
pub const VIF1_MASK = @as(*volatile u32, @ptrFromInt(0x1000_3c70)); // Write mask pattern
pub const VIF1_CODE = @as(*volatile u32, @ptrFromInt(0x1000_3c80)); // Last processed VIFcode
pub const VIF1_ITOPS = @as(*volatile u32, @ptrFromInt(0x1000_3c90)); // Next ITOP value
pub const VIF1_BASE = @as(*volatile u32, @ptrFromInt(0x1000_3ca0)); // Base address of double buffer
pub const VIF1_OFST = @as(*volatile u32, @ptrFromInt(0x1000_3cb0)); // Offset of double buffer
pub const VIF1_TOPS = @as(*volatile u32, @ptrFromInt(0x1000_3cc0)); // Next TOP value/data write address
pub const VIF1_ITOP = @as(*volatile u32, @ptrFromInt(0x1000_3cd0)); // ITOP value
pub const VIF1_TOP = @as(*volatile u32, @ptrFromInt(0x1000_3ce0)); // TOP value
pub const VIF1_R0 = @as(*volatile u32, @ptrFromInt(0x1000_3d00)); // Filling data R0 (Row register)
pub const VIF1_R1 = @as(*volatile u32, @ptrFromInt(0x1000_3d10)); // Filling data R1 (Row register)
pub const VIF1_R2 = @as(*volatile u32, @ptrFromInt(0x1000_3d20)); // Filling data R2 (Row register)
pub const VIF1_R3 = @as(*volatile u32, @ptrFromInt(0x1000_3d30)); // Filling data R3 (Row register)
pub const VIF1_C0 = @as(*volatile u32, @ptrFromInt(0x1000_3d40)); // Filling data C0 (Col register)
pub const VIF1_C1 = @as(*volatile u32, @ptrFromInt(0x1000_3d50)); // Filling data C1 (Col register)
pub const VIF1_C2 = @as(*volatile u32, @ptrFromInt(0x1000_3d60)); // Filling data C2 (Col register)
pub const VIF1_C3 = @as(*volatile u32, @ptrFromInt(0x1000_3d70)); // Filling data C3 (Col register)
