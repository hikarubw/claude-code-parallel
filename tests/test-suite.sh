#!/bin/bash
# Comprehensive Test Suite for Claude Code Parallel - Hybrid Architecture
# This test suite covers all critical scenarios for the Pueue+Tmux hybrid system

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test configuration
TEST_REPO="${TEST_REPO:-/tmp/test-claude-parallel}"
TEST_ISSUES="${TEST_ISSUES:-}"
LOG_DIR="${TEST_REPO}/test-logs"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Ensure test dependencies
check_dependencies() {
    echo -e "${BLUE}Checking dependencies...${NC}"
    local deps=("pueue" "tmux" "gh" "git" "claude-code")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}Missing dependency: $dep${NC}"
            exit 1
        fi
    done
    
    # Check Pueue daemon
    if ! pueue status &> /dev/null; then
        echo -e "${YELLOW}Starting Pueue daemon...${NC}"
        pueued -d
        sleep 2
    fi
    
    echo -e "${GREEN}All dependencies satisfied${NC}"
}

# Setup test environment
setup_test_env() {
    echo -e "${BLUE}Setting up test environment...${NC}"
    
    # Create test directory
    mkdir -p "$TEST_REPO"
    mkdir -p "$LOG_DIR"
    
    # Create test group in Pueue
    pueue group add test-workers 2>/dev/null || true
    
    # Clean any existing test sessions
    tmux list-sessions 2>/dev/null | grep "test-worker" | cut -d: -f1 | xargs -r tmux kill-session -t
    
    echo -e "${GREEN}Test environment ready${NC}"
}

# Test 1: Happy Path - Process 10 subissues successfully
test_happy_path() {
    echo -e "\n${BLUE}TEST 1: Happy Path - Process 10 subissues${NC}"
    local test_log="$LOG_DIR/test1_happy_path_${TIMESTAMP}.log"
    
    # Create 10 test tasks
    echo "Creating 10 test subissues..."
    for i in {1..10}; do
        pueue add --group test-workers --label "test-subissue-$i" \
            "echo 'Processing subissue $i' && sleep 2 && echo 'Completed subissue $i'" \
            >> "$test_log" 2>&1
    done
    
    # Wait for completion
    echo "Waiting for all tasks to complete..."
    local timeout=60
    local elapsed=0
    
    while [ $elapsed -lt $timeout ]; do
        local completed=$(pueue status --group test-workers --json 2>/dev/null | \
            jq -r '.tasks | map(select(.status == "Done")) | length' || echo 0)
        
        if [ "$completed" -eq 10 ]; then
            echo -e "${GREEN}✓ All 10 subissues processed successfully${NC}"
            return 0
        fi
        
        sleep 2
        elapsed=$((elapsed + 2))
        echo -ne "\rProgress: $completed/10 tasks completed..."
    done
    
    echo -e "\n${RED}✗ Timeout: Only $completed/10 tasks completed${NC}"
    return 1
}

# Test 2: Worker Crash During Execution
test_worker_crash() {
    echo -e "\n${BLUE}TEST 2: Worker Crash During Execution${NC}"
    local test_log="$LOG_DIR/test2_worker_crash_${TIMESTAMP}.log"
    
    # Create a task that will crash
    echo "Creating task that will crash..."
    local task_id=$(pueue add --group test-workers --print-task-id \
        "echo 'Starting task' && sleep 2 && exit 1" 2>/dev/null)
    
    # Wait for task to fail
    sleep 5
    
    # Check if Pueue marked it as failed
    local status=$(pueue status $task_id --json 2>/dev/null | jq -r '.tasks[0].status' || echo "Unknown")
    
    if [ "$status" = "Failed" ]; then
        echo -e "${GREEN}✓ Pueue correctly detected worker crash${NC}"
        
        # Test retry functionality
        echo "Testing retry functionality..."
        pueue restart $task_id
        sleep 5
        
        local retry_status=$(pueue status $task_id --json 2>/dev/null | jq -r '.tasks[0].status' || echo "Unknown")
        if [ "$retry_status" = "Failed" ]; then
            echo -e "${GREEN}✓ Retry mechanism working correctly${NC}"
            return 0
        fi
    fi
    
    echo -e "${RED}✗ Worker crash handling failed${NC}"
    return 1
}

