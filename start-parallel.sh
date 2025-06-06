#!/bin/bash
# Claude Code Parallel - Quick Start Script

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Default values
DEFAULT_WORKERS=4

# Show usage
usage() {
    echo "Usage: $0 <command> [args]"
    echo ""
    echo "Commands:"
    echo "  work ISSUES [WORKERS]  - Start working on issues with N workers"
    echo "  status                 - Show current status"
    echo "  stop                   - Stop all workers"
    echo "  help                   - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 work 123,124 4      - Work on issues #123 and #124 with 4 workers"
    echo "  $0 status              - Check progress"
    echo "  $0 stop                - Stop everything"
}

# Main command handler
case "${1:-help}" in
    work)
        if [ -z "$2" ]; then
            echo -e "${RED}Error: No issues specified${NC}"
            echo "Usage: $0 work ISSUES [WORKERS]"
            exit 1
        fi
        
        ISSUES="$2"
        WORKERS="${3:-$DEFAULT_WORKERS}"
        
        echo -e "${GREEN}🚀 Starting Claude Code Parallel${NC}"
        echo "Issues: $ISSUES"
        echo "Workers: $WORKERS"
        echo ""
        
        # Run setup if not already done
        if ! pueue status &>/dev/null; then
            echo "Running initial setup..."
            "$SCRIPT_DIR/tools/setup-hybrid"
        fi
        
        # Analyze issues and add to queue
        echo "Analyzing issues..."
        "$SCRIPT_DIR/tools/analyze" "$ISSUES"
        
        # Start workers and monitor
        echo "Starting workers..."
        "$SCRIPT_DIR/tools/session" start "$WORKERS"
        
        # Show status
        echo ""
        echo -e "${GREEN}System started!${NC}"
        echo "Monitor with: tmux attach -t claude-workers"
        echo "Check status: $0 status"
        ;;
        
    status)
        "$SCRIPT_DIR/tools/status-implementation"
        ;;
        
    stop)
        echo "Stopping all workers..."
        "$SCRIPT_DIR/tools/session" stop
        echo -e "${GREEN}All workers stopped${NC}"
        ;;
        
    help|--help|-h)
        usage
        ;;
        
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        usage
        exit 1
        ;;
esac