# Maintain Development Environment

Keep your development environment clean and efficient with intelligent maintenance.

Usage: /project:maintain [what] [options]

Arguments: $ARGUMENTS

## What to Clean

### worktrees
Remove worktrees for:
- Merged pull requests
- Closed issues  
- Stale branches (customizable age)
- Always preserves uncommitted changes

### sessions
Clean up:
- Idle tmux sessions
- Sessions with no active Claude
- Orphaned sessions

### all (default)
Clean everything:
- All worktrees meeting criteria
- All idle sessions
- Old log files
- Stale tracking data

### status
Show cleanup preview:
- Number of worktrees
- Active sessions
- Disk usage
- What would be cleaned

## Options
- `--force` - Skip confirmation
- `--dry-run` - Preview only
- `--keep-days N` - Keep items newer than N days

## Example
```
/project:maintain status

=== Maintenance Status ===
Worktrees: 12 total (1.2GB)
  Can clean: 5 (merged/closed)
  
Sessions: 5 active
  Idle: 2
  
Old data:
  Log files (>7 days): 23

/project:maintain worktrees
Cleaning worktrees...
  bug-123 - PR merged
  feat-456 - Issue closed
Cleaned 2 worktrees

/project:maintain all
Cleaning worktrees... ✓
Cleaning idle sessions... ✓  
Cleaning old data... ✓
Maintenance complete!
```

## Regular Maintenance
Run periodically to keep environment clean:
- After merging PRs
- End of each day
- Before starting new work batch

## Tools Used
- `maintain clean` - Remove stale resources
- `maintain status` - Preview what needs cleaning
- `maintain report` - Detailed usage statistics
- `session clean` - Worktree maintenance