const std = @import("std");
const example = @import("ziggy-test-app-core");

test "the menu has the .ui items the UI handles; toggle-devtools and quit are standard items" {
    for ([_][]const u8{ "start-short", "start-long", "start-many", "cancel-long", "about" }) |name| {
        try std.testing.expect(example.app.menu_targets.get(name).? == .ui);
    }
    try std.testing.expectEqual(@as(usize, 5), example.app.menu_targets.keys().len);
    for ([_][]const u8{ "toggle-devtools", "quit" }) |action| {
        try std.testing.expect(example.app.menu_targets.get(action) == null);
        const wanted = try std.fmt.allocPrint(std.testing.allocator, "\"action\":\"{s}\"", .{action});
        defer std.testing.allocator.free(wanted);
        try std.testing.expect(std.mem.indexOf(u8, example.app.menu_json, wanted) != null);
    }
}
