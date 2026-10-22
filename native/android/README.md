# Ziggy Vite example, Android native app

The example's Android project: one activity (`MainActivity`) that hosts a web view run by Ziggy's Android native app (`packages/ziggy/native/android` in Ziggy's repository). Package `dev.ziggy.examplevite`. The SDK levels and the NDK are in `variables.gradle`, which the scripts read too. Ziggy's Android native app is a Gradle build of its own, which `settings.gradle` includes from the checkout of Ziggy beside this repository, and the app depends on it as `dev.ziggy:ziggy-native-android`.

What is packaged:

- The Zig core library `libziggy_example_vite.so` per architecture (`arm64-v8a` and `x86_64`), with the JNI entry points in Zig.
- The built frontend and the script that exposes `window.ziggy`, both embedded in `libziggy_example_vite.so`. The native app serves every request to `https://ziggy-app.invalid/` (a host name that can never be looked up) from the frontend, so the APK has no frontend files and no assets of its own.

All of it is generated into `app/build/ziggy` by `scripts/sync-android.sh`; see `scripts/*-android.md` for the setup, sync, build, run, open, package and clean scripts.

The debug build has the INTERNET permission (in `app/src/debug`), because a test hooks build opens its control connection on the loopback address and Android refuses an app any socket without it. The release build has no such permission.


The example's file and directory pickers (`pick-files`, `pick-folder`, `pick-file`) use the system document pickers through Ziggy's Android native app, which describes them: opened files are copied into the app's cache directory and returned as file system paths, while a chosen directory or a save location is returned as a `content://` Uri, which is not a file system path. `MainActivity` forwards `onActivityResult` to the native app.
