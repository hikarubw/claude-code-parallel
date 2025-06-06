#!/bin/bash
# Integration Tests for Hybrid Pueue+Tmux Architecture
# Tests the complete workflow from issue analysis to PR creation

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TEST_REPO="${TEST_REPO:-/tmp/test-claude-parallel-integration}"
LOG_DIR="${TEST_REPO}/integration-logs"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Load project tools
export PATH="$PROJECT_ROOT/tools:$PROJECT_ROOT/commands:$PATH"

# Test prerequisites
check_prerequisites() {
    echo -e "${BLUE}Checking prerequisites...${NC}"
    
    # Check required tools exist
    local tools=("setup-hybrid" "hybrid-worker" "queue-pueue" "analyze" "github")
    for tool in "${tools[@]}"; do
        if [ ! -f "$PROJECT_ROOT/tools/$tool" ]; then
            echo -e "${RED}Missing tool: $tool${NC}"
            exit 1
        fi
    done
    
    # Check GitHub CLI authentication
    if ! gh auth status &>/dev/null; then
        echo -e "${RED}GitHub CLI not authenticated. Run: gh auth login${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Prerequisites satisfied${NC}"
}

# Setup test environment
setup_integration_env() {
    echo -e "${BLUE}Setting up integration test environment...${NC}"
    
    mkdir -p "$LOG_DIR"
    
    # Run hybrid setup
    echo "Running hybrid setup..."
    "$PROJECT_ROOT/tools/setup-hybrid" >> "$LOG_DIR/setup_${TIMESTAMP}.log" 2>&1
    
    # Create test repository if needed
    if [ -n "${CREATE_TEST_REPO:-}" ]; then
        echo "Creating test repository..."
        create_test_repository
    fi
    
    echo -e "${GREEN}Integration environment ready${NC}"
}

# Test 1: Full Workflow - Issue to PR
test_full_workflow() {
    echo -e "\n${BLUE}INTEGRATION TEST 1: Full Workflow - Issue to PR${NC}"
    local test_log="$LOG_DIR/test1_full_workflow_${TIMESTAMP}.log"
    
    # Check if we have test issues
    if [ -z "${TEST_ISSUES:-}" ]; then
        echo -e "${YELLOW}No TEST_ISSUES provided. Skipping full workflow test.${NC}"
        echo "Set TEST_ISSUES environment variable with GitHub issue numbers"
        return 0
    fi
    
    # Start work on issues
    echo "Starting parallel work on issues: $TEST_ISSUES"
    cd "$PROJECT_ROOT"
    
    # Use the work command
    "$PROJECT_ROOT/commands/work" "$TEST_ISSUES" 4 >> "$test_log" 2>&1 &
    local work_pid=$!
    
    # Monitor progress
    echo "Monitoring progress..."
    local timeout=300  # 5 minutes
    local elapsed=0
    
    while [ $elapsed -lt $timeout ]; do
        # Check queue status
        local queued=$(pueue status --json 2>/dev/null | jq -r '.tasks | map(select(.status == "Queued")) | length' || echo 0)
        local running=$(pueue status --json 2>/dev/null | jq -r '.tasks | map(select(.status == "Running")) | length' || echo 0)
        local done=$(pueue status --json 2>/dev/null | jq -r '.tasks | map(select(.status == "Done")) | length' || echo 0)
        
        echo -ne "\rQueued: $queued | Running: $running | Done: $done"
        
        # Check if work command finished
        if ! ps -p $work_pid > /dev/null 2>&1; then
            echo -e "\n${GREEN}✓ Work command completed${NC}"
            break
        fi
        
        sleep 5
        elapsed=$((elapsed + 5))
    done
    
    # Verify PRs were created
    echo -e "\nVerifying PR creation..."
    local pr_count=$(gh pr list --state open --json number | jq '. | length')
    
    if [ "$pr_count" -gt 0 ]; then
        echo -e "${GREEN}✓ Created $pr_count PRs successfully${NC}"
        return 0
    else
        echo -e "${RED}✗ No PRs created${NC}"
        return 1
    fi
}

