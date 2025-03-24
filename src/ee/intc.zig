const ee = @import("ee.zig").ee;

pub const intc = @This();

pub const I_STAT = @as(*volatile u32, @ptrFromInt(0x1000_f000)); // Interrupt status
// This register shows occurrence of an interrupt request from each interrupt request source.
// When the flag is set in each field, the effective edge following the corresponding interrupt signal cannot be detected.
// The flags are cleared by writing 1.
// POS: 00      // Source GS     // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 01      // Source SBUS   // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 02      // Source VBON   // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 03      // Source VBOF   // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 04      // Source VIF0   // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 05      // Source VIF1   // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 06      // Source VU0    // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 07      // Source VU1    // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 08      // Source IPU    // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 09      // Source TIM0   // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 10      // Source TIM1   // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 11      // Source TIM2   // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 12      // Source TIM3   // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 13      // Source SFIFO  // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 14      // Source VU0WD  // 0 No interrupt exists. // 1 An interrupt exists.
// POS: 15      // Reserved
// POS: 16      // Reserved
// POS: 17      // Reserved
// POS: 18      // Reserved
// POS: 19      // Reserved
// POS: 20      // Reserved
// POS: 21      // Reserved
// POS: 22      // Reserved
// POS: 23      // Reserved
// POS: 24      // Reserved
// POS: 25      // Reserved
// POS: 26      // Reserved
// POS: 27      // Reserved
// POS: 28      // Reserved
// POS: 29      // Reserved
// POS: 30      // Reserved
// POS: 31      // Reserved

pub const I_MASK = @as(*volatile u32, @ptrFromInt(0x1000_f010)); // Interrupt mask
// An INT0 interrupt occurs if there is a corresponding interrupt request when each bit is 1.
// Each bit is reversed (set/cleared) by writing 1.
// POS: 00      // Source GS     // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 01      // Source SBUS   // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 02      // Source VBON   // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 03      // Source VBOF   // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 04      // Source VIF0   // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 05      // Source VIF1   // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 06      // Source VU0    // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 07      // Source VU1    // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 08      // Source IPU    // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 09      // Source TIM0   // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 10      // Source TIM1   // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 11      // Source TIM2   // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 12      // Source TIM3   // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 13      // Source SFIFO  // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 14      // Source VU0WD  // 0 Masks the interrupt. // 1 Enables the iterrupt.
// POS: 15      // Reserved
// POS: 16      // Reserved
// POS: 17      // Reserved
// POS: 18      // Reserved
// POS: 19      // Reserved
// POS: 20      // Reserved
// POS: 21      // Reserved
// POS: 22      // Reserved
// POS: 23      // Reserved
// POS: 24      // Reserved
// POS: 25      // Reserved
// POS: 26      // Reserved
// POS: 27      // Reserved
// POS: 28      // Reserved
// POS: 29      // Reserved
// POS: 30      // Reserved
// POS: 31      // Reserved
