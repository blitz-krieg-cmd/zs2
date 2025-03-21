const ee = @import("ee.zig").ee;

pub const dmac = @This();

// The DMAC intelligently transfers data between main memory and peripheral processors and between main memory and scratchpad RAM (SPR) while performing arbitration of the main bus.
// Data is transferred in qword (128-bit) units, and should be aligned on this boundary in memory.
// Transfer addresses are specified in terms of physical address and are not converted by the TLB. Moreover, in DMA transfers, bus snooping is not performed.
// Data is transferred to or from a peripheral processor in 8-qword slices: whenever the transfer of one slice is completed, the channel used for the transfer temporarily releases the bus right.
// Therefore, two or more data items can be transferred concurrently, in addition to the CPU being able to access main memory during transfer processing.
// In some of the channels, Chain mode is available.
// This mode performs processing such as transfer address switching according to the tag in the transfer data.
// This allows data to be exchanged between two or more processors through the mediation of the main memory, not the CPU.
// A stall control function is available to synchronize data transfer to and from the main memory.
// This is reinforced for the GIF channel, and the Memory FIFO function, which uses the ring buffer in the main memory is available.
// Also, priority control is enabled which gives priority to a specific packet over other channels in transferring data.

// The processors to which the DMAC allocates data and the corresponding channels are as follows:
// Direction both = both directions, from = from peripheral, to = to peripheral
// Priority: A > B > C
// Address Stack: No. of addresses stacked

// ID: 0  // Channel: VIF0     // Direction: to     // Priority: A   // Physical Mode: Slice   // DMA Stall: -       // MFIFO: -       // Source Chain: Yes  // Destination Chain: -    // Interleave -    // Address Stack: 2
// ID: 1  // Channel: VIF1     // Direction: both   // Priority: C   // Physical Mode: Slice   // DMA Stall: Drain   // MFIFO: Drain   // Source Chain: Yes  // Destination Chain: -    // Interleave -    // Address Stack: 2
// ID: 2  // Channel: GIF      // Direction: to     // Priority: C   // Physical Mode: Slice   // DMA Stall: Drain   // MFIFO: Drain   // Source Chain: Yes  // Destination Chain: -    // Interleave -    // Address Stack: 2
// ID: 3  // Channel: fromIPU  // Direction: from   // Priority: C   // Physical Mode: Slice   // DMA Stall: Source  // MFIFO: -       // Source Chain: -    // Destination Chain: -    // Interleave -    // Address Stack: -
// ID: 4  // Channel: toIPU    // Direction: to     // Priority: C   // Physical Mode: Slice   // DMA Stall: -       // MFIFO: -       // Source Chain: Yes  // Destination Chain: -    // Interleave -    // Address Stack: -
// ID: 5  // Channel: SIF0     // Direction: from   // Priority: C   // Physical Mode: Slice   // DMA Stall: Source  // MFIFO: -       // Source Chain: -    // Destination Chain: Yes  // Interleave -    // Address Stack: -
// ID: 6  // Channel: SIF1     // Direction: to     // Priority: C   // Physical Mode: Slice   // DMA Stall: Drain   // MFIFO: -       // Source Chain: Yes  // Destination Chain: -    // Interleave -    // Address Stack: -
// ID: 7  // Channel: SIF2     // Direction: both   // Priority: B   // Physical Mode: Slice   // DMA Stall: -       // MFIFO: -       // Source Chain: -    // Destination Chain: -    // Interleave -    // Address Stack: -
// ID: 8  // Channel: fromSPR  // Direction: from   // Priority: C   // Physical Mode: Burst   // DMA Stall: Source  // MFIFO: Source  // Source Chain: -    // Destination Chain: Yes  // Interleave Yes  // Address Stack: -
// ID: 9  // Channel: toSPR    // Direction: to     // Priority: C   // Physical Mode: Burst   // DMA Stall: -       // MFIFO: -       // Source Chain: Yes  // Destination Chain: -    // Interleave Yes  // Address Stack: -

