# Start Task-Based Parallel Development

Begin intelligent parallel development with automatic task orchestration.

Usage: /project:work [N] [options]

Arguments: $ARGUMENTS

## What I'll Do

1. **Start Parallel Sessions**
   - Create N tmux sessions (default: 3)
   - Each session gets a dedicated worktree
   - Sessions named claude-1, claude-2, etc.

2. **Intelligent Task Assignment**
   - Get next unblocked task from queue
   - Tasks identified as `#issue-task` (e.g., #47-3)
   - Check task dependencies are satisfied
   - Verify task type (claude-work vs manual-work)
   - Create isolated worktree for the task
   - Assign to available session

3. **Automatic Orchestration**
   - Monitor session progress
   - Detect completion (PR created, tests pass)
   - Update issue checklist on PR merge
   - Clean completed worktrees
   - Assign new tasks automatically

4. **Task-Based Workflow**
   - Each task gets its own branch/PR
   - PRs reference the checklist item
   - Issues stay open until all tasks complete
   - Better granularity than issue-based approach

5. **Error Detection & Recovery**
   - Monitor for stuck or failing sessions
   - Automatically retry with different approaches
   - Escalate persistent failures for manual help
   - Use extended thinking for complex debugging

## Options Parsing
I'll parse your arguments for:
- Number of sessions (first number)
- `--focus=ISSUE` (work on specific issue's tasks)
- `--watch` (continuous monitoring)
- `--prefer-small` (prioritize quick tasks)

## Task Selection Strategy
- Prioritize unblocked tasks
- Consider dependencies across issues
- Skip manual-work tasks (marked with 👤)
- Balance work across different issues

## Example Usage
```
# Start 5 sessions
/project:work 5

# Focus on issue #10's tasks
/project:work 3 --focus=10

# Prefer small tasks first
/project:work --prefer-small
```

## Live Example
```
Starting task-based parallel development...
✓ Created 5 sessions with worktrees

Session assignments:
claude-1: Working on #10-1 (Create theme context provider)
         Branch: task/#10-1-theme-context
         Worktree: .worktrees/task-10-1
claude-2: Working on #10-3 (Add theme toggle component)  
         Branch: task/#10-3-theme-toggle
         Worktree: .worktrees/task-10-3
claude-3: Working on #11-2 (Write auth unit tests)
         Branch: task/#11-2-auth-tests
         Worktree: .worktrees/task-11-2
claude-4: Idle (waiting for #10-5 - manual task)
claude-5: Working on #12-1 (Update API documentation)
         Branch: task/#12-1-api-docs
         Worktree: .worktrees/task-12-1

Status: 4/5 sessions active
Queue: 23 tasks (14 ready, 9 blocked)
Issues: 3 active (#10, #11, #12)

Monitoring enabled - will assign new tasks automatically.
```

## PR Creation
Each task PR will:
- Title: "Task #10-1: Create theme context provider"
- Body: References checklist item in issue #10
- Labels: Inherit from parent issue
- Auto-updates checklist on merge

## Error Recovery & Continuation
Claude Code's continuation features are perfect for parallel work:
- **Session interruption**: Use `claude --continue` to resume the last session
- **Specific session recovery**: Use `claude --resume` to pick a session to continue
- **Stuck sessions**: I can detect and recover stuck sessions automatically
- **Failed tasks**: I'll retry with different approaches or escalate for manual help

### Common Recovery Scenarios
1. **Claude Code crashes during work**:
   ```bash
   claude --continue  # Resumes exactly where you left off
   ```

2. **Need to switch between parallel sessions**:
   ```bash
   claude --resume   # Shows list of sessions to choose from
   ```

3. **Session stuck on failing tests**:
   - I'll detect repeated failures
   - Try alternative solutions
   - Flag for manual intervention if needed

📚 **Reference**: [Resuming Conversations](https://docs.anthropic.com/en/docs/claude-code/tutorials#resuming-previous-conversations)

## Tips
- Use `/project:status` to see task progress
- Use `/project:manual` to complete manual tasks
- Tasks complete faster than full issues
- Better parallelism with smaller work units
- Leverage `--continue` for seamless work resumption
