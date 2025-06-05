# 🚀 `/project:work` - Subissue-Based Parallel Development

## Overview

The `/project:work` command implements an intelligent parallel development system that:
1. Analyzes GitHub issues to create logical subissues
2. Manages a priority queue of work items
3. Orchestrates multiple Claude workers to process subissues
4. Creates pull requests automatically
5. Tracks progress in real-time

## Basic Usage

```bash
# Work on a single issue with 4 workers (default)
/project:work 123

# Work on a single issue with 8 workers
/project:work 123 8

# Work on multiple issues with 10 workers
/project:work 123,124,125 10

# Work with specific priority
/project:work 123 4 --priority=high
```

## Command Syntax

```
/project:work ISSUES [WORKERS] [OPTIONS]

Arguments:
  ISSUES    - Issue number(s) to work on (comma-separated)
  WORKERS   - Number of parallel workers (default: 4)

Options:
  --priority=LEVEL     - Set priority (critical|high|normal|low)
  --auto-merge         - Enable auto-merge for approved PRs
  --extended-thinking  - Use extended thinking for complex issues
  --dry-run           - Preview what would be done without starting
```

## Complete Workflow Example

```bash
# 1. Start work on issues #123 and #124 with 8 workers
$ /project:work 123,124 8

🤖 Analyzing issues...
✓ Issue #123: Found 4 logical subissues
✓ Issue #124: Found 3 logical subissues

📋 Creating subissues...
✓ Created #201: [#123] Implement user model
✓ Created #202: [#123] Add authentication endpoints
✓ Created #203: [#123] Create login UI
✓ Created #204: [#123] Add test coverage
✓ Created #205: [#124] Design API schema
✓ Created #206: [#124] Implement REST endpoints
✓ Created #207: [#124] Add OpenAPI documentation

📥 Adding to queue...
✓ 7 subissues added to work queue

🚀 Starting 8 workers...
✓ worker-1: Processing #201
✓ worker-2: Processing #202
✓ worker-3: Processing #203
✓ worker-4: Processing #204
✓ worker-5: Processing #205
✓ worker-6: Processing #206
✓ worker-7: Processing #207
✓ worker-8: Idle (waiting for work)

📊 Progress: 0/7 complete
```

## Monitoring Progress

### Real-time Status
```bash
# Show current status
/project:status

👷 Worker Pool Status
===================
worker-1: working on #201
worker-2: working on #202
worker-3: completed #203
worker-4: working on #204
worker-5: idle
worker-6: working on #206
worker-7: completed #207
worker-8: idle

📊 Queue Status
==============
Pending:   0
Working:   4
Completed: 3
Failed:    0

📋 Parent Issues
===============
#123: 75% complete (3/4 subissues)
#124: 33% complete (1/3 subissues)
```

### Live Dashboard
```bash
# Watch progress in real-time
/project:status --watch

┌─────────────────────────────────────────────────┐
│          WORKER POOL DASHBOARD                   │
├─────────────────────────────────────────────────┤
│ Time: 2024-12-05 14:30:45 | Uptime: 2h 15m     │
├─────────────────────────────────────────────────┤
│ WORKERS (8/8 active)                            │
│ ├─ worker-1: PR #208 created                    │
│ ├─ worker-2: Working on #202 (45m)             │
│ ├─ worker-3: PR #209 in review                 │
│ └─ ...                                         │
├─────────────────────────────────────────────────┤
│ THROUGHPUT                                      │
│ Last hour: 4 PRs | Today: 15 PRs | Avg: 22m   │
└─────────────────────────────────────────────────┘
```

## Worker Management

### Add More Workers
```bash
# Add 4 more workers to speed up
/project:workers add 4

➕ Adding 4 workers...
✅ Started worker-9
✅ Started worker-10
✅ Started worker-11
✅ Started worker-12
```

### Remove Workers
```bash
# Remove 2 workers
/project:workers remove 2

🛑 Stopping 2 workers...
✅ Stopped worker-12
✅ Stopped worker-11
```

### Worker Logs
```bash
# View specific worker logs
/project:logs worker-3

📋 Worker-3 Activity Log
========================
[14:25:32] Processing subissue #203
[14:25:45] Created worktree at ~/worktrees/subissue-203
[14:26:01] Running Claude session
[14:45:23] Committed changes
[14:46:12] Created PR #209
[14:46:45] Completed subissue #203
```

