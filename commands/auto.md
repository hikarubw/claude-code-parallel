# Autonomous Development Mode

Run Claude Code Tools in fully autonomous mode with intelligent scheduling.

Usage: /project:auto <start|stop|config>

Arguments: $ARGUMENTS

## Commands

### start [options]
Begin autonomous operation with smart defaults:
- Continuous issue monitoring
- Automatic work assignment
- Intelligent break management
- Progress notifications

Options I'll parse:
- `--interval=MINUTES` (check interval, default: 5)
- `--sessions=N` (parallel sessions, default: 3)
- `--hours=HH-HH` (working hours, e.g., 09-18)
- `--approval=LEVEL` (safe/normal/aggressive)
- `--notify=METHOD` (how to notify progress)

### stop
Gracefully shutdown autonomous mode:
- Complete current tasks
- Clean up resources
- Save progress state

### config
Show or update configuration:
- View current settings
- Adjust parameters
- Set schedules

## Example Usage

### Start with defaults
```
/project:auto start

Starting autonomous mode...
✓ Monitor interval: 5 minutes
✓ Sessions: 3 parallel
✓ Approval: safe
✓ Hours: 24/7

Autonomous mode active.
I'll handle everything from here!
```

### Start with working hours
```
/project:auto start --hours=09-18 --sessions=5

Starting autonomous mode...
✓ Working hours: 09:00-18:00
✓ Sessions: 5 parallel
✓ Will pause outside hours

Scheduled for business hours operation.
```

### What Happens in Auto Mode

Every interval, I will:

1. **Check for new work**
   - Fetch new GitHub issues
   - Analyze complexity
   - Add to queue

2. **Manage sessions**
   - Detect completed work
   - Clean up worktrees
   - Assign new tasks
   - Maintain optimal parallelism

3. **Handle blockers**
   - Identify blocking manual tasks
   - Notify when manual work needed
   - Resume when unblocked

4. **Provide updates**
   - Progress summaries
   - Completion notifications
   - Issue alerts

## Intelligent Features

### Adaptive Scheduling
- Reduces parallelism if error rate increases
- Pauses during high manual task backlog
- Resumes when path clears

### Smart Notifications
- Batch updates to avoid spam
- Priority alerts for blockers
- End-of-day summaries

### Resource Management
- Automatic cleanup of old worktrees
- Session health monitoring
- Disk space awareness

## Example Autonomous Session
```
[09:00] Autonomous mode started
[09:05] Found 3 new issues, added to queue
[09:05] Assigned: #123 → claude-1, #456 → claude-2
[09:45] Completed: #123 (PR created)
[09:45] Assigned: #789 → claude-1
[10:15] ALERT: Manual task #234 blocking 5 automated tasks
[11:30] Manual task #234 completed
[11:35] Resumed: Assigned blocked tasks to sessions
[12:00] Progress: 8 completed, 3 in progress, 12 remaining
[15:30] Completed: #789, #456 (PRs merged)
[17:00] End of day: 15 tasks completed, 5 remaining
[18:00] Pausing for scheduled hours
```

## Configuration Example
```
/project:auto config

Current configuration:
- Mode: Active
- Interval: 5 minutes  
- Sessions: 3
- Hours: 09:00-18:00
- Approval: safe
- Notify: dashboard only

Uptime: 3 hours 25 minutes
Tasks completed: 12
Current status: Working (2 active)
```

## Best Practices
- Start with safe approval level
- Set working hours to avoid surprises
- Monitor first few cycles
- Adjust based on your workflow
- Use `/project:status` to check anytime