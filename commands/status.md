# Task-Based Development Status Dashboard

Get a comprehensive view of your parallel task development progress.

Usage: /project:status [what]

Arguments: $ARGUMENTS

## Screenshot Support
📸 **Claude Code Tip**: Take a screenshot of your terminal showing the status output and paste it directly into Claude Code. I can analyze the visual output to:
- Identify stuck or idle sessions
- Spot patterns in blocked tasks
- Suggest optimizations based on visual cues
- Debug issues with parallel execution

**How to use**: Simply paste a screenshot after running this command for visual analysis.

## Dashboard Sections

### Overview
- Active sessions and their task assignments
- Task queue status by issue
- Manual tasks blocking automation
- Recent task completions
- Issue progress (checklist completion)

### Detailed Views
I'll parse arguments for specific views:
- `sessions` - Detailed session information
- `tasks` - Task queue and dependencies
- `issues` - Issue-level progress
- `manual` - Manual work focus
- `activity` - Recent activity log
- Default: Full dashboard

## Example Dashboard
```
=== Task-Based Parallel Development Status ===
Time: 2024-01-15 14:23:45
Uptime: 2 hours 15 minutes

=== Active Sessions (4/5) ===
Session    | Status  | Task  | Branch               | Duration
-----------|---------|-------|----------------------|----------
claude-1   | working | #10-1 | task/#10-1-theme    | 45 min
claude-2   | working | #10-3 | task/#10-3-toggle   | 23 min
claude-3   | working | #11-2 | task/#11-2-tests    | 12 min
claude-4   | idle    | -     | -                    | -
claude-5   | working | #12-4 | task/#12-4-docs     | 5 min

=== Issue Progress ===
Issue #10: Dark Mode Support
  Progress: [████████░░░░] 67% (4/6 tasks)
  ✓ Design dark color palette
  ✓ Get design approval
  ⚡ Create theme context provider (in progress)
  ⚡ Add theme toggle component (in progress)
  ◯ Update color tokens for dark theme (blocked)
  ◯ Update all components for theme (blocked)

Issue #11: Authentication System  
  Progress: [████░░░░░░░░] 33% (2/6 tasks)
  ✓ Choose auth strategy
  ⚡ Write auth unit tests (in progress)
  ◯ Create auth database schema
  ◯ Implement JWT generation
  ◯ Add login/logout endpoints
  ◯ Create auth middleware

=== Task Queue ===
Ready: 8 tasks across 3 issues
Blocked: 5 tasks (3 by manual work, 2 by dependencies)
Total remaining: 13 tasks

Next ready tasks:
1. #12-1 - Update API documentation
2. #12-2 - Create troubleshooting guide  
3. #11-3 - Create auth database schema

=== Manual Tasks Blocking Work ===
🚨 HIGH PRIORITY - Unblocking automated tasks:
#10-5: 👤 Design dark color palette
      Blocks: #10-2, #10-4 (2 tasks)
      Status: Not started
      
#11-1: 👤 Choose authentication strategy
      Blocks: #11-3, #11-4, #11-5 (3 tasks)
      Status: In progress

=== Recent Completions (last hour) ===
✓ #10-6 - Get design approval (manual)
✓ #11-1 - Choose auth strategy (manual)
✓ #12-3 - Add video tutorial scripts (PR #412)

=== Resource Usage ===
Worktrees: 4 active (task-based)
Sessions: 5 running
CPU: Normal
Memory: 2.3 GB

=== Statistics ===
Today's progress:
- Tasks completed: 18
- Tasks in progress: 4  
- Tasks blocked: 5
- Issues touched: 3
- PRs created: 12
- PRs merged: 8

Velocity: 2.4 tasks/hour
Estimated completion: ~5 hours remaining
```

## Key Indicators
- ⚡ Task in progress
- ✓ Task completed
- ◯ Task pending
- 👤 Manual task

## Quick Actions
Based on status, I might suggest:
- Complete manual tasks to unblock work
- Focus on nearly-complete issues
- Review task dependencies
- Clean up completed worktrees

## Auto-Refresh
This command can be run repeatedly to monitor progress:
```bash
watch -n 60 'claude /project:status'
```

## Visual Debugging with Screenshots
When troubleshooting parallel execution issues:
1. Run `/project:status` to see current state
2. Take a screenshot of the output
3. Paste it into Claude Code with your question
4. I can visually analyze:
   - Session states and durations
   - Queue backlogs
   - Blocking patterns
   - Resource usage trends

📚 **Reference**: [Working with Images in Claude Code](https://docs.anthropic.com/en/docs/claude-code/tutorials#working-with-images)