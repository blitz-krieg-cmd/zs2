const ee = @import("ee.zig").ee;

pub const intc = @This();

// The INTC (Interrupt Controller) arbitrates interrupt requests from multiple processors and sends an INT0 interrupt to the EE Core.

// An interrupt request is taken into the I_STAT register at the edge of an interrupt request signal, and the bit corresponding to the interrupt request source is set.
// Then, the AND between the I_STAT register and the I_MASK register is obtained per bit; if any bit is 1, an INT0 interrupt is asserted to the CPU.
// The INTC controls the following interrupt request sources.

// ID: 0     // Name: INT_GS           // Cause: GS              External factor   // Edge: Falling
// ID: 1     // Name: INT_SBUS         // Cause: SBUS            External factor   // Edge: Falling
// ID: 2     // Name: INT_VB_ON        // Cause: V-blank start   External factor   // Edge: Rising
// ID: 3     // Name: INT_VB_OFF       // Cause: V-blank end     External factor   // Edge: Falling
// ID: 4     // Name: INT_VIF0         // Cause: VIF0            Internal factor
// ID: 5     // Name: INT_VIF1         // Cause: VIF1            Internal factor
// ID: 6     // Name: INT_VU0          // Cause: VU0             Internal factor
// ID: 7     // Name: INT_VU1          // Cause: VU1             Internal factor
// ID: 8     // Name: INT_IPU          // Cause: IPU             Internal factor
// ID: 9     // Name: INT_TIMER0       // Cause: Timer0          Internal factor
// ID: 10    // Name: INT_TIMER1       // Cause: Timer1          Internal factor
// ID: 11    // Name: INT_TIMER2       // Cause: Timer2          Internal factor
// ID: 12    // Name: INT_TIMER3       // Cause: Timer3          Internal factor
// ID: 13    // Name: INT_SFIFO        // Cause: SFIFO           Internal factor
// ID: 14    // Name: INT_VU0WD        // Cause: VU0 WatchDog    Internal factor

// The status registers and cause registers for peripherals can check the details of interrupt causes.
// Besides the INTC, an interrupt request from the DMAC is connected to the EE Core as an independent signal (INT1*).
// Details of interrupts from each peripheral are as follows

// ID: 0       // Name: INT_GS      // Cause: Detection of an interrupt from GS
// ID: 1       // Name: INT_SBUS    // Cause: Detection of an interrupt from a peripheral on SBUS
// ID: 2       // Name: INT_VB_ON   // Cause: Start of V-Blank
// ID: 3       // Name: INT_VB_OFF  // Cause: End of V-Blank
// ID: 4       // Name: INT_VIF0    // Cause: VIF0's detection of VIFcode with an interrupt bit or an exception VIF0 stalls with occurrence of an interrupt.
// ID: 5       // Name: INT_VIF1    // Cause: VIF1's detection of VIFcode with an interrupt bit or an exception VIF1 stalls with occurrence of an interrupt.
// ID: 6       // Name: INT_VU0     // Cause: VU0's execution of a microinstruction with an interrupt bit VU0 stalls with occurrence of an interrupt.
// ID: 7       // Name: INT_VU1     // Cause: VU1's execution of a microinstruction with an interrupt bit VU1 stalls with occurrence of an interrupt.
// ID: 8       // Name: INT_IPU     // Cause: IPU's detection of the end of data or an exception IPU stalls with occurrence of an interrupt.
// ID: 9-12    // Name: INT_TIMER   // Cause: [0-3] Conditions met in timer settings
// ID: 13      // Name: INT_SFIFO   // Cause: Error detection during SFIFO transfer
// ID: 14      // Name: INT_VU0WD   // Cause: VU0 in RUN status for a long time continuously ForceBreak is sent to VU0.

// The INTC has the following registers.

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