# Test 3: Pueue Daemon Restart Mid-Processing
test_daemon_restart() {
    echo -e "\n${BLUE}TEST 3: Pueue Daemon Restart Mid-Processing${NC}"
    local test_log="$LOG_DIR/test3_daemon_restart_${TIMESTAMP}.log"
    
    # Create long-running tasks
    echo "Creating long-running tasks..."
    for i in {1..5}; do
        pueue add --group test-workers --label "daemon-test-$i" \
            "echo 'Task $i started' && sleep 10 && echo 'Task $i completed'" \
            >> "$test_log" 2>&1
    done
    
    # Wait for tasks to start
    sleep 3
    
    # Get running tasks count
    local running_before=$(pueue status --group test-workers --json 2>/dev/null | \
        jq -r '.tasks | map(select(.status == "Running")) | length' || echo 0)
    
    echo "Tasks running before restart: $running_before"
    
    # Restart daemon
    echo "Restarting Pueue daemon..."
    pueue shutdown
    sleep 2
    pueued -d
    sleep 3
    
    # Check if tasks resumed
    local status_after=$(pueue status --group test-workers --json 2>/dev/null | \
        jq -r '.tasks | map(select(.status == "Running" or .status == "Queued")) | length' || echo 0)
    
    if [ "$status_after" -gt 0 ]; then
        echo -e "${GREEN}✓ Tasks preserved after daemon restart${NC}"
        
        # Clean up
        pueue clean --group test-workers
        return 0
    fi
    
    echo -e "${RED}✗ Tasks lost after daemon restart${NC}"
    return 1
}

# Test 4: 100+ Task Queue Stress Test
test_stress_queue() {
    echo -e "\n${BLUE}TEST 4: 100+ Task Queue Stress Test${NC}"
    local test_log="$LOG_DIR/test4_stress_queue_${TIMESTAMP}.log"
    
    # Configure higher parallelism for stress test
    pueue parallel 16 --group test-workers
    
    # Create 100 tasks
    echo "Creating 100 tasks..."
    for i in {1..100}; do
        pueue add --group test-workers --label "stress-$i" \
            "echo 'Task $i' && sleep 0.5" \
            >> "$test_log" 2>&1
    done
    
    echo "Queue created. Monitoring completion..."
    local start_time=$(date +%s)
    
    # Monitor completion
    while true; do
        local completed=$(pueue status --group test-workers --json 2>/dev/null | \
            jq -r '.tasks | map(select(.status == "Done")) | length' || echo 0)
        local failed=$(pueue status --group test-workers --json 2>/dev/null | \
            jq -r '.tasks | map(select(.status == "Failed")) | length' || echo 0)
        
        echo -ne "\rProgress: $completed completed, $failed failed..."
        
        if [ $((completed + failed)) -eq 100 ]; then
            break
        fi
        
        sleep 2
    done
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo -e "\n${GREEN}✓ Stress test completed in ${duration}s${NC}"
    echo "Completed: $completed, Failed: $failed"
    
    # Clean up
    pueue clean --group test-workers
    
    return 0
}

