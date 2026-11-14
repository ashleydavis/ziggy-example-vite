//
// The example's action, as the core finds it by its name.
//

const std = @import("std");
const app = @import("ziggy-example-vite-backend");

test "the Hello menu's action is found by its name as an action" {
    const target = app.app.menu_targets.get("hello-from-action") orelse return error.MenuItemMissing;
    try std.testing.expect(target == .action);
}

test "the File menu's New Window item is found by its action's name" {
    const target = app.app.menu_targets.get("new-window") orelse return error.MenuItemMissing;
    try std.testing.expect(target == .action);
}
