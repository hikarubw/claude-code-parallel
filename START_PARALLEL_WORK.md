# Start Parallel Work Instructions

The parallel sessions are set up but need manual starts. Open 4 separate terminals and run:

## Terminal 1 - Update task tool
```bash
cd .worktrees/2
claude "Work on issue #2 - Update task tool for new format. The task tool needs to support the new #47-1 format instead of just #47. Update all operations to handle task-specific IDs."
```

## Terminal 2 - Claude Code enhancements  
```bash
cd .worktrees/3
claude "Work on issue #3 - Add Claude Code enhancements to commands. Add extended thinking prompts to setup.md, screenshot docs to status.md, and error recovery to work.md"
```

## Terminal 3 - GitHub checklist parsing
```bash
cd .worktrees/4
claude "Work on issue #4 - Update github tool for checklist parsing. Add functions to parse checklist items from issues, extract completion status, and update checkboxes via API"
```

## Terminal 4 - Create setup-tasks command
```bash
cd .worktrees/5
claude "Work on issue #5 - Create /project:setup-tasks command. Create a new command that converts GitHub issues with checklists into individual tasks in the queue"
```

## Monitor Progress
```bash
# In main directory
watch -n 30 '.claude/tools/session list'

# Check PRs
gh pr list

# View specific session
tmux attach -t claude-1
```

Each Claude instance will:
1. Work in its isolated worktree
2. Make changes and commit
3. Create a PR
4. The PR will reference the issue

This simulates what the automated orchestration would do!