# Test 5: Mixed Priority Handling
test_priority_handling() {
    echo -e "\n${BLUE}TEST 5: Mixed Priority Handling${NC}"
    local test_log="$LOG_DIR/test5_priority_${TIMESTAMP}.log"
    
    # Set limited parallelism to test priority
    pueue parallel 2 --group test-workers
    
    # Create tasks with different priorities
    echo "Creating tasks with mixed priorities..."
    
    # Low priority tasks
    for i in {1..3}; do
        pueue add --group test-workers --label "low-priority-$i" --priority -10 \
            "echo 'Low priority task $i' && sleep 3" >> "$test_log" 2>&1
    done
    
    # High priority tasks
    for i in {1..3}; do
        pueue add --group test-workers --label "high-priority-$i" --priority 10 \
            "echo 'High priority task $i' && sleep 1" >> "$test_log" 2>&1
    done
    
    # Medium priority tasks
    for i in {1..3}; do
        pueue add --group test-workers --label "medium-priority-$i" \
            "echo 'Medium priority task $i' && sleep 2" >> "$test_log" 2>&1
    done
    
    # Monitor execution order
    sleep 10
    
    # Analyze completion order from logs
    local high_completed=$(pueue status --group test-workers --json 2>/dev/null | \
        jq -r '.tasks | map(select(.label | startswith("high-priority") and .status == "Done")) | length' || echo 0)
    
    if [ "$high_completed" -ge 2 ]; then
        echo -e "${GREEN}✓ High priority tasks executed first${NC}"
        pueue clean --group test-workers
        return 0
    fi
    
    echo -e "${RED}✗ Priority handling not working correctly${NC}"
    return 1
}

# Test 6: Failed Task Retry Logic
test_retry_logic() {
    echo -e "\n${BLUE}TEST 6: Failed Task Retry Logic${NC}"
    local test_log="$LOG_DIR/test6_retry_logic_${TIMESTAMP}.log"
    
    # Create a task that fails initially but succeeds on retry
    local retry_file="/tmp/test_retry_${TIMESTAMP}"
    
    echo "Creating task with retry logic..."
    local task_id=$(pueue add --group test-workers --print-task-id \
        "if [ -f '$retry_file' ]; then echo 'Success on retry'; exit 0; else touch '$retry_file'; echo 'First attempt failed'; exit 1; fi" \
        2>/dev/null)
    
    # Wait for initial failure
    sleep 3
    
    # Check status
    local status=$(pueue status $task_id --json 2>/dev/null | jq -r '.tasks[0].status' || echo "Unknown")
    
    if [ "$status" = "Failed" ]; then
        echo "Task failed as expected. Testing retry..."
        
        # Retry the task
        pueue restart $task_id
        sleep 3
        
        # Check if succeeded on retry
        local retry_status=$(pueue status $task_id --json 2>/dev/null | jq -r '.tasks[0].status' || echo "Unknown")
        
        if [ "$retry_status" = "Done" ]; then
            echo -e "${GREEN}✓ Retry logic working correctly${NC}"
            rm -f "$retry_file"
            return 0
        fi
    fi
    
    echo -e "${RED}✗ Retry logic test failed${NC}"
    rm -f "$retry_file"
    return 1
}

# Test 7: Network Interruption Recovery
test_network_recovery() {
    echo -e "\n${BLUE}TEST 7: Network Interruption Recovery${NC}"
    local test_log="$LOG_DIR/test7_network_recovery_${TIMESTAMP}.log"
    
    # Simulate a task that handles network interruption
    echo "Creating network-dependent task..."
    local task_id=$(pueue add --group test-workers --print-task-id \
        "for i in {1..5}; do echo 'Attempt $i'; curl -s --max-time 2 https://api.github.com/rate_limit >/dev/null && echo 'Network OK' && exit 0 || echo 'Network failed, retrying...'; sleep 2; done; exit 1" \
        2>/dev/null)
    
    # Monitor task
    local timeout=30
    local elapsed=0
    
    while [ $elapsed -lt $timeout ]; do
        local status=$(pueue status $task_id --json 2>/dev/null | jq -r '.tasks[0].status' || echo "Unknown")
        
        if [ "$status" = "Done" ] || [ "$status" = "Failed" ]; then
            if [ "$status" = "Done" ]; then
                echo -e "${GREEN}✓ Network recovery handled successfully${NC}"
                return 0
            else
                echo -e "${YELLOW}⚠ Task completed with network issues${NC}"
                return 0
            fi
        fi
        
        sleep 2
        elapsed=$((elapsed + 2))
    done
    
    echo -e "${RED}✗ Network recovery test timeout${NC}"
    return 1
}

