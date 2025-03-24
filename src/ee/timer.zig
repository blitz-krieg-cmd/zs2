const ee = @import("ee.zig").ee;

pub const timer = @This();

// Each timer has the registers described below.

// Tn_COUNT: Counter value (the upper 16 bits are fixed to 0)
// The counter value is incremented according to the conditions of the clock and the gate signal specified in the Tn_MODE.

// Tn_MODE: Mode setting and status reading
// CLKS 1:0
//     Clock Selection
//     00 BUSCLK (147.456MHz)
//     01 1/16 of the BUSCLK
//     10 1/256 of the BUSCLK
//     11 External clock (H-BLNK)
// GATE 2
//     Gate Function Enable
//     0 Gate function is not used.
//     1 Gate function is used.
// GATS 3
//     Gate Selection
//     0 H-BLNK (Disabled when CLKS equals to 11.)
//     1 V-BLNK
// GATM 5:4 Gate Mode
//     00 Counts while the gate signal is low.
//     01 Resets and starts counting at the gate signal's rising edge.
//     10 Resets and starts counting at the gate signal's falling edge.
//     11 Resets and starts counting at both edges of the gate signal.
// ZRET 6
//     Zero Return
//     0 The counter keeps counting, ignoring the reference value.
//     1 The counter is cleared to 0 when the counter value is equal to the reference value.
// CUE 7
//     Count Up Enable
//     0 Stops counting.
//     1 Starts/restarts counting.
// CMPE 8
//     Compare-Interrupt Enable
//     0 A compare-interrupt is not generated.
//     1 An interrupt is generated when the counter value is equal to the reference value.
// OVFE 9
//     Overflow-Interrupt Enable
//     0 An overflow interrupt is not generated.
//     1 An interrupt is generated when an overflow occurs.
// EQUF 10
//     Equal Flag
//     The value is set to 1 when a compare-interrupt occurs.
//     Writing 1 clears the equal flag.
// OVFF 11
//     Overflow Flag
//     The value is set to 1 when an overflow-interrupt occurs.
//     Writing 1 clears the equal flag.

// Tn_COMP: Compare value (the upper 16 bits are fixed to 0)
// Reference value to be compared with Tn_COUNT

// Tn_HOLD: Hold value (the upper 16 bits are fixed to 0)
// The value of Tn_COUNT is copied when an SBUS interrupt occurs

pub const T0_COUNT = @as(*volatile u32, @ptrFromInt(0x1000_0000)); // Timer 0 counter value
pub const T0_MODE = @as(*volatile u32, @ptrFromInt(0x1000_0010)); // Timer 0 mode/status
pub const T0_COMP = @as(*volatile u32, @ptrFromInt(0x1000_0020)); // Timer 0 compare value
pub const T0_HOLD = @as(*volatile u32, @ptrFromInt(0x1000_0030)); // Timer 0 hold value

pub const T1_COUNT = @as(*volatile u32, @ptrFromInt(0x1000_0800)); // Timer 1 counter value
pub const T1_MODE = @as(*volatile u32, @ptrFromInt(0x1000_0810)); // Timer 1 mode/status
pub const T1_COMP = @as(*volatile u32, @ptrFromInt(0x1000_0820)); // Timer 1 compare value
pub const T1_HOLD = @as(*volatile u32, @ptrFromInt(0x1000_0830)); // Timer 1 hold value

pub const T2_COUNT = @as(*volatile u32, @ptrFromInt(0x1000_1000)); // Timer 2 counter value
pub const T2_MODE = @as(*volatile u32, @ptrFromInt(0x1000_1010)); // Timer 2 mode/status
pub const T2_COMP = @as(*volatile u32, @ptrFromInt(0x1000_1020)); // Timer 2 compare value

pub const T3_COUNT = @as(*volatile u32, @ptrFromInt(0x1000_1800)); // Timer 3 counter value
pub const T3_MODE = @as(*volatile u32, @ptrFromInt(0x1000_1810)); // Timer 3 mode/status
pub const T3_COMP = @as(*volatile u32, @ptrFromInt(0x1000_1820)); // Timer 3 compare value
