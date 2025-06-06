# Troubleshooting Guide - Claude Code Parallel

This guide helps you diagnose and fix common issues with Claude Code Parallel's hybrid Pueue+Tmux architecture.

## Table of Contents

1. [Installation Issues](#installation-issues)
2. [Pueue Daemon Issues](#pueue-daemon-issues)
3. [Worker Issues](#worker-issues)
4. [Queue Management Issues](#queue-management-issues)
5. [GitHub Integration Issues](#github-integration-issues)
6. [Performance Issues](#performance-issues)
7. [Auto-Approval Issues](#auto-approval-issues)
8. [Recovery Procedures](#recovery-procedures)

## Installation Issues

### Problem: Installation script fails

**Symptoms:**
- `./install.sh` exits with error
- Missing dependencies message

**Solution:**
```bash
# Check system requirements
uname -a  # Should be macOS or Linux

# Install missing dependencies manually
# macOS:
brew install tmux pueue gh

# Linux:
sudo apt-get install tmux gh
# Install pueue from releases: https://github.com/Nukesor/pueue/releases

# Verify Claude Code is installed
claude-code --version
```

### Problem: Pueue not found after installation

**Symptoms:**
- `pueue: command not found`
- Installation completed but pueue unavailable

**Solution:**
```bash
# Check if pueue is in PATH
which pueue

# If not found, add to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Or reinstall with cargo
cargo install pueue
```

## Pueue Daemon Issues

### Problem: Pueue daemon not running

**Symptoms:**
- `pueue status` shows connection error
- "Couldn't connect to daemon" message

**Solution:**
```bash
# Start the daemon
pueued -d

# Check if running
ps aux | grep pueued

# Check daemon logs
tail -f ~/.local/share/pueue/pueue.log

# If daemon crashes repeatedly, reset state
pueue reset
pueued -d
```

### Problem: Pueue daemon using too much CPU/memory

**Symptoms:**
- High CPU usage by pueued process
- System slowdown

**Solution:**
```bash
# Check current resource usage
pueue status --json | jq '.daemon'

# Limit parallel tasks
pueue parallel 4  # Reduce to 4 concurrent tasks

# Clean completed tasks
pueue clean

# Restart daemon with lower resource limits
pueue shutdown
pueued -d
```

## Worker Issues

### Problem: Workers not starting

**Symptoms:**
- Tasks queued but not executing
- No tmux sessions created

**Solution:**
```bash
# Check Pueue group status
pueue status --group workers

# Ensure group exists and is not paused
pueue group add workers  # Create if missing
pueue start --group workers  # Unpause group

# Check for stalled tasks
pueue log  # View recent task logs

# Manually start a stalled task
pueue restart <task-id>
```

### Problem: Worker crashes immediately

**Symptoms:**
- Tmux session appears and disappears
- Tasks marked as failed in Pueue

**Solution:**
```bash
# Check task logs
pueue log <task-id>

# Common causes:
# 1. Missing worktree directory
mkdir -p ~/.claude-code-parallel/worktrees

# 2. GitHub authentication issue
gh auth status
gh auth login  # If needed

# 3. Repository access issue
cd /path/to/repo
git status  # Verify repo is accessible

# Test worker manually
./tools/hybrid-worker 1 /path/to/subissue.json
```

### Problem: Worker session hanging

**Symptoms:**
- Tmux session exists but not progressing
- Task stuck in "Running" state

**Solution:**
```bash
# Attach to session to see what's happening
tmux attach -t worker-1

# Common issues:
# - Waiting for user input (auto-approve should handle this)
# - Git credential prompt
# - Network timeout

# Kill hanging session
tmux kill-session -t worker-1

# Pueue will detect failure and retry
pueue status <task-id>
```

## Queue Management Issues

### Problem: Tasks stuck in queue

**Symptoms:**
- Tasks remain in "Queued" state
- Workers available but tasks not starting

**Solution:**
```bash
# Check queue state
pueue status

# Start all queued tasks
pueue start

# Check if group is paused
pueue status --group workers
pueue start --group workers

# Force immediate execution
pueue switch <task-id-1> <task-id-2>  # Swap priority
```

### Problem: Priority not respected

**Symptoms:**
- Lower priority tasks running before higher priority
- Important tasks waiting

**Solution:**
```bash
# View task priorities
pueue status --json | jq '.tasks[] | {id, priority, status}'

# Adjust task priority
pueue edit <task-id>  # Opens editor to modify task

# Ensure using priority when adding
./tools/queue-pueue add "task" 10  # Priority 10 (high)

# Force high-priority task to start next
pueue switch <high-priority-id> <running-task-id>
```

## GitHub Integration Issues

### Problem: PR creation fails

**Symptoms:**
- Worker completes but no PR created
- "gh: command not found" in logs

**Solution:**
```bash
# Verify GitHub CLI authentication
gh auth status

# Re-authenticate if needed
gh auth login

# Check repository permissions
gh api user | jq '.login'
gh repo view <owner>/<repo>

# Test PR creation manually
gh pr create --title "Test" --body "Test PR" --base main --head test-branch
```

### Problem: Subissues not created

**Symptoms:**
- Analysis completes but no subissues in GitHub
- Parent issue not updated

**Solution:**
```bash
# Check GitHub API rate limit
gh api rate_limit | jq '.rate'

# Verify issue access
gh issue view <issue-number>

# Check analyzer logs
tail -f ~/.claude-code-parallel/logs/analyzer.log

# Test analyzer manually
./tools/analyze <issue-number>
```

## Performance Issues

### Problem: System running slowly

**Symptoms:**
- High CPU/memory usage
- Slow response times
- System lag

**Solution:**
```bash
# Reduce concurrent workers
pueue parallel 2 --group workers  # Limit to 2

# Check system resources
top  # or htop

# Clean up old tasks
pueue clean
pueue reset  # Nuclear option - clears everything

# Limit Pueue daemon resources
# Edit ~/.config/pueue/pueue.yml
# daemon:
#   default_parallel_tasks: 4
#   pause_group_on_failure: true
```

### Problem: Tasks taking too long

**Symptoms:**
- Simple tasks taking hours
- Workers seem stuck

**Solution:**
```bash
# Check what workers are doing
tmux list-sessions
tmux attach -t worker-1  # See live output

# Common bottlenecks:
# 1. Slow test suites - consider skipping in dev
# 2. Large repositories - use shallow clones
# 3. Network issues - check connectivity

# Set task timeouts (future feature)
# For now, manually kill long-running tasks
pueue kill <task-id>
```

## Auto-Approval Issues

### Problem: Auto-approval not working

**Symptoms:**
- Sessions waiting for approval
- "Approve? [y/N]" prompts hanging

**Solution:**
```bash
# Check if auto-approve is running
ps aux | grep auto-approve

# Start auto-approve daemon
./tools/auto-approve &

# Test auto-approval
tmux new-session -d -s test "read -p 'Approve? [y/N] ' response; echo Response: \$response"
sleep 3
tmux capture-pane -t test -p  # Should show "Response: y"

# Check auto-approve logs
tail -f ~/.claude-code-parallel/logs/auto-approve.log
```

## Recovery Procedures

### Complete System Reset

When nothing else works:

```bash
# 1. Stop everything
pueue shutdown
tmux kill-server
pkill -f auto-approve

# 2. Clean up state
rm -rf ~/.claude-code-parallel/queue
rm -rf ~/.claude-code-parallel/worktrees/*
pueue reset

# 3. Restart services
pueued -d
./tools/auto-approve &

# 4. Verify system health
./tools/setup-hybrid  # Re-run setup
pueue status
tmux list-sessions
```

### Recover from Crash

After system crash or unexpected shutdown:

```bash
# 1. Restart Pueue daemon (it preserves state)
pueued -d

# 2. Check task status
pueue status

# 3. Resume paused tasks
pueue start

# 4. Restart failed tasks
pueue restart --all-failed

# 5. Clean up orphaned tmux sessions
tmux list-sessions | grep worker | cut -d: -f1 | xargs -r tmux kill-session -t
```

### Debug Mode

For detailed troubleshooting:

```bash
# Enable debug logging
export CLAUDE_PARALLEL_DEBUG=1

# Run with verbose output
pueue follow <task-id>  # Live task output

# Monitor all logs
tail -f ~/.local/share/pueue/pueue.log
tail -f ~/.claude-code-parallel/logs/*.log

# Trace worker execution
strace -f -e trace=process ./tools/hybrid-worker 1 test.json
```

## Getting Help

If you're still experiencing issues:

1. **Check the logs:**
   - Pueue logs: `~/.local/share/pueue/pueue.log`
   - Task logs: `pueue log <task-id>`
   - Application logs: `~/.claude-code-parallel/logs/`

2. **Run diagnostic tests:**
   ```bash
   ./tests/test-suite.sh
   ./tests/hybrid-integration-tests.sh
   ```

3. **Report an issue:**
   - Include output of `pueue status --json`
   - Include relevant log snippets
   - Describe what you were trying to do
   - List your system details (OS, versions)

4. **Check documentation:**
   - [Architecture Guide](../developer-guide/current-architecture/ARCHITECTURE.md)
   - [Quick Start Guide](QUICK_START.md)
   - [FAQ](FAQ.md)

Remember: The hybrid architecture is designed to be resilient. Most issues can be resolved by restarting the affected component.