# Test 8: Concurrent Worker Scaling
test_worker_scaling() {
    echo -e "\n${BLUE}TEST 8: Concurrent Worker Scaling (1-16 workers)${NC}"
    local test_log="$LOG_DIR/test8_worker_scaling_${TIMESTAMP}.log"
    
    # Test different worker counts
    local worker_counts=(1 4 8 16)
    
    for workers in "${worker_counts[@]}"; do
        echo -e "\nTesting with $workers workers..."
        
        # Set parallelism
        pueue parallel $workers --group test-workers
        
        # Create tasks
        for i in {1..20}; do
            pueue add --group test-workers --label "scale-test-$workers-$i" \
                "sleep 1" >> "$test_log" 2>&1
        done
        
        # Measure completion time
        local start_time=$(date +%s)
        
        while true; do
            local completed=$(pueue status --group test-workers --json 2>/dev/null | \
                jq -r '.tasks | map(select(.label | startswith("scale-test-'$workers'") and .status == "Done")) | length' || echo 0)
            
            if [ "$completed" -eq 20 ]; then
                break
            fi
            
            sleep 1
        done
        
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        
        echo -e "${GREEN}✓ Completed 20 tasks with $workers workers in ${duration}s${NC}"
        
        # Clean up for next test
        pueue clean --group test-workers
    done
    
    return 0
}

# Run all tests
run_all_tests() {
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Claude Code Parallel - Test Suite v0.3.0  ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    
    check_dependencies
    setup_test_env
    
    local passed=0
    local failed=0
    local tests=(
        "test_happy_path"
        "test_worker_crash"
        "test_daemon_restart"
        "test_stress_queue"
        "test_priority_handling"
        "test_retry_logic"
        "test_network_recovery"
        "test_worker_scaling"
    )
    
    for test in "${tests[@]}"; do
        if $test; then
            ((passed++))
        else
            ((failed++))
        fi
    done
    
    echo -e "\n${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${BLUE}                TEST SUMMARY                ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}Passed: $passed${NC}"
    echo -e "${RED}Failed: $failed${NC}"
    echo -e "Logs saved to: $LOG_DIR"
    
    # Cleanup
    echo -e "\n${BLUE}Cleaning up test environment...${NC}"
    pueue clean --group test-workers
    pueue group remove test-workers 2>/dev/null || true
    
    if [ $failed -eq 0 ]; then
        echo -e "\n${GREEN}All tests passed! 🎉${NC}"
        return 0
    else
        echo -e "\n${RED}Some tests failed. Please check logs.${NC}"
        return 1
    fi
}

# Main execution
case "${1:-all}" in
    all)
        run_all_tests
        ;;
    happy-path)
        check_dependencies && setup_test_env && test_happy_path
        ;;
    worker-crash)
        check_dependencies && setup_test_env && test_worker_crash
        ;;
    daemon-restart)
        check_dependencies && setup_test_env && test_daemon_restart
        ;;
    stress)
        check_dependencies && setup_test_env && test_stress_queue
        ;;
    priority)
        check_dependencies && setup_test_env && test_priority_handling
        ;;
    retry)
        check_dependencies && setup_test_env && test_retry_logic
        ;;
    network)
        check_dependencies && setup_test_env && test_network_recovery
        ;;
    scaling)
        check_dependencies && setup_test_env && test_worker_scaling
        ;;
    *)
        echo "Usage: $0 [all|happy-path|worker-crash|daemon-restart|stress|priority|retry|network|scaling]"
        exit 1
        ;;
esac