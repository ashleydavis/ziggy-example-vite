//
// The Ziggy Vite example's Windows native app: what is the example's own (its name, its window and its frontend) on top of the
// part Ziggy provides. The frontend is embedded in the executable by build.zig.
//

const std = @import("std");
const native_app = @import("ziggy-native-windows");

pub fn main(init: std.process.Init) !u8 {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    return try native_app.run(.{
        .app_id = "dev.ziggy.examplevite",
        .title = "Ziggy Vite example",
        .default_width = 900,
        .default_height = 800,
        .icon_resource = null,
    }, args);
}
