# Stop All Workers

Gracefully stop all worker sessions.

Usage: /project:stop [OPTIONS]

Arguments: $ARGUMENTS

## What I'll Do

1. **Signal Workers**
   - Send stop signal to all active workers
   - Allow current tasks to complete
   - Save queue state for resume

2. **Wait for Completion**
   - Monitor workers finishing current tasks
   - Timeout after 5 minutes
   - Force stop if needed

3. **Clean Up**
   - Save final state to ~/.claude/workers/state.json
   - Archive logs with timestamp
   - Report final statistics

## Options
- `--force` - Stop immediately without waiting
- `--timeout=SECONDS` - Custom timeout (default: 300)

## Resume Later
After stopping, resume with:
```bash
/project:resume
```

This will restore the queue and restart workers where they left off.