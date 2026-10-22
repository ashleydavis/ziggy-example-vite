//
// Everything the example adds to Ziggy's core library: the messages its frontend sends and the tasks it queues, each with the Zig
// function that handles it, its menu and its built frontend. Ziggy's build serves the app declared here.
//

const ziggy = @import("ziggy");
const hello_world_backend = @import("lib/hello-world-backend.zig");
const menu = @import("lib/menu.zig");
const ui_query = @import("lib/ui-query.zig");
const ui = @import("ui-files");

//
// The example, registered with Ziggy's core: each message name with its handler and each task type with its task.
//
pub const app = ziggy.core.App(.{
    .messages = .{
        .@"hello-world" = hello_world_backend.helloWorldHandler,
    },
    .tasks = .{
        .@"hello-world-task" = hello_world_backend.helloWorldTaskHandler,
    },
    .menu = menu.menu,
    .ui_files = &ui.files,
    .ui_query = ui_query.uiQuery,
});
