# sync-linux.sh

Builds the example's frontend (`bun run bundle:ui`) and its Linux native app (the `ziggy-example-vite-linux` step of the example's `build.zig`, installed to `native/linux/zig-out`). The native app's build embeds every file of the built frontend in the executable, so `native/linux/zig-out/bin/ziggy-example-vite` is the whole app and needs no files beside it. Runs on Linux.

## Usage

`bash scripts/sync-linux.sh [--optimize <mode>] [--test-hooks]`

Run it through the root `package.json` script, not directly.

## Arguments

- `--optimize <Debug|ReleaseSafe|ReleaseFast|ReleaseSmall>`: the Zig optimize mode. Default `ReleaseSafe`.
- `--test-hooks`: builds the test hooks into the app (the test control connection). Off by default, and never used for `package-linux.sh`.
