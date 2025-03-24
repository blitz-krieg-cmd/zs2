const std = @import("std");

pub const ee = @import("ee/ee.zig").ee;
pub const gs = @import("gs/gs.zig").gs;

pub const Event = struct {};

pub const Context = struct {
    running: bool = true,
    allocator: std.mem.Allocator = undefined,

    /// Ticking of application
    pub fn tick(
        self: *@This(),
        comptime eventFn: *const fn (Context, Event) anyerror!void,
        comptime updateFn: *const fn (Context) anyerror!void,
        comptime drawFn: *const fn (Context) anyerror!void,
    ) void {
        _update(self, eventFn, updateFn);
        drawFn(self.*) catch unreachable;
    }

    inline fn _update(
        self: *@This(),
        comptime eventFn: *const fn (Context, Event) anyerror!void,
        comptime updateFn: *const fn (Context) anyerror!void,
    ) void {
        const e: Event = .{};
        eventFn(self.*, e) catch unreachable;
        updateFn(self.*) catch unreachable;
    }
};
