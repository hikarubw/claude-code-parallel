#!/bin/bash
# Demo: Pueue-TUI as a general-purpose visualization tool
# Shows how it works for non-Claude use cases

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}=== Pueue-TUI General Purpose Demo ===${NC}"
echo "Showing how Pueue-TUI visualizes ANY Pueue tasks"
echo

# Ensure Pueue is running
if ! pueue status &>/dev/null; then
    echo "Starting Pueue daemon..."
    pueued -d
    sleep 2
fi

# Demo 1: Build System
demo_build() {
    echo -e "${GREEN}Demo 1: Parallel Build System${NC}"
    echo "Compiling a C++ project with visible progress..."
    
    # Clean any existing
    pueue clean --group build 2>/dev/null || true
    pueue group add build 2>/dev/null || true
    
    # Add compilation tasks
    pueue add --group build --label "compile-main" \
        'echo "🔨 Compiling main.cpp..." && sleep 3 && echo "✅ main.o created"'
    
    pueue add --group build --label "compile-utils" \
        'echo "🔨 Compiling utils.cpp..." && sleep 2 && echo "✅ utils.o created"'
    
    pueue add --group build --label "compile-network" \
        'echo "🔨 Compiling network.cpp..." && sleep 4 && echo "✅ network.o created"'
    
    # Linking depends on compilation
    MAIN_ID=$(pueue status --json | jq -r '.tasks | to_entries | .[] | select(.value.label == "compile-main") | .key')
    UTILS_ID=$(pueue status --json | jq -r '.tasks | to_entries | .[] | select(.value.label == "compile-utils") | .key')
    NETWORK_ID=$(pueue status --json | jq -r '.tasks | to_entries | .[] | select(.value.label == "compile-network") | .key')
    
    pueue add --group build --label "link-app" \
        --after $MAIN_ID --after $UTILS_ID --after $NETWORK_ID \
        'echo "🔗 Linking application..." && sleep 2 && echo "✅ app.exe created!"'
    
    echo -e "${YELLOW}Starting Pueue-TUI visualization...${NC}"
    ./pueue-tui start --group build --workers 3 --session pueue-tui-build
    
    echo
    echo -e "${MAGENTA}Watch the parallel compilation!${NC}"
    echo "Notice how linking waits for all compilations to complete."
    echo
    read -p "Press Enter to continue to next demo..."
    
    ./pueue-tui stop pueue-tui-build
}

# Demo 2: Test Suite
demo_tests() {
    echo -e "${GREEN}Demo 2: Parallel Test Suite${NC}"
    echo "Running different test types simultaneously..."
    
    pueue clean --group tests 2>/dev/null || true
    pueue group add tests 2>/dev/null || true
    
    # Add test tasks
    pueue add --group tests --label "unit-tests" \
        'echo "🧪 Running unit tests..." && 
         for i in {1..5}; do 
           echo "  Test $i: ✅ PASS"; 
           sleep 1; 
         done && 
         echo "Unit tests: 5/5 passed"'
    
    pueue add --group tests --label "integration-tests" \
        'echo "🔄 Running integration tests..." && 
         for i in {1..3}; do 
           echo "  Integration test $i: ✅ PASS"; 
           sleep 2; 
         done && 
         echo "Integration tests: 3/3 passed"'
    
    pueue add --group tests --label "e2e-tests" \
        'echo "🌐 Running E2E tests..." && 
         echo "  Starting browser..." && sleep 2 &&
         echo "  Testing login flow: ✅" && sleep 1 &&
         echo "  Testing checkout: ✅" && sleep 1 &&
         echo "E2E tests: All passed"'
    
    echo -e "${YELLOW}Starting Pueue-TUI visualization...${NC}"
    ./pueue-tui start --group tests --workers 3 --session pueue-tui-tests
    
    echo
    echo -e "${MAGENTA}Watch all test types run in parallel!${NC}"
    echo
    read -p "Press Enter to continue to next demo..."
    
    ./pueue-tui stop pueue-tui-tests
}