// VIF1 channel (ID=1) can switch directions of transfer by making settings for the GS.
// Transmission from Local Buffer to Host.
// The SBUS has three DMA channels (ID=5,6,7) and performs DMA transfer in cooperation with the corresponding SBUS DMA (SDMA).
// Channels whose transfer destination is memory (excluding fromSPR) can select main memory or scratchpad memory as a transfer destination.
// Channels whose transfer source is memory (excluding toSPR) can select main memory or scratchpad memory as a transfer source.
// The fromSPR/toSPR channels can transfer data between scratchpad memory and VU memory in Burst Mode by specifying VU Mem0 and VU Mem1 addresses mapped to main memory as a transfer destination/source.
// In this case, however, logical transfer mode is limited to Normal Mode.

// Transfer Mode
// Two DMA channel transfer modes are provided: physical transfer mode, which is fixed for each channel, and logical transfer mode, which is selectable on each channel.
// Physical transfer mode is categorized into two types:
//     Burst Mode, in which data is transferred in a group. // Channel: toSPR fromSPR
//         Cycle Stealing off: Transfers all the data at a time with the bus right occupied.
//         Cycle Stealing on: Suspends transfer on each 128-byte boundary and releases the bus to the EE Core when there is a request from the EE Core.
//     Slice Mode, in which data is transferred in units of 8-qword slices while arbitrating with other DMA channels. // Channel: others
//         Cycle Stealing off: Transfers data by dividing it into 8-qword slices. Suspends transfer on each slice boundary and performs arbitration.
//         Cycle Stealing on: Suspends transfer and releases the bus to the EE Core in addition to the arbitration on a slice boundary.
// Transfer operations in Burst Mode and Slice Mode vary slightly between two Cycle Stealing states (on and off) regarding arbitration of the bus right with the EE Core.
// Cycle Stealing is set on/off by the RELE bit of the D_CTRL register.
// In Burst Mode with Cycle Stealing on, the transfer is suspended temporarily on a 128-byte boundary in main memory during DMA transfer to allow the EE Core to access main memory.
// However, when the logical transfer mode is set to Interleave Mode, the transfer is suspended in units of the number of qwords specified in the TW field of the D_SQWC register and the bus is released.
// The DMAC suspends DMA transfer until the number of bus cycles specified in the RCYC field of the D_CTRL register elapses after the bus right is returned to the EE Core.
// The next time the DMAC acquires the bus right, the suspended DMA transfer is restarted

// In the logical transfer mode, selection from three modes (Normal, Chain, and Interleave) is made for each channel.
// Chain Mode is divided between transfer from main/scratchpad memory to a peripheral (Source Chain Mode) and transfer from a peripheral to main/scratchpad memory (Destination Chain Mode).
// (Scratchpad memory is considered to be a peripheral on the toSPR/fromSPR channel.)
// Normal
//     Reads/writes data continuously between a specified address in main/scratchpad memory and a peripheral (general DMA transfer).
// Source Chain
//     Transfers data while switching the transfer address and the transfer mode according to the tag in the transfer packet when transferring data from main/scratchpad memory to a peripheral.
// Destination Chain
//     Transfers data while switching the destination address according to the tag in the transfer packet when transferring data from a peripheral to main/scratchpad memory.
// Interleave
//     Transfers a rectangular area of two-dimensional data between main memory and scratchpad memory.

// Normal Mode handles general DMA transfers.
// The transfer address is specified by the Dn_MADR register, and continuous data of the transfer size is specified by the Dn_QWC register.
// The transfer is started by setting the STR bit of the Dn_CHCR register to 1.
// The STR bit is cleared to 0 when the transfer is ended.
// On the Burst Channel, data of the size specified by the Dn_QWC register is transferred at one time continuously.
// On the Slice Channel, data of the size specified by the Dn_QWC register is divided into slices (blocks corresponding to 8-qword alignment in main memory).
// Whenever transfer of a slice ends, the remaining transfer data size and the next slice address are specified in Dn_QWC and Dn_MADR respectively, and the next DMA request is awaited.
// For example, if 20 qwords of data are to be transferred, transfer on the Slice Channel is executed as follows, in three slices (four slices if the data extends over 8-qword alignment) while waiting for a request from the peripheral.
// In comparison, data is transferred continuously on the Burst Channel.

