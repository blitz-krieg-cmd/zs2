# ZS2
An application framework for the PlayStation 2 written in Zig.

## How to start?

1. Add *ZS2* as your project's dependency

   Add zs dependency to your build.zig.zon, with following command:
    ```bash
    zig fetch --save=zs git+https://github.com/blitz-krieg-cmd/zs2.git
    ```

2. Use *ZS2*'s build script to add build step

    In your `build.zig`, add:
    ```zig
    const std = @import("std");
    const zs2 = @import("zs2");

    pub fn build(b: *std.Build) void {
        const exe = zs2.createApplication(
            b,
            "mygame",
            "src/main.zig",
            .Development,
        );

        const install_cmd = b.addInstallArtifact(exe, .{});
        b.getInstallStep().dependOn(&install_cmd.step);
    }
    ```


3. Write some code!

    You may import and use zs2 now, here is a skeleton for your `src/main.zig`:
    ```zig
    const std = @import("std");
    const zs2 = @import("zs2");

    pub fn init(ctx: zs2.Context) !void {
        // your init code
    }

    pub fn event(ctx: zs2.Context, e: zs2.Event) !void {
        // your event processing code
    }

    pub fn update(ctx: zs2.Context) !void {
        // your game state updating code
    }

    pub fn draw(ctx: zs2.Context) !void {
        // your drawing code
    }

    pub fn quit(ctx: zs2.Context) void {
        // your deinit code
    }
    ```

## Influences and Reference Projects
* [jok](https://github.com/Jack-Ji/jok) (MIT License)
* [ps2sdk](https://github.com/ps2dev/ps2sdk) (Academic Free License 2.0)
