const ee = @import("ee.zig").ee;

pub const vif0 = @This();

// Registers
pub const VIF0_STAT = @as(*volatile u32, @ptrFromInt(0x1000_3800)); // Status
pub const VIF0_FBRST = @as(*volatile u32, @ptrFromInt(0x1000_3810)); // Operation control
pub const VIF0_ERR = @as(*volatile u32, @ptrFromInt(0x1000_3820)); // Error status
pub const VIF0_MARK = @as(*volatile u32, @ptrFromInt(0x1000_3830)); // Mark value
pub const VIF0_CYCLE = @as(*volatile u32, @ptrFromInt(0x1000_3840)); // Data write cycle
pub const VIF0_MODE = @as(*volatile u32, @ptrFromInt(0x1000_3850)); // ADD mode
pub const VIF0_NUM = @as(*volatile u32, @ptrFromInt(0x1000_3860)); // Amount of non-transferred data
pub const VIF0_MASK = @as(*volatile u32, @ptrFromInt(0x1000_3870)); // Write mask pattern
pub const VIF0_CODE = @as(*volatile u32, @ptrFromInt(0x1000_3880)); // Last processed VIFcode
pub const VIF0_ITOPS = @as(*volatile u32, @ptrFromInt(0x1000_3890)); // Next ITOP value
pub const VIF0_ITOP = @as(*volatile u32, @ptrFromInt(0x1000_38d0)); // ITOP value
pub const VIF0_R0 = @as(*volatile u32, @ptrFromInt(0x1000_3900)); // Filling data R0 (Row register)
pub const VIF0_R1 = @as(*volatile u32, @ptrFromInt(0x1000_3910)); // Filling data R1 (Row register)
pub const VIF0_R2 = @as(*volatile u32, @ptrFromInt(0x1000_3920)); // Filling data R2 (Row register)
pub const VIF0_R3 = @as(*volatile u32, @ptrFromInt(0x1000_3930)); // Filling data R3 (Row register)
pub const VIF0_C0 = @as(*volatile u32, @ptrFromInt(0x1000_3940)); // Filling data C0 (Col register)
pub const VIF0_C1 = @as(*volatile u32, @ptrFromInt(0x1000_3950)); // Filling data C1 (Col register)
pub const VIF0_C2 = @as(*volatile u32, @ptrFromInt(0x1000_3960)); // Filling data C2 (Col register)
pub const VIF0_C3 = @as(*volatile u32, @ptrFromInt(0x1000_3970)); // Filling data C3 (Col register)