# Test 2: Auto-Approval Integration
test_auto_approval() {
    echo -e "\n${BLUE}INTEGRATION TEST 2: Auto-Approval Integration${NC}"
    local test_log="$LOG_DIR/test2_auto_approval_${TIMESTAMP}.log"
    
    # Check if auto-approve is running
    if ! pgrep -f "auto-approve" > /dev/null; then
        echo "Starting auto-approve daemon..."
        "$PROJECT_ROOT/tools/auto-approve" >> "$LOG_DIR/auto_approve_${TIMESTAMP}.log" 2>&1 &
        sleep 2
    fi
    
    # Create a tmux session that needs approval
    echo "Creating test session requiring approval..."
    tmux new-session -d -s test-approval "echo 'Waiting for approval...'; read -p 'Approve? [y/N] ' response; echo \"Response: \$response\""
    
    # Wait for auto-approval
    sleep 5
    
    # Check if session was approved
    if ! tmux has-session -t test-approval 2>/dev/null; then
        echo -e "${GREEN}✓ Auto-approval integration working${NC}"
        return 0
    else
        # Check session output
        local output=$(tmux capture-pane -t test-approval -p)
        if [[ "$output" == *"Response: y"* ]]; then
            echo -e "${GREEN}✓ Auto-approval sent 'y' response${NC}"
            tmux kill-session -t test-approval
            return 0
        fi
    fi
    
    echo -e "${RED}✗ Auto-approval not working${NC}"
    tmux kill-session -t test-approval 2>/dev/null || true
    return 1
}

# Test 3: Queue Adapter Integration
test_queue_adapter() {
    echo -e "\n${BLUE}INTEGRATION TEST 3: Queue Adapter Integration${NC}"
    local test_log="$LOG_DIR/test3_queue_adapter_${TIMESTAMP}.log"
    
    # Test queue-pueue adapter commands
    echo "Testing queue adapter..."
    
    # Add item
    "$PROJECT_ROOT/tools/queue-pueue" add "test-item-1" 5 >> "$test_log" 2>&1
    "$PROJECT_ROOT/tools/queue-pueue" add "test-item-2" 10 >> "$test_log" 2>&1
    
    # Check status
    local status_output=$("$PROJECT_ROOT/tools/queue-pueue" status 2>&1)
    
    if [[ "$status_output" == *"test-item-1"* ]] && [[ "$status_output" == *"test-item-2"* ]]; then
        echo -e "${GREEN}✓ Queue adapter add/status working${NC}"
        
        # Test pop
        local popped=$("$PROJECT_ROOT/tools/queue-pueue" pop 2>&1)
        if [[ "$popped" == *"test-item-2"* ]]; then
            echo -e "${GREEN}✓ Queue adapter pop working (priority order)${NC}"
            
            # Clean up
            pueue clean
            return 0
        fi
    fi
    
    echo -e "${RED}✗ Queue adapter integration failed${NC}"
    return 1
}

# Test 4: Hybrid Worker Integration
test_hybrid_worker() {
    echo -e "\n${BLUE}INTEGRATION TEST 4: Hybrid Worker Integration${NC}"
    local test_log="$LOG_DIR/test4_hybrid_worker_${TIMESTAMP}.log"
    
    # Create a test subissue file
    local test_subissue="/tmp/test-subissue-${TIMESTAMP}.json"
    cat > "$test_subissue" << EOF
{
    "number": 9999,
    "title": "Test: Integration test subissue",
    "body": "This is a test subissue for integration testing",
    "parent": 9998,
    "complexity": 5,
    "implementation": "echo 'Test implementation'"
}
EOF
    
    # Test hybrid worker
    echo "Testing hybrid worker..."
    "$PROJECT_ROOT/tools/hybrid-worker" 1 "$test_subissue" >> "$test_log" 2>&1 &
    local worker_pid=$!
    
    # Wait for worker to start
    sleep 3
    
    # Check if tmux session was created
    if tmux has-session -t "worker-1" 2>/dev/null; then
        echo -e "${GREEN}✓ Hybrid worker created tmux session${NC}"
        
        # Check Pueue task
        local pueue_tasks=$(pueue status --json | jq -r '.tasks | map(select(.label | contains("worker-1"))) | length')
        if [ "$pueue_tasks" -gt 0 ]; then
            echo -e "${GREEN}✓ Hybrid worker integrated with Pueue${NC}"
        fi
        
        # Clean up
        tmux kill-session -t "worker-1" 2>/dev/null || true
        rm -f "$test_subissue"
        return 0
    fi
    
    echo -e "${RED}✗ Hybrid worker integration failed${NC}"
    rm -f "$test_subissue"
    return 1
}

