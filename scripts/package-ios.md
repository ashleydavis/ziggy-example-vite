# package-ios

Runs `xcodebuild archive` for a device with code signing off (`CODE_SIGNING_ALLOWED=NO`), producing `ziggy-example-vite-<version>-ios-arm64.xcarchive`, and packs the unsigned app from it as `ziggy-example-vite-<version>-ios-arm64.ipa`, both in `out/ios`. The build files go in `native/ios/zig-out/package`. The version comes from `package.json`. The artifacts must be signed before they install on a device.

Run it on a Mac: `bash scripts/package-ios.sh`.

## Arguments

- `--output-dir <dir>`: where the packages go. Default: `out/ios`.
