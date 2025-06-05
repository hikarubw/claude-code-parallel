# Show Development Status

Display current worker pool and queue status.

Usage: /project:status [OPTIONS]

Arguments: $ARGUMENTS

## What I'll Show

### Worker Pool Status
```
👷 Worker Pool Status
===================
worker-1: working on #201 (15m)
worker-2: working on #202 (8m)
worker-3: idle
worker-4: working on #204 (2m)

Summary: 4 workers (3 working, 1 idle)
```

### Queue Status
```
📊 Queue Status
==============
Pending:   5
Working:   3
Completed: 12
Failed:    1

Priority Breakdown:
1 (Critical): 1 pending
2 (High):     2 pending
3 (Normal):   2 pending
```

### Parent Issue Progress
```
📋 Parent Issues
===============
#123: ████████░░ 80% (4/5 subissues)
#124: ███░░░░░░░ 33% (1/3 subissues)
#125: ██████████ 100% (4/4 subissues) ✅
```

### Performance Metrics
```
📈 Throughput
============
Last hour:  6 PRs
Today:      18 PRs
Avg time:   22 minutes/subissue
Success:    94%
```

## Options

- `--watch` - Live updates every 5 seconds
- `--workers` - Show only worker status
- `--queue` - Show only queue status
- `--issues` - Show only parent issue progress
- `--verbose` - Include worker logs tail

## Examples

```bash
# Basic status
/project:status

# Watch live progress
/project:status --watch

# Check specific aspect
/project:status --workers
/project:status --queue
```

## Related Commands

- `/project:work` - Start workers
- `/project:add` - Add more work
- `/project:stop` - Stop workers