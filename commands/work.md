# Start Parallel Development

Begin intelligent parallel development with automatic orchestration.

Usage: /project:work [N] [options]

Arguments: $ARGUMENTS

## What I'll Do

1. **Start Parallel Sessions**
   - Create N tmux sessions (default: 3)
   - Each session gets a dedicated worktree
   - Sessions named claude-1, claude-2, etc.

2. **Intelligent Task Assignment**
   - Get next unblocked task with `task next`
   - Check dependencies are satisfied
   - Verify risk level for auto-approval
   - Create isolated worktree
   - Assign to available session

3. **Automatic Orchestration**
   - Monitor session progress
   - Detect completion signals (PR created, tests pass, idle time)
   - Clean completed worktrees
   - Assign new work automatically

4. **Risk-Based Auto-Approval**
   - Evaluate each task's risk
   - Auto-approve within tolerance
   - Flag high-risk for manual review

## Options Parsing
I'll parse your arguments for:
- Number of sessions (first number)
- `--safe` / `--normal` / `--aggressive` (approval level)
- `--watch` (continuous monitoring)
- `--focus=PATTERN` (work on specific issues)

## Approval Levels
- **--safe** (default): Only UI, docs, simple bugs
- **--normal**: Most features, refactoring
- **--aggressive**: Everything except security/data

## Example Usage
```
# Start 5 sessions with safe approval
/project:work 5

# Aggressive mode with monitoring  
/project:work 3 --aggressive --watch

# Focus on bugs only
/project:work --focus=bug:*
```

## Live Example
```
Starting parallel development...
✓ Created 5 sessions with worktrees

Session assignments:
claude-1: Working on #123 (bug: fix button color)
         Worktree: .worktrees/123
claude-2: Working on #456 (feat: add pagination)  
         Worktree: .worktrees/456
claude-3: Working on #789 (chore: update deps)
         Worktree: .worktrees/789
claude-4: Idle (waiting for #234 - blocked by manual task)
claude-5: Working on #567 (docs: API examples)
         Worktree: .worktrees/567

Status: 4/5 sessions active
Queue: 12 remaining (3 blocked)

Monitoring enabled - will assign new work automatically.
```

## Monitoring
With `--watch`, I'll:
- Check for completed work every 5 minutes
- Assign new tasks to free sessions
- Handle new issues automatically
- Clean up completed worktrees

## Tips
- Use `/project:status` to see current state
- Use `/project:manual` to unblock work
- Sessions persist across Claude restarts
- Each issue gets a clean git environment