# Demo 3: Data Pipeline
demo_pipeline() {
    echo -e "${GREEN}Demo 3: Data Processing Pipeline${NC}"
    echo "ETL pipeline with visible progress..."
    
    pueue clean --group pipeline 2>/dev/null || true
    pueue group add pipeline 2>/dev/null || true
    
    # Extract tasks
    pueue add --group pipeline --label "extract-db1" \
        'echo "📊 Extracting from Database 1..." && 
         for i in {1..100}; do 
           printf "\rExtracting: %d%%" $i; 
           sleep 0.03; 
         done && 
         echo -e "\n✅ Extracted 1M records from DB1"'
    
    pueue add --group pipeline --label "extract-api" \
        'echo "🌐 Extracting from API..." && 
         for i in {1..100}; do 
           printf "\rFetching: %d%%" $i; 
           sleep 0.02; 
         done && 
         echo -e "\n✅ Fetched 500K records from API"'
    
    # Transform depends on extract
    EXTRACT1=$(pueue status --json | jq -r '.tasks | to_entries | last | .key')
    
    pueue add --group pipeline --label "transform-data" \
        --after $EXTRACT1 \
        'echo "🔄 Transforming data..." && 
         echo "  Cleaning..." && sleep 2 &&
         echo "  Normalizing..." && sleep 2 &&
         echo "  Enriching..." && sleep 1 &&
         echo "✅ Transformed 1.5M records"'
    
    echo -e "${YELLOW}Starting Pueue-TUI visualization...${NC}"
    ./pueue-tui start --group pipeline --workers 3 --session pueue-tui-pipeline
    
    echo
    echo -e "${MAGENTA}Watch the ETL pipeline process data!${NC}"
    echo
    read -p "Press Enter to continue to final demo..."
    
    ./pueue-tui stop pueue-tui-pipeline
}

# Demo 4: Mixed Workload
demo_mixed() {
    echo -e "${GREEN}Demo 4: Mixed Workload Orchestration${NC}"
    echo "Different task types in one view..."
    
    pueue clean 2>/dev/null || true
    
    # Add various tasks
    pueue add --label "backup-db" \
        'echo "💾 Starting database backup..." && 
         for i in {1..10}; do 
           echo "  Backing up table $i..."; 
           sleep 0.5; 
         done && 
         echo "✅ Backup complete"'
    
    pueue add --label "send-emails" \
        'echo "📧 Sending notification emails..." && 
         for i in {1..5}; do 
           echo "  Email $i sent"; 
           sleep 1; 
         done && 
         echo "✅ All emails sent"'
    
    pueue add --label "generate-report" \
        'echo "📊 Generating daily report..." && 
         echo "  Collecting metrics..." && sleep 2 &&
         echo "  Creating charts..." && sleep 2 &&
         echo "  Formatting PDF..." && sleep 1 &&
         echo "✅ Report generated: daily-report.pdf"'
    
    pueue add --label "cleanup-logs" \
        'echo "🧹 Cleaning old logs..." && 
         echo "  Found 1.2GB of logs > 30 days" && sleep 1 &&
         echo "  Archiving..." && sleep 2 &&
         echo "  Deleting..." && sleep 1 &&
         echo "✅ Freed 1.2GB disk space"'
    
    echo -e "${YELLOW}Starting Pueue-TUI visualization...${NC}"
    ./pueue-tui start --workers 4 --session pueue-tui-mixed
    
    echo
    echo -e "${MAGENTA}Watch different task types run simultaneously!${NC}"
    echo
    read -p "Press Enter to finish demo..."
    
    ./pueue-tui stop pueue-tui-mixed
}

# Main demo flow
main() {
    echo -e "${BLUE}This demo shows Pueue-TUI as a general-purpose tool${NC}"
    echo "It works with ANY commands, not just Claude!"
    echo
    echo "We'll demonstrate:"
    echo "1. Parallel build system"
    echo "2. Test suite execution"
    echo "3. Data pipeline processing"
    echo "4. Mixed workload orchestration"
    echo
    read -p "Press Enter to start..."
    echo
    
    demo_build
    echo
    
    demo_tests
    echo
    
    demo_pipeline
    echo
    
    demo_mixed
    echo
    
    echo -e "${GREEN}=== Demo Complete! ===${NC}"
    echo
    echo "Pueue-TUI makes ANY Pueue workflow visible and interactive!"
    echo
    echo "Key benefits demonstrated:"
    echo "- 👀 See everything happening in real-time"
    echo "- 🔄 Visualize task dependencies"
    echo "- 📊 Monitor progress and output"
    echo "- 🎯 Debug issues immediately"
    echo
    echo "Perfect for:"
    echo "- Build systems (make, gradle, cargo)"
    echo "- Test suites (pytest, jest, rspec)"
    echo "- Data pipelines (ETL, ML training)"
    echo "- DevOps tasks (deployments, backups)"
    echo "- AI agents (LLMs, automation)"
    echo
    echo "Get Pueue-TUI: github.com/anthropics/pueue-tui"
}

# Run demo
main