# Task Status Dashboard

View all tasks across issues with progress, dependencies, and assignments.

Usage: /project:task-status [filter]

Arguments: $ARGUMENTS

## Dashboard Views

### Default View
Shows all tasks grouped by issue with:
- Task completion status
- Current assignments
- Blocking relationships
- Progress indicators

### Filters
- `ready` - Only unblocked tasks
- `blocked` - Tasks waiting on others
- `active` - Currently being worked on
- `manual` - Manual tasks only
- `ISSUE_NUM` - Tasks for specific issue

## Example Output

```
=== Task Status Across All Issues ===
Updated: 2024-01-15 14:30:00

Issue #47: Authentication System
Progress: [████████░░░░░░] 50% (2/4 tasks)
  ✓ #47-1: Create database schema (completed)
  ✓ #47-2: 👤 Get security review (completed)
  ⚡ #47-3: Implement login endpoint (claude-1, 25 min)
  ◯ #47-4: Add session management (blocked by #47-3)

Issue #48: Documentation Update  
Progress: [██░░░░░░░░░░░░] 25% (1/4 tasks)
  ✓ #48-1: Update API docs (completed)
  ⚡ #48-2: Add code examples (claude-2, 10 min)
  ◯ #48-3: Create video tutorials (ready)
  ◯ #48-4: 👤 Review and publish (blocked by #48-3)

Issue #49: Performance Optimization
Progress: [░░░░░░░░░░░░░░] 0% (0/3 tasks)
  ◯ #49-1: Profile slow endpoints (ready)
  ◯ #49-2: Optimize database queries (blocked by #49-1)
  ◯ #49-3: Add caching layer (blocked by #49-2)

=== Summary ===
Total Tasks: 11 (3 completed, 2 active, 3 ready, 3 blocked)
Manual Tasks: 2 (1 completed, 1 pending)
Active Sessions: 2/5 working
Overall Progress: 27% (3/11 tasks)

=== Ready to Start ===
1. #48-3: Create video tutorials
2. #49-1: Profile slow endpoints

Run /project:work-on TASK_ID to start!
```

## Status Indicators

- ✓ Completed task
- ⚡ Active (being worked on)
- ◯ Pending (not started)
- 🚫 Blocked by dependency
- 👤 Manual task marker

## Dependency Visualization

For complex dependencies:
```
#50-1 → #50-2 → #50-3
         ↓
       #50-4 → #50-5
```

## Session Assignment

Shows which session is working on which task:
- `(claude-1, 45 min)` - Session and duration
- `(starting...)` - Just assigned
- `(stalled)` - No activity for 30+ min

## Quick Actions

Based on the status, I'll suggest:
- Start ready tasks
- Complete manual blockers
- Check stalled sessions
- Review completed work

## Integration

This view helps you:
- See the big picture across issues
- Identify bottlenecks
- Find next tasks to work on
- Track overall progress

## Auto-Refresh

For continuous monitoring:
```bash
watch -n 30 'claude /project:task-status'
```