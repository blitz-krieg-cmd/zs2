const std = @import("std");

const app = @import("app");
const zs = @import("zs");

comptime {
    if (!@hasDecl(app, "init") or
        !@hasDecl(app, "event") or
        !@hasDecl(app, "update") or
        !@hasDecl(app, "draw") or
        !@hasDecl(app, "quit"))
    {
        @compileError(
            \\You must provide following 5 public api in your game code:
            \\    pub fn init() !void
            \\    pub fn event() !void
            \\    pub fn update() !void
            \\    pub fn draw() !void
            \\    pub fn quit() void
        );
    }
    switch (@typeInfo(@typeInfo(@TypeOf(app.init)).@"fn".return_type.?)) {
        .error_union => |info| if (info.payload != void) {
            @compileError("`init` must return !void");
        },
        else => @compileError("`init` must return !void"),
    }
    switch (@typeInfo(@typeInfo(@TypeOf(app.event)).@"fn".return_type.?)) {
        .error_union => |info| if (info.payload != void) {
            @compileError("`event` must return !void");
        },
        else => @compileError("`init` must return !void"),
    }
    switch (@typeInfo(@typeInfo(@TypeOf(app.update)).@"fn".return_type.?)) {
        .error_union => |info| if (info.payload != void) {
            @compileError("`update` must return !void");
        },
        else => @compileError("`update` must return !void"),
    }
    switch (@typeInfo(@typeInfo(@TypeOf(app.draw)).@"fn".return_type.?)) {
        .error_union => |info| if (info.payload != void) {
            @compileError("`draw` must return !void");
        },
        else => @compileError("`draw` must return !void"),
    }
    switch (@typeInfo(@typeInfo(@TypeOf(app.quit)).@"fn".return_type.?)) {
        .void => {},
        else => @compileError("`quit` must return void"),
    }
}

export fn __start() callconv(.{ .mips_o32 = .{} }) void {
    // Init context
    var ctx: zs.Context = .{};

    app.init(ctx) catch {};
    defer app.quit(ctx);

    // Start game loop
    while (ctx.running) {
        ctx.tick(app.event, app.update, app.draw);
    }
}
