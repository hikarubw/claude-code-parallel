#!/bin/bash
# Demo script to show Claude Code Parallel in action

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Claude Code Parallel Demo ===${NC}"
echo ""
echo "This demo shows the hybrid Pueue+Tmux architecture in action."
echo ""

# Clean up first
echo "1. Cleaning up previous state..."
"$SCRIPT_DIR/tools/setup-hybrid" clean
sleep 1

# Setup with 2 workers
echo -e "\n${YELLOW}2. Setting up with 2 workers...${NC}"
"$SCRIPT_DIR/tools/setup-hybrid" 2
sleep 2

# Show current status
echo -e "\n${YELLOW}3. Current system status:${NC}"
"$SCRIPT_DIR/start-parallel.sh" status

# Add some dummy tasks to Pueue
echo -e "\n${YELLOW}4. Adding demo tasks to queue...${NC}"
pueue add --group subissues --label "demo-task-1" -- sleep 10 "# Processing subissue 501"
pueue add --group subissues --label "demo-task-2" -- sleep 15 "# Processing subissue 502" 
pueue add --group subissues --label "demo-task-3" -- sleep 8 "# Processing subissue 503"

# Show queue status
echo -e "\n${YELLOW}5. Queue status:${NC}"
pueue status --group subissues

echo -e "\n${GREEN}Demo setup complete!${NC}"
echo ""
echo "To see the live system:"
echo -e "  ${BLUE}tmux attach -t claude-workers${NC}"
echo ""
echo "What you'll see:"
echo "- Pane 0: Worker monitor (overall status)"
echo "- Pane 1-2: Workers polling for tasks"
echo ""
echo "The workers will pick up tasks from Pueue and execute them."
echo "This simulates how Claude would process real subissues."