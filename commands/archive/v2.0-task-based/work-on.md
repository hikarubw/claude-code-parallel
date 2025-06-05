# Work on Specific Task

Start work on a specific task from the queue in an available session.

Usage: /project:work-on TASK_ID

Arguments: $ARGUMENTS

## What I'll Do

1. **Validate Task**
   - Check if task exists in queue
   - Verify it's not blocked
   - Ensure it's not already assigned

2. **Find or Create Session**
   - Look for idle session
   - Or create new session if needed
   - Assign task to session

3. **Create Task Branch**
   - Branch name: `task/#47-1-description`
   - Set up isolated worktree
   - Apply autonomous settings

4. **Start Work**
   - Navigate to worktree
   - Begin implementation
   - Track progress

## Example Usage

```
/project:work-on #47-1

Starting work on task #47-1...
✓ Task found: "Create database schema"
✓ Found idle session: claude-2
✓ Creating branch: task/47-1-database-schema
✓ Worktree: .worktrees/task-47-1

Work started in session claude-2!
Use /project:status to monitor progress.
```

## Task Selection

You can specify tasks in various formats:
- `#47-1` - Full task ID
- `47-1` - Without hash
- `1-5` - Just numbers

## Integration

This command:
- Updates task status to "in-progress"
- Creates appropriate branch name
- Sets up PR to update checklist
- Enables focused single-task work

## Error Handling

If task is blocked:
```
Task #47-3 is blocked by #47-2
Complete #47-2 first or use /project:manual to unblock
```

If no sessions available:
```
No idle sessions available
Creating new session claude-4...
```

## Tips
- Use `/project:status` to see available tasks
- Complete blocking tasks first
- Each task should be <4 hours of work
- PRs will auto-update issue checklists