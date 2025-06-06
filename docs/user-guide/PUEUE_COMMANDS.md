# Pueue Commands Reference

This guide covers essential Pueue commands for managing Claude Code Parallel's task queue.

## Table of Contents

1. [Basic Commands](#basic-commands)
2. [Task Management](#task-management)
3. [Queue Control](#queue-control)
4. [Group Management](#group-management)
5. [Monitoring & Logs](#monitoring--logs)
6. [Advanced Usage](#advanced-usage)
7. [Integration with Claude Parallel](#integration-with-claude-parallel)

## Basic Commands

### Starting Pueue

```bash
# Start the daemon
pueued -d

# Start with custom config
pueued -d --config ~/.config/pueue/pueue.yml

# Check if daemon is running
pueue status
```

### Core Operations

```bash
# View queue status
pueue status

# Add a task
pueue add "echo 'Hello World'"

# Start/pause/kill operations
pueue start         # Start all paused tasks
pueue pause         # Pause all running tasks  
pueue kill          # Kill all running tasks

# Clean up finished tasks
pueue clean
```

## Task Management

### Adding Tasks

```bash
# Basic task
pueue add "npm test"

# Task with label
pueue add --label "test-suite" "npm test"

# Task with priority (higher = more important)
pueue add --priority 10 "critical task"

# Task in specific group
pueue add --group workers "process subissue"

# Task that runs after another
pueue add --after 5 "cleanup task"

# Get task ID immediately
TASK_ID=$(pueue add --print-task-id "my task")
```

### Controlling Tasks

```bash
# Start specific task
pueue start 5

# Pause specific task
pueue pause 5

# Kill specific task
pueue kill 5

# Restart failed task
pueue restart 5

# Edit queued task
pueue edit 5  # Opens in $EDITOR

# Remove task from queue
pueue remove 5
```

### Task Dependencies

```bash
# Run after specific task completes
pueue add --after 3 "dependent task"

# Run after multiple tasks
pueue add --after 3,4,5 "final task"

# Delayed start
pueue add --delay "10min" "delayed task"
pueue add --delay "2024-12-25 10:00:00" "scheduled task"
```

## Queue Control

### Parallelism Control

```bash
# Set max parallel tasks (global)
pueue parallel 8

# Set for specific group
pueue parallel 4 --group workers

# View current settings
pueue status
```

### Priority Management

```bash
# Change task priority
pueue switch 5 10  # Swap positions of tasks 5 and 10

# Send task to end of queue
pueue send 5

# Stash/unstash tasks
pueue stash 5      # Temporarily remove from queue
pueue enqueue 5    # Re-add stashed task
```

## Group Management

Groups allow organizing tasks by type or project.

```bash
# Create group
pueue group add workers

# View groups
pueue group

# Set group parallelism
pueue parallel 4 --group workers

# Start/pause/kill by group
pueue start --group workers
pueue pause --group workers
pueue kill --group workers

# Remove group (must be empty)
pueue group remove workers
```

## Monitoring & Logs

### Live Monitoring

```bash
# Follow all task output
pueue follow

# Follow specific task
pueue follow 5

# Follow group
pueue follow --group workers
```

### Viewing Logs

```bash
# View recent logs
pueue log

# View specific task log
pueue log 5

# View last N lines
pueue log 5 --lines 50

# View full log
pueue log 5 --full

# JSON output for parsing
pueue log 5 --json
```

### Status Information

```bash
# Basic status
pueue status

# JSON format for scripts
pueue status --json

# Filter by group
pueue status --group workers
```

## Advanced Usage

### Daemon Management

```bash
# Graceful shutdown
pueue shutdown

# Reset everything (nuclear option)
pueue reset

# Pause daemon on task failure
# Edit ~/.config/pueue/pueue.yml:
# daemon:
#   pause_group_on_failure: true
```

### Configuration

Default config location: `~/.config/pueue/pueue.yml`

```yaml
# Example configuration
shared:
  pueue_directory: ~/.local/share/pueue
  default_parallel_tasks: 8

daemon:
  pause_group_on_failure: true
  callback: "notify-send 'Task {{id}} {{status}}'"

client:
  dark_mode: true
  status_time_format: "%H:%M:%S"
```

### Environment Variables

```bash
# Run task with specific environment
pueue add --env "NODE_ENV=test" "npm test"

# Multiple variables
pueue add --env "FOO=bar" --env "BAZ=qux" "my-script"
```

### Working Directory

```bash
# Run in specific directory
pueue add --working-directory /path/to/project "npm build"

# Or shorter
pueue add -w /path/to/project "make"
```

## Integration with Claude Parallel

### How Claude Parallel Uses Pueue

1. **Task Creation**: Each subissue becomes a Pueue task
2. **Group Management**: Uses 'workers' group for isolation
3. **Labels**: Tasks labeled with worker ID and issue number
4. **Priority**: Based on issue complexity and dependencies

### Common Patterns

```bash
# View Claude Parallel tasks
pueue status --group workers

# Monitor specific worker
pueue follow --group workers | grep "worker-3"

# Restart failed Claude task
pueue restart $(pueue status --json | jq -r '.tasks | map(select(.label | contains("worker-3"))) | .[0].id')

# Scale workers for performance
pueue parallel 16 --group workers  # Heavy workload
pueue parallel 4 --group workers   # Light workload

# Emergency stop
pueue kill --group workers
pueue clean --group workers
```

### Debugging Claude Workers

```bash
# Find stuck worker
pueue status --group workers --json | jq '.tasks[] | select(.status == "Running") | {id, label, start}'

# Check worker output
pueue log <task-id> --full

# Attach to tmux session (if still running)
tmux attach -t worker-3

# Force retry with more logging
pueue restart <task-id>
```

## Tips & Best Practices

### Performance Optimization

```bash
# Clean old tasks regularly
pueue clean --successful-only

# Limit log retention
pueue clean --before "3 days ago"

# Monitor resource usage
watch -n 2 'pueue status --group workers | head -20'
```

### Scripting with Pueue

```bash
#!/bin/bash
# Example: Process files in parallel

for file in *.txt; do
    pueue add --label "process-$file" "process_script '$file'"
done

# Wait for completion
while [ $(pueue status --json | jq '.tasks | map(select(.status != "Done")) | length') -gt 0 ]; do
    sleep 5
done

echo "All processing complete!"
```

### Recovery Procedures

```bash
# After system crash
pueued -d                    # Restart daemon
pueue status                 # Check state
pueue restart --all-failed   # Retry failures

# Clean corrupted state
pueue shutdown
rm -rf ~/.local/share/pueue/*
pueued -d
```

## Quick Reference Card

| Command | Description |
|---------|-------------|
| `pueue status` | View queue state |
| `pueue add "cmd"` | Add task to queue |
| `pueue start` | Start paused tasks |
| `pueue pause` | Pause running tasks |
| `pueue kill` | Kill running tasks |
| `pueue clean` | Remove finished tasks |
| `pueue log <id>` | View task output |
| `pueue follow` | Watch live output |
| `pueue restart <id>` | Retry failed task |
| `pueue parallel N` | Set worker count |
| `pueue shutdown` | Stop daemon |

Remember: Pueue is the backbone of Claude Code Parallel's reliability. Master these commands to effectively manage your parallel development workflow!