## Queue Management

### View Queue
```bash
# Show current queue
/project:queue show

Priority | Parent | Subissue | Status  | Worker
---------|--------|----------|---------|--------
1        | #125   | #211     | pending | none
2        | #123   | #202     | working | worker-2
2        | #124   | #206     | working | worker-6
3        | #126   | #212     | pending | none
```

### Prioritize Work
```bash
# Change priority of a subissue
/project:queue priority 212 high

✅ Updated subissue #212 to priority 1
```

### Retry Failed Items
```bash
# Retry all failed subissues
/project:queue retry all

🔄 Retrying all failed items...
↩️ Moved #210 back to queue
↩️ Moved #213 back to queue
✅ 2 failed items returned to queue
```

## Advanced Features

### Extended Thinking Mode
```bash
# Use for complex architectural issues
/project:work 150 4 --extended-thinking

🧠 Extended thinking enabled for complex analysis
```

### Auto-merge Setup
```bash
# Enable auto-merge for small PRs
/project:work 123 8 --auto-merge

🔄 Auto-merge enabled for approved PRs under 100 lines
```

### Dry Run
```bash
# Preview without starting
/project:work 123,124 8 --dry-run

🔍 DRY RUN MODE
Would analyze: #123, #124
Estimated subissues: 7-10
Estimated time: 3-4 hours with 8 workers
No workers will be started
```

## Stopping and Resuming

### Graceful Stop
```bash
# Stop all workers after current tasks
/project:stop

🛑 Initiating graceful shutdown...
⏸️ Workers will stop after completing current tasks
💾 State saved for resume
```

### Resume Work
```bash
# Resume from where you left off
/project:resume

🔄 Resuming work...
✓ Restored 5 pending items to queue
✓ Started 8 workers (previous configuration)
✓ Continuing from subissue #206
```

## Integration with CI/CD

The system automatically:
1. Creates PRs with proper formatting
2. Links subissues to parent issues
3. Updates parent issue progress
4. Triggers CI/CD pipelines
5. Closes parent issues when all subissues complete

## Best Practices

### 1. Issue Preparation
```markdown
# Good Issue Structure
Title: Add user authentication system

## Requirements
- JWT-based authentication
- Role-based access control
- Password reset functionality
- Session management

## Technical Notes
- Use existing Express middleware
- PostgreSQL for user storage
- Follow REST API conventions
```

### 2. Optimal Worker Count
- **Small issues (2-4 subissues)**: 2-4 workers
- **Medium issues (5-8 subissues)**: 4-8 workers
- **Large issues (9+ subissues)**: 8-12 workers
- **Multiple issues**: 1.5x subissue count

### 3. Priority Guidelines
- **Critical**: Security fixes, breaking bugs
- **High**: Core features, important fixes
- **Normal**: Enhancements, refactoring
- **Low**: Documentation, nice-to-haves

## Troubleshooting

### Workers Not Picking Up Tasks
```bash
# Check worker health
/project:workers health

# Restart stuck workers
/project:workers restart
```

### Queue Issues
```bash
# Rebuild queue from GitHub
/project:queue rebuild

# Clear old completed items
/project:queue clean 7
```

### PR Creation Failures
```bash
# Check worker logs
/project:logs worker-3 50

# Manually complete subissue
/project:queue update 203 completed
```

## Complete Example Session

```bash
# Start development on feature request
$ /project:work 150 6

# Add urgent bug fix with high priority
$ /project:add 151 --priority=critical

# Monitor progress
$ /project:status --watch

# Add more workers for faster completion
$ /project:workers add 4

# Check specific parent issue
$ /project:status issue 150

# Stop for lunch
$ /project:pause

# Resume after lunch
$ /project:resume

# Gracefully stop when done
$ /project:stop
```

## Tips and Tricks

1. **Batch Similar Issues**: Group related issues for better context
2. **Use Extended Thinking**: For architectural decisions
3. **Monitor PR Quality**: Review first few PRs to ensure quality
4. **Adjust Worker Count**: Based on queue size and complexity
5. **Regular Cleanup**: Run `/project:queue clean` weekly

## Related Commands

- `/project:status` - Monitor progress
- `/project:add` - Add more issues to queue  
- `/project:pause` - Pause all workers
- `/project:resume` - Resume paused work
- `/project:stop` - Stop all workers
- `/project:workers` - Manage worker pool
- `/project:queue` - Manage work queue