# Test 5: Error Recovery Integration
test_error_recovery() {
    echo -e "\n${BLUE}INTEGRATION TEST 5: Error Recovery Integration${NC}"
    local test_log="$LOG_DIR/test5_error_recovery_${TIMESTAMP}.log"
    
    # Create a failing task
    echo "Creating task that will fail..."
    local task_id=$(pueue add --print-task-id "exit 1" 2>/dev/null)
    
    sleep 3
    
    # Check if marked as failed
    local status=$(pueue status $task_id --json | jq -r '.tasks[0].status')
    if [ "$status" = "Failed" ]; then
        echo -e "${GREEN}✓ Failed task detected${NC}"
        
        # Test automatic retry (if implemented)
        # For now, just test manual retry
        pueue restart $task_id
        echo "Task restarted for retry"
        
        return 0
    fi
    
    echo -e "${RED}✗ Error recovery test failed${NC}"
    return 1
}

# Test 6: Performance Under Load
test_performance_load() {
    echo -e "\n${BLUE}INTEGRATION TEST 6: Performance Under Load${NC}"
    local test_log="$LOG_DIR/test6_performance_${TIMESTAMP}.log"
    
    # Configure for performance test
    pueue parallel 8
    
    # Create many tasks to simulate load
    echo "Creating 50 tasks to simulate load..."
    for i in {1..50}; do
        pueue add --label "perf-test-$i" "sleep $((RANDOM % 3 + 1))" >> "$test_log" 2>&1
    done
    
    # Monitor system resources
    echo "Monitoring performance..."
    local start_time=$(date +%s)
    local max_cpu=0
    local max_mem=0
    
    for i in {1..10}; do
        # Get Pueue daemon stats (simplified)
        local cpu=$(ps aux | grep pueued | grep -v grep | awk '{print $3}' | head -1)
        local mem=$(ps aux | grep pueued | grep -v grep | awk '{print $4}' | head -1)
        
        # Track maximums
        if (( $(echo "$cpu > $max_cpu" | bc -l) )); then
            max_cpu=$cpu
        fi
        if (( $(echo "$mem > $max_mem" | bc -l) )); then
            max_mem=$mem
        fi
        
        sleep 2
    done
    
    echo -e "${GREEN}✓ Performance test completed${NC}"
    echo "Max CPU: ${max_cpu}%, Max Memory: ${max_mem}%"
    
    # Clean up
    pueue clean
    return 0
}

# Run all integration tests
run_integration_tests() {
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Claude Code Parallel - Integration Tests v0.3.0  ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    
    check_prerequisites
    setup_integration_env
    
    local passed=0
    local failed=0
    local tests=(
        "test_full_workflow"
        "test_auto_approval"
        "test_queue_adapter"
        "test_hybrid_worker"
        "test_error_recovery"
        "test_performance_load"
    )
    
    for test in "${tests[@]}"; do
        if $test; then
            ((passed++))
        else
            ((failed++))
        fi
    done
    
    echo -e "\n${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}              INTEGRATION TEST SUMMARY              ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Passed: $passed${NC}"
    echo -e "${RED}Failed: $failed${NC}"
    echo -e "Logs saved to: $LOG_DIR"
    
    if [ $failed -eq 0 ]; then
        echo -e "\n${GREEN}All integration tests passed! 🎉${NC}"
        return 0
    else
        echo -e "\n${RED}Some integration tests failed.${NC}"
        return 1
    fi
}

# Main execution
case "${1:-all}" in
    all)
        run_integration_tests
        ;;
    workflow)
        check_prerequisites && setup_integration_env && test_full_workflow
        ;;
    auto-approval)
        check_prerequisites && setup_integration_env && test_auto_approval
        ;;
    queue)
        check_prerequisites && setup_integration_env && test_queue_adapter
        ;;
    worker)
        check_prerequisites && setup_integration_env && test_hybrid_worker
        ;;
    recovery)
        check_prerequisites && setup_integration_env && test_error_recovery
        ;;
    performance)
        check_prerequisites && setup_integration_env && test_performance_load
        ;;
    *)
        echo "Usage: $0 [all|workflow|auto-approval|queue|worker|recovery|performance]"
        echo ""
        echo "Environment variables:"
        echo "  TEST_ISSUES  - GitHub issue numbers for workflow test (e.g., '123,124')"
        echo "  TEST_REPO    - Path to test repository (default: /tmp/test-claude-parallel-integration)"
        exit 1
        ;;
esac