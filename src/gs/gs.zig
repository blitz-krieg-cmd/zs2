pub const gs = @This();

pub const RGB = packed struct {
    r: u8,
    g: u8,
    b: u8,
    _: u8 = 0,
};

// Registers

// GS privileged registers must be accessed using LD/SD instructions.
// When the EE Core accesses an address between 0x1200_0000 and 0x13ff_ffff, GIF recognizes it as an access to a GS privileged register and makes an access to the corresponding GS privileged register.
// In this case, addresses [12] and [9:4] of the CPU bus are output to GA[6:0]

// GS Special
pub const PMODE = @as(*volatile u32, @ptrFromInt(0x1200_0000)); // Various PCRTC modes
pub const SMODE1 = @as(*volatile u32, @ptrFromInt(0x1200_0010)); // Related to Sync
pub const SMODE2 = @as(*volatile u32, @ptrFromInt(0x1200_0020)); // Related to Sync
pub const SRFSH = @as(*volatile u32, @ptrFromInt(0x1200_0030)); // DRAM refresh
pub const SYNCH1 = @as(*volatile u32, @ptrFromInt(0x1200_0040)); // Related to Sync
pub const SYNCH2 = @as(*volatile u32, @ptrFromInt(0x1200_0050)); // Related to Sync
pub const SYNCV = @as(*volatile u32, @ptrFromInt(0x1200_0060)); // Related to Sync/start
pub const DISPFB1 = @as(*volatile u32, @ptrFromInt(0x1200_0070)); // Related to display buffer of Rectangular Area 1
pub const DISPLAY1 = @as(*volatile u32, @ptrFromInt(0x1200_0080)); // Rectangular Area 1 display position etc.
pub const DISPFB2 = @as(*volatile u32, @ptrFromInt(0x1200_0090)); // Related to display buffer of Rectangular Area 2
pub const DISPLAY2 = @as(*volatile u32, @ptrFromInt(0x1200_00a0)); // Rectangular Area 2 display position etc.
pub const EXTBUF = @as(*volatile u32, @ptrFromInt(0x1200_00b0)); // Rectangular area write buffer
pub const EXTDATA = @as(*volatile u32, @ptrFromInt(0x1200_00c0)); // Rectangular area write data
pub const EXTWRITE = @as(*volatile u32, @ptrFromInt(0x1200_00d0)); // Rectangular area write start
pub const BGCOLOR = @as(*volatile u32, @ptrFromInt(0x1200_00e0)); // Background color
pub const CSR = @as(*volatile u32, @ptrFromInt(0x1200_1000)); // Various GS status
pub const IMR = @as(*volatile u32, @ptrFromInt(0x1200_1010)); // Interrupt mask
pub const BUSDIR = @as(*volatile u32, @ptrFromInt(0x1200_1040)); // Host interface switching
pub const SIGLBLID = @as(*volatile u32, @ptrFromInt(0x1200_1080)); // SIGNALID/LABELID
