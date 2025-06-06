# Hybrid Architecture Implementation Guide

## Revolutionary Discovery: Pueue + Tmux = Best of Both Worlds

### Overview

The hybrid architecture solves the fundamental conflict between professional queue management and Claude visibility. By using Pueue as a queue manager while executing Claude in tmux panes, we achieve:

- ✅ **Professional queue features**: Persistence, dependencies, scheduling
- ✅ **Claude visibility**: See what Claude is doing in real-time
- ✅ **Auto-approval works**: Existing mechanism continues perfectly
- ✅ **Crash recovery**: Pueue persists queue state
- ✅ **Advanced features**: Priority, groups, delays, limits

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    Pueue Daemon (Queue Manager)              │
│  - Manages queue state                                       │
│  - Handles dependencies                                      │
│  - Schedules tasks                                          │
│  - Does NOT execute Claude directly                          │
└────────────────────────┬────────────────────────────────────┘
                         │ Workers poll for tasks
┌────────────────────────┴────────────────────────────────────┐
│                  Tmux Session: claude-workers                │
├─────────┬─────────┬─────────┬─────────┬────────────────────┤
│ Pane 0  │ Pane 1  │ Pane 2  │ Pane 3  │    Pane N         │
│ Monitor │Worker 1 │Worker 2 │Worker 3 │   Worker N         │
│Dashboard│ Claude  │ Claude  │ Claude  │   Claude           │
│ Status  │ Visible │ Visible │ Visible │   Visible          │
└─────────┴─────────┴─────────┴─────────┴────────────────────┘
                         │ Auto-approval monitors panes
┌─────────────────────────┴───────────────────────────────────┐
│                     Auto-Approval Daemon                     │
│  - Monitors tmux panes via capture-pane                     │
│  - Automatically approves Claude prompts                     │
│  - Works exactly as before!                                  │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

### 1. Setup Hybrid Architecture

```bash
# Install and setup (one command!)
./tools/setup-hybrid 6

# Or with demo data
./tools/setup-hybrid demo
```

### 2. View Workers

```bash
# Attach to see all workers in grid
tmux attach -t claude-workers
```

### 3. Add Work

```bash
# Add subissues to hybrid queue
./tools/queue-pueue add 1 "123" "301"  # Priority 1, parent #123, subissue 301
./tools/queue-pueue add 2 "123" "302"
./tools/queue-pueue add 3 "124" "303"
```

## How It Works

### 1. Hybrid Worker Loop

Each worker runs in a tmux pane and:
1. **Polls Pueue** for next task
2. **Starts task** in Pueue (marks as running)
3. **Executes Claude** IN THE TMUX PANE (visible!)
4. **Updates status** in both queues
5. **Cleans up** and repeats

### 2. Queue Synchronization

The `queue-pueue` adapter maintains sync:
- **File queue** → **Pueue**: For compatibility
- **Pueue** → **File queue**: For status updates
- **Bidirectional**: Best of both systems

### 3. Auto-Approval Magic

The existing auto-approval continues to work because:
- Claude still runs in tmux panes
- `tmux capture-pane` still works
- No changes needed to auto-approval!

## Advanced Features Now Available

### 1. Dependencies

```bash
# Subissue 302 depends on 301 completing
job_301=$(pueue status --json | jq -r '.tasks | select(.label == "subissue-301") | .id')
pueue add --after $job_301 --label "subissue-302" "process_subissue 302"
```

### 2. Priority Scheduling

```bash
# High priority bug fix
pueue add --priority 10 --label "subissue-bug-305" --group subissues "process"

# Low priority cleanup
pueue add --priority 1 --label "subissue-cleanup-306" --group subissues "process"
```

### 3. Delayed Execution

```bash
# Schedule for later
pueue add --delay "2h" --label "subissue-307" --group subissues "process"

# Schedule for specific time
pueue add --delay "16:00" --label "subissue-308" --group subissues "process"
```

### 4. Worker Groups

```bash
# Create specialized groups
pueue group add frontend
pueue parallel 3 --group frontend

pueue group add backend
pueue parallel 5 --group backend

# Add tasks to groups
pueue add --group frontend --label "subissue-ui-309" "process"
pueue add --group backend --label "subissue-api-310" "process"
```

### 5. Pause/Resume

```bash
# Pause all processing
pueue pause --group subissues

# Resume specific task
pueue start 42

# Resume all
pueue start --group subissues
```

## Monitoring

### Live Dashboard
```bash
# Unified monitoring
./tools/queue-pueue monitor
```

### Pueue Status
```bash
# Detailed task status
pueue status --group subissues

# Follow task output (even though we see it in tmux)
pueue follow 42

# View task history
pueue log 42
```

### Tmux Commands
```bash
# List all panes
tmux list-panes -t claude-workers

# Focus specific worker
tmux select-pane -t claude-workers:0.3

# Zoom a pane
tmux resize-pane -Z -t claude-workers:0.2
```

## Implementation Details

### Key Components

1. **tools/hybrid-worker**
   - Runs in each tmux pane
   - Polls Pueue for tasks
   - Executes Claude visibly
   - Updates both queues

2. **tools/queue-pueue**
   - Adapter between file queue and Pueue
   - Bidirectional synchronization
   - Monitoring interface

3. **tools/setup-hybrid**
   - One-command setup
   - Dependency checking
   - Worker session creation

### Migration Path

1. **Phase 1**: Install Pueue (automated)
2. **Phase 2**: Run setup-hybrid (creates session)
3. **Phase 3**: Existing queue migrates automatically
4. **Phase 4**: Workers start processing immediately

### Compatibility

- ✅ Existing `/project:work` commands continue to work
- ✅ File-based queue maintained for compatibility
- ✅ All current tools remain functional
- ✅ Auto-approval needs no changes

## Benefits Over Pure Approaches

| Feature | Pure Pueue | Pure Tmux | Hybrid |
|---------|------------|-----------|---------|
| Queue Persistence | ✅ | ❌ | ✅ |
| Claude Visibility | ❌ | ✅ | ✅ |
| Auto-Approval | ❌ | ✅ | ✅ |
| Dependencies | ✅ | ❌ | ✅ |
| Scheduling | ✅ | ❌ | ✅ |
| Crash Recovery | ✅ | ❌ | ✅ |
| Single View | ❌ | ✅ | ✅ |

## Troubleshooting

### Pueue daemon not running
```bash
pueued -d  # Start daemon
```

### Workers not picking up tasks
```bash
# Check Pueue group
pueue status --group subissues

# Check worker logs
tmux capture-pane -t claude-workers:0.1 -p
```

### Queue out of sync
```bash
# Force sync
./tools/queue-pueue sync
```

## Future Enhancements

1. **Distributed Workers**: Run workers on multiple machines
2. **Smart Scheduling**: ML-based priority assignment
3. **Resource Limits**: CPU/memory constraints per task
4. **Webhook Integration**: Trigger on GitHub events
5. **Web Dashboard**: Browser-based monitoring

## Conclusion

The hybrid architecture represents a breakthrough in Claude Code Parallel design. By combining Pueue's robust queue management with tmux's visibility, we achieve professional-grade task processing without sacrificing the ability to observe and interact with Claude.

This is not a compromise - it's a synergy that delivers capabilities beyond what either approach could provide alone.