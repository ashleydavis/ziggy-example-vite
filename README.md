# Ziggy test app

An app made from the Ziggy template, in a folder of its own, to prove that an app outside Ziggy's repository can be built on Ziggy as a package. It was copied from `apps/ziggy-template`, renamed and pointed at a checkout of Ziggy's repository beside it, as [Building your app](https://github.com/ashleydavis/ziggy/blob/main/docs/building-your-app.md) describes, and holds no Ziggy source. Everything below is the example's description, which holds for it too. See [Ziggy architecture](https://github.com/ashleydavis/ziggy/blob/main/docs/architecture.md) for how the parts fit.

## What it shows

- The UI asks the Zig core a question (`ping`) and shows the answer.
- Tasks: a short task, a long task that queues child tasks and waits for them, several long tasks at once, cancelling by source and a task that fails. Output text, `job-progress` messages and every `task-message` and `task-completed` event appear in the UI.
- The edges of the bridge: a multi-megabyte payload; text with quotes, newlines and non-ASCII characters; an error reply and a file written and read in the app's private data directory.
- A native host callback: the UI asks for the operating system's version, a task calls the native app's callback and the answer comes back to the UI.
- File and folder pickers: three buttons ask the core for the native dialogs (`pick-files`, `pick-folder`, `pick-file`), and the UI shows the paths chosen. A phone has no save dialog, so that button gives an error on iOS.
- A loopback HTTP server in the core (the example's own code, not Ziggy's) that serves an example image and video to the UI, which loads them and asks for a range of bytes.
- Keep-alive tasks: a background task type registered as keep-alive that goes on running when the app is sent to the background (a phone), and a normal one that does not.
- UI storage: `localStorage` and IndexedDB values the UI writes and reads back after the app is started again.
- Dropped files: a drop zone that shows the real path of a dropped file, from `window.ziggy.getPathForFile`.
- A desktop menu defined once in Zig and drawn natively, with keyboard shortcuts that work anywhere in the window, and developer tools (Ctrl+Shift+I, or Cmd+Shift+I on a Mac) that open from it. A phone shows no menu.

## Where things are

Everything here is the app's own. Ziggy, the package it is built on, comes from a checkout of [Ziggy's repository](https://github.com/ashleydavis/ziggy) in a folder named `ziggy` beside this one, except in the Xcode projects, which still take a version tag.

- `build.zig` and `build.zig.zon`: the app's Zig build. It takes Ziggy as the dependency `ziggy` by the path of the checkout beside this one, and builds the core (`ziggy-test-app-backend`), the Linux and Windows native apps (`ziggy-test-app-linux`, `ziggy-test-app-windows`), dev mode (`ziggy-test-app-dev`) and the core's unit tests (`test`) with Ziggy's build functions.
- `package.json`: takes the UI's types from Ziggy as `ziggy-ui`, by the git URL of the same tag.
- `ui/`: the UI. `ui/index.html` is the UI and `ui/src/lib` holds the plain functions that have unit tests. `vite.config.ts` is its build, which writes `dist` with relative paths and a classic script so it loads from an address of the app's own in every web view. `dist` is embedded in the app's own code on every platform (the Linux and Windows executables, and the core library that the MacOS, iOS and Android apps contain), so no platform has a folder of UI files (see the [architecture guide](https://github.com/ashleydavis/ziggy/blob/main/docs/architecture.md#the-bundled-ui)).
- `core/`: the app's Zig library. `core/src/app.zig` declares the app with `ziggy.core.App`, listing each message name with its handler and each task type with its handler, and Ziggy's build exports Ziggy's C interface for it. The handlers, each with the request and response structs of its message, are in `core/src/lib`.
- `native/<platform>/`: the app's native project for each platform: its name, window, icon and the app's core and UI packaged together. Each one builds on Ziggy's part for that platform in `packages/ziggy/native/<platform>` of Ziggy's repository: the Linux and Windows native apps through the Zig build, the Xcode projects through the Swift package at the root of Ziggy's repository and the Android project through a Gradle source dependency on Ziggy's repository.
- `scripts`: the build, run, packaging and setup scripts, and the shell libraries the scripts and smoke tests share (`scripts/lib`), each with a markdown file beside it.
- `smoke-tests`: the smoke test scenarios and a library for each platform. See `smoke-tests/run.md`.

## Commands

From the root of this repository, `<platform>` being `linux`, `windows`, `macos`, `android` or `ios`. Each platform's commands run on that platform (MacOS and iOS need a Mac with Xcode 14.2, and Windows runs them under Git Bash).

| Command | What it does |
|---|---|
| `bun run setup` | One time per machine: the platform toolchains. |
| `bun run dev` | Runs the app in dev mode: Vite (the `dev:ui` script) serves the UI, the dev host runs the core in front of it, rebuilt as its Zig files change, and the default browser opens the dev host, with live reload. See the [dev host's README](https://github.com/ashleydavis/ziggy/blob/main/packages/ziggy/dev/README.md). |
| `bun run build:<platform>` | Builds the UI and the app. |
| `bun run run:<platform>` | Builds the app and launches it (an emulator, simulator or device for a phone). |
| `bun run open:<platform>` | Syncs, then opens the native project in its editor. |
| `bun run package:<platform>` | Packages the app for distribution, without the test hooks, into `out/<platform>`. |
| `bun run distribute:android` | Builds the Android app and uploads it to Firebase App Distribution for the tester group. See `scripts/distribute-android.md`. |
| `bun run clean:<platform>` | Removes the platform's build output. |
| `bun run test` | The UI's unit tests. |
| `bun run test:zig` | The core's unit tests. |
| `bun run test:zig:android` | The core's unit tests on an attached Android emulator or device (`:ios` for a booted iOS simulator). |
| `bun run test:smoke` | The smoke tests on the host operating system. |
| `bun run test:smoke:and` | The smoke tests on an attached Android emulator or device. |
| `bun run test:smoke:ios` | The smoke tests on the iOS simulator. |

`bun run package:<platform>` builds the release app, without the test hooks, and writes unsigned packages. Each platform's script doc says where they go and what they need:

| Platform | Packages | Script doc |
|---|---|---|
| `linux` | zip, `.deb` | `scripts/package-linux.md` |
| `windows` | zip, `.msi` installer | `scripts/package-windows.md` |
| `macos` | `.dmg`, zip | `scripts/package-macos.md` |
| `ios` | `.xcarchive`, `.ipa` | `scripts/package-ios.md` |
| `android` | `.apk` per architecture | `scripts/package-android.md` |

## Test hooks

The smoke tests drive the real app through the test hooks listed in "Test hooks" in the architecture guide. They are compiled in only by the `test-hooks` build option, which the smoke test runner sets and the `package` commands never do. Scenario `8-release-has-no-hooks` checks the release build has none.

## Glossary

- **The UI**: the app's HTML, CSS and JavaScript/TypeScript, which runs in the system web view. The native menus and file dialogs are not part of it.
- **The core**: the app's Zig code together with Ziggy's core library. It is the same on every platform, handles messages from the UI, runs tasks and never touches a window.
- **The native app**: the part of the app written separately for each platform. It opens the window, hosts the system web view and draws the menus and file dialogs. It also passes messages between the UI and the core. It lives in `native/`.
- See [Ziggy's glossary](https://github.com/ashleydavis/ziggy/blob/main/README.md#glossary) for the full list.

## CI

`.github/workflows/release.yml` runs on every push. It builds and cross-builds the Zig code, runs the unit tests and the smoke tests on every platform, packages the app for every platform and publishes the packages.
