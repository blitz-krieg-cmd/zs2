const application = @import("app");

const ee = @import("ee/ee.zig").ee;
const gs = @import("gs/gs.zig");

// Validate application object
comptime {
    if (!@hasDecl(application, "init") or
        !@hasDecl(application, "event") or
        !@hasDecl(application, "update") or
        !@hasDecl(application, "draw") or
        !@hasDecl(application, "quit"))
    {
        @compileError(
            \\You must provide following 5 public api in your game code:
            \\    pub fn init(ctx: zs2.Context) !void
            \\    pub fn event(ctx: zs2.Context, e: zs2.iop.Event) !void
            \\    pub fn update(ctx: zs2.Context) !void
            \\    pub fn draw(ctx: zs2.Context) !void
            \\    pub fn quit(ctx: zs2.Context) void
        );
    }
    switch (@typeInfo(@typeInfo(@TypeOf(application.init)).@"fn".return_type.?)) {
        .error_union => |info| if (info.payload != void) {
            @compileError("`init` must return !void");
        },
        else => @compileError("`init` must return !void"),
    }
    switch (@typeInfo(@typeInfo(@TypeOf(application.event)).@"fn".return_type.?)) {
        .error_union => |info| if (info.payload != void) {
            @compileError("`event` must return !void");
        },
        else => @compileError("`init` must return !void"),
    }
    switch (@typeInfo(@typeInfo(@TypeOf(application.update)).@"fn".return_type.?)) {
        .error_union => |info| if (info.payload != void) {
            @compileError("`update` must return !void");
        },
        else => @compileError("`update` must return !void"),
    }
    switch (@typeInfo(@typeInfo(@TypeOf(application.draw)).@"fn".return_type.?)) {
        .error_union => |info| if (info.payload != void) {
            @compileError("`draw` must return !void");
        },
        else => @compileError("`draw` must return !void"),
    }
    switch (@typeInfo(@typeInfo(@TypeOf(application.quit)).@"fn".return_type.?)) {
        .void => {},
        else => @compileError("`quit` must return void"),
    }
}

pub const Event = struct {};

pub const Context = packed struct {
    shouldQuit: bool = false,

    pub fn tick(
        self: *@This(),
        comptime eventFn: *const fn (Context, Event) anyerror!void,
        comptime updateFn: *const fn (Context) anyerror!void,
        comptime drawFn: *const fn (Context) anyerror!void,
    ) void {
        _update(self, eventFn, updateFn);
        drawFn(self);
    }
    inline fn _update(
        self: *@This(),
        comptime eventFn: *const fn (Context, Event) anyerror!void,
        comptime updateFn: *const fn (Context) anyerror!void,
    ) void {
        const event = Event(.{});
        eventFn(self, event);
        updateFn(self);
    }
};

export fn __start() callconv(.{ .mips_o32 = .{} }) void {
    var ctx = Context(.{});

    application.init(ctx) catch {};
    defer application.quit(ctx);

    while (!ctx.shouldQuit) {
        ctx.tick(application.event, application.update, application.draw);
    }
}
