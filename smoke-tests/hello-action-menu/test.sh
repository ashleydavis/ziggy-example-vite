#!/usr/bin/env bash

# Starts the built app through the remote control server, chooses the Hello menu's Say Hello From an Action as a user would, and checks
# the line the action's handler shows. A phone has no menu, so on a phone it checks nothing. It starts its own app, so the button
# scenario's line cannot be the one it finds.

source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

case "$ZIGGY_SMOKE_PLATFORM" in
    linux|windows|macos)
        start_test_app
        choose_menu_item hello-from-action
        wait_for_text action-output "Hello from an action" 30
        ;;
esac
