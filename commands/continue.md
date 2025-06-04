# Continue Interrupted Work

Resume work on tasks using Claude Code's continuation features.

Usage: /project:continue [session-id|task-id]

Arguments: $ARGUMENTS

## What I'll Do

1. **List Resumable Work**
   - Show interrupted sessions
   - Display last task worked on
   - Show time since last activity

2. **Resume Options**
   - Continue last session (no args)
   - Resume specific session
   - Resume work on specific task

3. **Use Claude's Continue Feature**
   - Leverage `claude --continue`
   - Restore full context
   - Pick up exactly where left off

## Example Usage

### Continue Last Session
```
/project:continue

Found last session: claude-3
Task: #47-3 (Implement login endpoint)
Last activity: 15 minutes ago
Branch: task/47-3-login-endpoint

Resuming with: claude --continue
```

### Resume Specific Session
```
/project:continue claude-2

Session: claude-2
Task: #48-2 (Add code examples)
Worktree: .worktrees/task-48-2
Status: PR in progress

Resuming session...
```

### Resume Specific Task
```
/project:continue #49-1

Task #49-1 was being worked on in claude-4
Last activity: 2 hours ago
Would you like to:
1. Resume in claude-4
2. Start fresh in new session
3. View work done so far
```

## Session Discovery

I'll check for:
- Active tmux sessions
- Work directories with changes
- Incomplete PRs
- Tasks marked "in-progress"

## Resume vs Restart

**Resume** (preserves context):
- Unfinished implementation
- Debugging sessions
- Complex refactoring
- Multi-file changes

**Restart** (fresh context):
- Simple tasks
- After major changes
- Different approach needed
- Stalled work

## Common Scenarios

### After Claude Code Crash
```
Claude Code exited unexpectedly
Run: /project:continue
I'll find your last session and resume
```

### After Break/Interruption  
```
Took a break from task #50-3?
Run: /project:continue #50-3
Picks up with full context
```

### Multiple Sessions
```
/project:continue

Active sessions found:
1. claude-1: #47-3 (45 min ago)
2. claude-2: #48-2 (2 hours ago)
3. claude-3: #49-1 (yesterday)

Which would you like to resume?
```

## Integration with Task System

- Updates task status when resumed
- Maintains session tracking
- Preserves branch and worktree
- Continues PR creation

## Tips

- Use after any interruption
- Great for complex debugging
- Preserves Claude's memory
- No need to re-explain context

📚 **Reference**: [Claude Code Resume Feature](https://docs.anthropic.com/en/docs/claude-code/tutorials#resuming-previous-conversations)