// Source Chain Mode can perform DMA transfer from memory to a peripheral and specifies the address and data size with the tag (DMAtag) in the transfer packet.
// First, the DMAC transfers the data of the size specified by the Dn_QWC register from the address specified by the Dn_MADR register.
// When Dn_CHCR.TAG is cnt, the DMAC reads 1 qword from the address specified by Dn_TADR as a tag.
// The address and size of the data to be transferred next and the address of the tag to be read next are indicated in the tag.
// These values are stored in Dn_MADR and Dn_QWC respectively, the DMAC transfers data accordingly, and updates Dn_TADR following the transfer.
// Transfer processing is repeated while following the tag in memory, as described above.
// A series of transfers is ended by clearing the STR bit to 0 at the end of processing of the tag that contains the end instruction.
// The packet is transferred in 8-qword slices on the Slice channel in the same way as the transfer in the Normal mode.
// Whether to transfer the tag itself with the data or not can be specified by the TTE flag of the Dn_CHCR register.
// The tag itself is transferred before the DMA transfer activated by the tag.
// The following figures illustrate each example of transferring data of 16 qwords on the Burst/Slice channel with/without a tag.

// The tag is 128 bits (16 bytes) in length, and the lower 64 bits are effective.
// The format is as follows.
// ID is the field to show the details of the transfer operation and can specify eight types.

// DMA Tags in Source Chain Mode
// ID: cnt   // Transfer data start address: Next to tag  // Next tag address: Next to transfer data  // Operation: Transfers the QWC qword following the tag and reads the succeeding qword as the next tag.
// ID: next  // Transfer data start address: Next to tag  // Next tag address: ADDR                   // Operation: Transfers the QWC qword following the tag and reads the qword of the ADDR field as the next tag.
// ID: ref   // Transfer data start address: ADDR         // Next tag address: Next to tag            // Operation: Transfers the QWC qword from the ADDR field and reads the qword following the tag as the next tag.
// ID: refs  // Transfer data start address: ADDR         // Next tag address: Next to tag            // Operation: Transfers the QWC qword from the ADDR field while controlling stalls and reads the qword following the tag as the next tag. Effective only on the VIF1, GIF, and SIF1 channels.
// ID: refe  // Transfer data start address: ADDR         // Next tag address: (None)                 // Operation: Transfers the QWC qword from the ADDR field, clears the Dn_CHCR.STR to 0, and ends transfer.
// ID: call  // Transfer data start address: Next to tag  // Next tag address: ADDR                   // Operation: Transfers the QWC qword following the tag, pushes the next field into the Dn_ASR register, and reads the qword of the ADDR field as the next tag. Effective only on the VIF0, VIF1, and GIF channels. Addresses can be pushed up to 2 levels.
// ID: ret   // Transfer data start address: Next to tag  // Next tag address: Dn_ASR                 // Operation: Transfers the QWC qword following the tag and reads the qword of the field popped from the Dn_ASR register as the next tag. Transfers the QWC qword following the tag, clears the Dn_CHCR.STR to 0, and ends transfer when there is no pushed address. Effective only on the VIF0, VIF1, and GIF channels.
// ID: end   // Transfer data start address: Next to tag  // Next tag address: (None)                 // Operation: Transfers the QWC qword following the tag, clears the Dn_CHCR.STR to 0, and ends transfer.

// By using these IDs properly according to the data structure in the memory, data can be transferred efficiently taking advantage of the data structure.

//TODO: Destination Chain Mode
//TODO: Interleave Mode

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
