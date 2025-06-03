# Development Status Dashboard

Get a comprehensive view of your parallel development progress.

Usage: /project:status [what]

Arguments: $ARGUMENTS

## Dashboard Sections

### Overview
- Active sessions and their assignments
- Work queue status
- Manual tasks blocking automation
- Recent completions
- Resource usage

### Detailed Views
I'll parse arguments for specific views:
- `sessions` - Detailed session information
- `tasks` - Task queue and blocking
- `manual` - Manual work focus
- `activity` - Recent activity log
- Default: Full dashboard

## Example Dashboard
```
=== Parallel Development Status ===
Time: 2024-01-15 14:23:45
Uptime: 2 hours 15 minutes

=== Active Sessions (4/5) ===
Session    | Status  | Issue | Worktree         | Duration
-----------|---------|-------|------------------|----------
claude-1   | working | #123  | .worktrees/123   | 45 min
claude-2   | working | #456  | .worktrees/456   | 23 min
claude-3   | working | #789  | .worktrees/789   | 12 min
claude-4   | idle    | -     | -                | -
claude-5   | working | #234  | .worktrees/234   | 5 min

=== Work Queue ===
Ready: 8 tasks
Blocked: 3 tasks (waiting on manual work)
Total remaining: 11 tasks

Next in queue:
1. #345 - bug: Fix navigation (priority: 8)
2. #567 - feat: Add search (priority: 6)
3. #890 - chore: Update CI (priority: 4)

=== Manual Tasks Blocking Work ===
🚨 HIGH PRIORITY - Unblocking automated tasks:
#101: 👤 Setup OAuth credentials
      Blocks: #102, #103, #104 (3 tasks)
      Status: Not started
      
#205: 👤 Deploy to staging
      Blocks: #206 (1 task)
      Status: In progress (started 30 min ago)

=== Recent Completions (last hour) ===
✓ #111 - bug: Fix login error (PR #412 merged)
✓ #222 - feat: Add dark mode (PR #413 created)
✓ #333 - docs: Update README (PR #414 merged)

=== Resource Usage ===
Worktrees: 12 active (1.8 GB)
Sessions: 5 running
CPU: Normal
Memory: 2.3 GB

=== Statistics ===
Today's progress:
- Completed: 18 tasks
- In progress: 4 tasks  
- Blocked: 3 tasks
- Approval rate: 94%

Velocity: 2.4 tasks/hour
Estimated completion: ~5 hours remaining
```

## Quick Actions
Based on status, I might suggest:
- Start manual tasks to unblock work
- Clean up completed worktrees
- Adjust parallelism level
- Review blocked tasks

## Auto-Refresh
This command can be run repeatedly to monitor progress.
Consider using `watch` in terminal:
```bash
watch -n 60 'claude /project:status'
```