#!/usr/bin/env bash

# Starts the built app through the remote control server, presses the shortcut of the Hello menu's Say Hello From an Action as a user
# would, through the native app, and checks the line the action's handler shows. A mobile has no shortcuts, so on a mobile it checks
# nothing. It starts its own app, so the button scenario's line cannot be the one it finds.

source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

case "$ZIGGY_SMOKE_PLATFORM" in
    linux|windows|macos)
        start_test_app
        press_key CmdOrCtrl+Shift+H
        wait_for_text action-output "Hello from an action" 30
        ;;
esac
