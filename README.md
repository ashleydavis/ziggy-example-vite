# Ziggy Vite example

An example app built on [Ziggy](https://github.com/ashleydavis/ziggy), with its frontend built by Vite. It is a copy of the Ziggy template, renamed and taking Ziggy from the checkout of Ziggy's repository beside it, and holds no Ziggy source. To run it, follow Ziggy's [quick start](https://github.com/ashleydavis/ziggy/blob/main/docs/quick-start.md). See [Ziggy architecture](https://github.com/ashleydavis/ziggy/blob/main/docs/development/architecture.md) for how the parts fit, and [Ziggy's glossary](https://github.com/ashleydavis/ziggy/blob/main/docs/glossary.md) for the terms the docs use.

## Hello world

The example is the smallest complete app: a hello world for each kind of code an app has, each with its test. Change each one into your own code and tests, or delete it.

| Kind | Code | Test |
|---|---|---|
| Frontend | `frontend/src/lib/hello-world.ts`, used by `frontend/src/main.ts` | `frontend/src/test/hello-world.test.ts` (`bun run test`) |
| Backend: a message handler and a task | `backend/src/lib/hello-world.zig`, registered in `backend/src/app.zig` | `backend/src/test/hello-world.test.zig` (`bun run test:zig`) |
| The whole app | The app | `smoke-tests/hello-world-app/test.sh` (`bun run test:smoke`) |

The page shows the backend's message response to the `hello-world` message, and a button starts the `hello-world-task` task and shows what it sends. The desktop menu is defined once in Zig (`backend/src/lib/menu.zig`) and drawn natively; a mobile device shows no menu.

## Where things are

Everything here is the app's own. Ziggy, the package it is built on, comes from the checkout of [Ziggy's repository](https://github.com/ashleydavis/ziggy) beside this one, `../ziggy`, the same checkout in every place below.

- `build.zig` and `build.zig.zon`: the app's Zig build. It takes Ziggy as the dependency `ziggy` by the path of that checkout, and builds the backend (`ziggy-example-vite-backend`), the Linux and Windows native apps (`ziggy-example-vite-linux`, `ziggy-example-vite-windows`), dev mode (`ziggy-example-vite-dev`) and the backend's unit tests (`test`) with Ziggy's build functions.
- `package.json`: takes the frontend's types from Ziggy as `ziggy`, from the same checkout.
- `frontend/`: the frontend. `frontend/index.html` is the frontend and `frontend/src/lib` holds the plain functions that have unit tests. `vite.config.ts` is its build, which writes `dist` with relative paths and a classic script so it loads from an address of the app's own in every web view. `dist` is embedded in the app's own code on every platform (the Linux and Windows executables, and the backend library that the MacOS, iOS and Android apps contain), so no platform has a folder of frontend files (see the [architecture guide](https://github.com/ashleydavis/ziggy/blob/main/docs/development/architecture.md#the-bundled-frontend)).
- `backend/`: the app's Zig library. `backend/src/app.zig` declares the app with `ziggy.core.App`, listing each message name with its handler and each task type with its handler, and Ziggy's build exports Ziggy's C interface for it. The handlers are in `backend/src/lib`. Ziggy writes the app's log files in `<data directory>/logs`, named and headed from `app.zon` (its name, title and version) (see Ziggy's [logging guide](https://github.com/ashleydavis/ziggy/blob/main/docs/user-guide/logging.md)).
- `native/<platform>/`: the app's native project for each platform: its name, window, icon and the app's backend and frontend packaged together. Each one builds on Ziggy's part for that platform in `packages/ziggy/native/<platform>` of Ziggy's repository: the Linux and Windows native apps through the Zig build, the Xcode projects through the Swift package at the root of that checkout, as a local package, and the Android project through a Gradle included build of that checkout.
- `scripts`: the build, run, packaging and setup scripts, and the shell libraries the scripts share (`scripts/lib`), each with a markdown file beside it.
- `smoke-tests`: the smoke tests, with a library for each platform that builds, starts and stops the app. See `smoke-tests/run.md`.

## Getting started

Install [mise](https://mise.jdx.dev) and the libraries and tools your platform needs, listed in Ziggy's [Dependencies](https://github.com/ashleydavis/ziggy/blob/main/docs/user-guide/dependencies.md).

Then get the app and its tools:

```bash
git clone https://github.com/ashleydavis/ziggy-example-vite.git
cd ziggy-example-vite
mise trust
mise install
bun install
```

Then build and run the app with `bun run <platform>` (for example `bun run linux`), using the commands below.

## Commands

From the root of this repository, `<platform>` being `linux`, `windows`, `macos`, `android` or `ios`. Each platform's commands run on that platform (MacOS and iOS need a Mac with Xcode 14.2, and Windows runs them under Git Bash).

| Command | What it does |
|---|---|
| `bun run setup` | One time per machine: the platform toolchains. |
| `bun run compile` (alias `bun run c`) | Type-checks the TypeScript. |
| `bun run compile:zig` | Builds the frontend and the backend for this machine, then cross-builds the backend for every other platform and checks the Windows native app compiles. See `scripts/zig-packages.md`. |
| `bun run bundle:ui` | Builds the frontend into `dist`, which every platform embeds. |
| `bun run sync:<platform>` | Builds the frontend and the backend and puts what the platform's native project needs where it expects it. |
| `bun run dev` | Runs the app in dev mode: Vite (the `dev:ui` script) serves the frontend, the dev host runs the backend in front of it, rebuilt as its Zig files change, and the default browser opens the dev host, with live reload. See the [dev host's README](https://github.com/ashleydavis/ziggy/blob/main/packages/ziggy/dev/README.md). `zig build ziggy-example-vite-dev -- --no-open` does the same without opening the browser. |
| `bun run build:<platform>` | Builds the frontend and the app. |
| `bun run <platform>` | Builds the app and launches it (an emulator, simulator or device for a phone). |
| `bun run open:<platform>` | Syncs, then opens the native project in its editor. |
| `bun run package:<platform>` | Packages the app for distribution, without the test hooks, into `out/<platform>`. |
| `bun run distribute:android` | Builds the Android app and uploads it to Firebase App Distribution for the tester group. See `scripts/distribute-android.md`. |
| `bun run clean:<platform>` | Removes the platform's build output. |
| `bun run clean` | Runs the clean for every platform this machine can clean. |
| `bun run test` (alias `bun run t`) | The frontend's unit tests. |
| `bun run test:zig` | The backend's unit tests. |
| `bun run test:smoke` | The smoke tests on the host operating system. `bun run test:smoke -- <name>` runs one. |
| `bun run test:smoke:android` | The smoke tests on an attached Android emulator or device. |
| `bun run test:smoke:ios` | The smoke tests on a connected iPhone or iPad when there is one, otherwise the iOS simulator. |
| `bun run install-hooks` | Installs the pre-commit hook into this clone. Run once per clone. See `scripts/install-hooks.md`. |
| `bun run test:everything` | Runs the checks (`compile`, `test`, `compile:zig`, `test:zig` and `test:smoke`) whose files changed since each last passed. The pre-commit hook runs it. `-- --force` runs them all. See `scripts/test-everything.md`. |

`bun run package:<platform>` builds the release app, without the test hooks, and writes unsigned packages. Each platform's script doc explains where they go and what they need:

| Platform | Packages | Script doc |
|---|---|---|
| `linux` | zip, `.deb` | `scripts/package-linux.md` |
| `windows` | zip, `.msi` installer | `scripts/package-windows.md` |
| `macos` | `.dmg`, zip | `scripts/package-macos.md` |
| `ios` | `.xcarchive`, `.ipa` | `scripts/package-ios.md` |
| `android` | `.apk` per architecture | `scripts/package-android.md` |

## Test hooks

The smoke tests drive the real app through the test hooks listed in "Test hooks" in the architecture guide: `backend/src/lib/ui-query.zig` tells the frontend it is in test mode, and `frontend/src/lib/test-commands.ts` handles the commands the smoke tests send. They are compiled in only by the `test-hooks` build option, which the smoke test runner sets and the `package` commands never do.

## CI

Every push runs `.github/workflows/ci.yml`, which compiles and unit tests the TypeScript, cross-builds the Zig code for every platform and runs the backend's unit tests, and a release workflow per platform (`.github/workflows/release-<platform>.yml`), which runs the smoke tests on that platform (on macOS, on Apple Silicon only), packages the app and, on the default branch, publishes the packages.
