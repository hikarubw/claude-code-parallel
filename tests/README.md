# Test Suite for Claude Code Parallel

This directory contains comprehensive test suites for the hybrid Pueue+Tmux architecture.

## Test Files

### `test-suite.sh`
Core functionality tests for Pueue integration:
- **Happy Path**: Process 10 subissues successfully
- **Worker Crash**: Handling of crashed workers
- **Daemon Restart**: Recovery after Pueue daemon restart
- **Stress Test**: 100+ task queue performance
- **Priority Handling**: Mixed priority task execution
- **Retry Logic**: Failed task retry mechanisms
- **Network Recovery**: Handling network interruptions
- **Worker Scaling**: Testing 1-16 concurrent workers

### `hybrid-integration-tests.sh`
End-to-end integration tests:
- **Full Workflow**: Issue analysis to PR creation
- **Auto-Approval**: Integration with approval daemon
- **Queue Adapter**: Pueue adapter functionality
- **Hybrid Worker**: Worker spawning and management
- **Error Recovery**: System-wide error handling
- **Performance Load**: System behavior under load

## Running Tests

### Run All Tests
```bash
# Complete test suite
./test-suite.sh

# Integration tests (requires GitHub issues)
TEST_ISSUES="123,124" ./hybrid-integration-tests.sh
```

### Run Individual Tests
```bash
# Specific test scenario
./test-suite.sh worker-crash
./test-suite.sh stress

# Specific integration test
./hybrid-integration-tests.sh auto-approval
./hybrid-integration-tests.sh performance
```

## Test Requirements

- Pueue daemon running (`pueued -d`)
- GitHub CLI authenticated (`gh auth status`)
- Tmux installed
- Claude Code Parallel installed
- Write access to `/tmp` for test files

## Test Output

- Logs saved to: `/tmp/test-claude-parallel/test-logs/`
- Each test run creates timestamped log files
- Color-coded output: ✅ Pass, ❌ Fail, ⚠️ Warning

## Continuous Testing

For development, run tests in watch mode:
```bash
# Monitor test results
watch -n 10 './test-suite.sh happy-path'

# Stress test monitoring
./test-suite.sh stress & pueue follow
```

## Adding New Tests

1. Add test function to appropriate file
2. Follow naming convention: `test_feature_name()`
3. Use color codes for output
4. Clean up test resources
5. Add to test array in `run_all_tests()`

## Debugging Failed Tests

```bash
# View test logs
tail -f /tmp/test-claude-parallel/test-logs/*.log

# Check Pueue state
pueue status --json | jq

# Inspect specific task
pueue log <task-id>
```