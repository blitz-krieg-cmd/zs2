const ee = @import("ee.zig").ee;

pub const dmac = @This();

// Registers
pub const D0_CHCR = @as(*volatile u32, @ptrFromInt(0x1000_8000)); // Ch0 channel control
pub const D0_MADR = @as(*volatile u32, @ptrFromInt(0x1000_8010)); // Ch0 memory address
pub const D0_QWC = @as(*volatile u32, @ptrFromInt(0x1000_8020)); // Ch0 quad word count
pub const D0_TADR = @as(*volatile u32, @ptrFromInt(0x1000_8030)); // Ch0 tag address
pub const D0_ASR0 = @as(*volatile u32, @ptrFromInt(0x1000_8040)); // Ch0 address stack 0
pub const D0_ASR1 = @as(*volatile u32, @ptrFromInt(0x1000_8050)); // Ch0 address stack 1

pub const D1_CHCR = @as(*volatile u32, @ptrFromInt(0x1000_9000)); // Ch1 channel control
pub const D1_MADR = @as(*volatile u32, @ptrFromInt(0x1000_9010)); // Ch1 memory address
pub const D1_QWC = @as(*volatile u32, @ptrFromInt(0x1000_9020)); // Ch1 quad word count
pub const D1_TADR = @as(*volatile u32, @ptrFromInt(0x1000_9030)); // Ch1 tag address
pub const D1_ASR0 = @as(*volatile u32, @ptrFromInt(0x1000_9040)); // Ch1 address stack 0
pub const D1_ASR1 = @as(*volatile u32, @ptrFromInt(0x1000_9050)); // Ch1 address stack 1

pub const D2_CHCR = @as(*volatile u32, @ptrFromInt(0x1000_A000)); // Ch2 channel control
pub const D2_MADR = @as(*volatile u32, @ptrFromInt(0x1000_A010)); // Ch2 memory address
pub const D2_QWC = @as(*volatile u32, @ptrFromInt(0x1000_A020)); // Ch2 quad word count
pub const D2_TADR = @as(*volatile u32, @ptrFromInt(0x1000_A030)); // Ch2 tag address
pub const D2_ASR0 = @as(*volatile u32, @ptrFromInt(0x1000_A040)); // Ch2 address stack 0
pub const D2_ASR1 = @as(*volatile u32, @ptrFromInt(0x1000_A050)); // Ch2 address stack 1

pub const D3_CHCR = @as(*volatile u32, @ptrFromInt(0x1000_b000)); // Ch3 channel control
pub const D3_MADR = @as(*volatile u32, @ptrFromInt(0x1000_b010)); // Ch3 memory address
pub const D3_QWC = @as(*volatile u32, @ptrFromInt(0x1000_b020)); // Ch3 quad word count

pub const D4_CHCR = @as(*volatile u32, @ptrFromInt(0x1000_b400)); // Ch4 chnnel control
pub const D4_MADR = @as(*volatile u32, @ptrFromInt(0x1000_b410)); // Ch4 memory address
pub const D4_QWC = @as(*volatile u32, @ptrFromInt(0x1000_b420)); // Ch4 quad word count
pub const D4_TADR = @as(*volatile u32, @ptrFromInt(0x1000_b430)); // Ch4 tag address

pub const D5_CHCR = @as(*volatile u32, @ptrFromInt(0x1000_c000)); // Ch5 channel control
pub const D5_MADR = @as(*volatile u32, @ptrFromInt(0x1000_c010)); // Ch5 memory address
pub const D5_QWC = @as(*volatile u32, @ptrFromInt(0x1000_c020)); // Ch5 quad word count

pub const D6_CHCR = @as(*volatile u32, @ptrFromInt(0x1000_c400)); // Ch6 channel control
pub const D6_MADR = @as(*volatile u32, @ptrFromInt(0x1000_c410)); // Ch6 memory address
pub const D6_QWC = @as(*volatile u32, @ptrFromInt(0x1000_c420)); // Ch6 quad word count
pub const D6_TADR = @as(*volatile u32, @ptrFromInt(0x1000_c430)); // Ch6 tag address

pub const D7_CHCR = @as(*volatile u32, @ptrFromInt(0x1000_c800)); // Ch7 channel control
pub const D7_MADR = @as(*volatile u32, @ptrFromInt(0x1000_c810)); // Ch7 memory address
pub const D7_QWC = @as(*volatile u32, @ptrFromInt(0x1000_c820)); // Ch7 quad word count

pub const D8_CHCR = @as(*volatile u32, @ptrFromInt(0x1000_d000)); // Ch8 channel control
pub const D8_MADR = @as(*volatile u32, @ptrFromInt(0x1000_d010)); // Ch8 memory address
pub const D8_QWC = @as(*volatile u32, @ptrFromInt(0x1000_d020)); // Ch8 quad word count
pub const D8_SADR = @as(*volatile u32, @ptrFromInt(0x1000_d080)); // Ch8 SPR address

pub const D9_CHCR = @as(*volatile u32, @ptrFromInt(0x1000_d400)); // Ch9 channel control
pub const D9_MADR = @as(*volatile u32, @ptrFromInt(0x1000_d410)); // Ch9 memory address
pub const D9_QWC = @as(*volatile u32, @ptrFromInt(0x1000_d420)); // Ch9 quad word count
pub const D9_TADR = @as(*volatile u32, @ptrFromInt(0x1000_d430)); // Ch9 tag address
pub const D9_SADR = @as(*volatile u32, @ptrFromInt(0x1000_d480)); // Ch9 SPR address

pub const D_CTRL = @as(*volatile u32, @ptrFromInt(0x1000_e000)); // DMAC control
pub const D_STAT = @as(*volatile u32, @ptrFromInt(0x1000_e010)); // DMAC status
pub const D_PCR = @as(*volatile u32, @ptrFromInt(0x1000_e020)); // DMAC priority control
pub const D_SQWC = @as(*volatile u32, @ptrFromInt(0x1000_e030)); // DMAC skip quad word
pub const D_RBSR = @as(*volatile u32, @ptrFromInt(0x1000_e040)); // DMAC ring buffer size
pub const D_RBOR = @as(*volatile u32, @ptrFromInt(0x1000_e050)); // DMAC ring buffer offset
pub const D_STADR = @as(*volatile u32, @ptrFromInt(0x1000_e060)); // DMA stall address

pub const D_ENABLER = @as(*volatile u32, @ptrFromInt(0x1000_f520)); // Acquisition of DMA suspend status
pub const D_ENABLEW = @as(*volatile u32, @ptrFromInt(0x1000_f590)); // DMA suspend control
