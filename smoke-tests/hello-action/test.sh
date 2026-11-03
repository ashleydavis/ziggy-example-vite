#!/usr/bin/env bash

# Starts the built app through the remote control server, presses the "Say hello from an action" button, which runs the example's
# action by its name, and checks the line its handler shows. It runs on every platform, phones included.

source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

start_test_app
click run-hello-action
wait_for_text action-output "Hello from an action" 30
