const ee = @import("ee.zig").ee;

pub const gif = @This();

// Registers
pub const GIF_CTRL = @as(*volatile u32, @ptrFromInt(0x1000_3000)); // GIF control
pub const GIF_MODE = @as(*volatile u32, @ptrFromInt(0x1000_3010)); // GIF mode setting
pub const GIF_STAT = @as(*volatile u32, @ptrFromInt(0x1000_3020)); // GIF status
pub const GIF_TAG0 = @as(*volatile u32, @ptrFromInt(0x1000_3040)); // GIFtag (bits 31-0) immediately before
pub const GIF_TAG1 = @as(*volatile u32, @ptrFromInt(0x1000_3050)); // GIFtag (bits 63-32) immediately before
pub const GIF_TAG2 = @as(*volatile u32, @ptrFromInt(0x1000_3060)); // GIFtag (bits 95-64) immediately before
pub const GIF_TAG3 = @as(*volatile u32, @ptrFromInt(0x1000_3070)); // GIFtag (bits 127-96) immediately before
pub const GIF_CNT = @as(*volatile u32, @ptrFromInt(0x1000_3080)); // Transfer status counter
pub const GIF_P3CNT = @as(*volatile u32, @ptrFromInt(0x1000_3090)); // PATH3 transfer status counter
pub const GIF_P3TAG = @as(*volatile u32, @ptrFromInt(0x1000_30a0)); // PATH3 tag value
