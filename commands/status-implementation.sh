#!/bin/bash
# Implementation of /project:status command
# Uses the new unified monitoring system

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TOOLS_DIR="$PROJECT_ROOT/tools"

# Extract options from arguments
ARGUMENTS="${1:-}"

# Convert arguments to project-status options
OPTIONS=""

if [[ "$ARGUMENTS" =~ --watch ]]; then
    OPTIONS="$OPTIONS --watch"
fi

if [[ "$ARGUMENTS" =~ --workers ]]; then
    OPTIONS="$OPTIONS --workers"
elif [[ "$ARGUMENTS" =~ --queue ]]; then
    OPTIONS="$OPTIONS --queue"
elif [[ "$ARGUMENTS" =~ --issues ]]; then
    OPTIONS="$OPTIONS --issues"
fi

if [[ "$ARGUMENTS" =~ --verbose ]]; then
    OPTIONS="$OPTIONS --verbose"
fi

if [[ "$ARGUMENTS" =~ --json ]]; then
    OPTIONS="$OPTIONS --json"
fi

# Execute the enhanced project-status tool
exec "$TOOLS_DIR/project-status" $OPTIONS