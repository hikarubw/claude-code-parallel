# Resume Previous Work

Resume work from where you left off.

Usage: /project:resume [WORKERS]

Arguments: $ARGUMENTS

## What I'll Do

1. **Restore State**
   - Load saved state from ~/.claude/workers/state.json
   - Restore queue with pending items
   - Identify last worker count

2. **Restart Workers**
   - Start workers (use saved count or specify new)
   - Workers automatically pick up from queue
   - Continue processing where stopped

3. **Show Status**
   - Display restored queue items
   - Show worker assignments
   - Report time since last run

## Examples
```bash
# Resume with previous worker count
/project:resume

# Resume with different worker count
/project:resume 8
```

## Related
- `/project:stop` - Stop work gracefully
- `/project:status` - Check current progress