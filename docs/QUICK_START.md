# Quick Start Guide

Get up and running with Claude Code Parallel in 5 minutes! 🚀

## What is Claude Code Parallel?

**Claude Code Parallel** supercharges Claude Code by enabling it to work on multiple tasks simultaneously. Think of it as giving Claude multiple hands to work with - each in its own safe sandbox.

### Key Benefits:
- 🚀 **5-10x faster development** - Work on multiple issues at once
- 🤖 **90% fewer interruptions** - Autonomous operation in isolated worktrees  
- 🔒 **Completely safe** - All changes go through PR review
- 🧠 **Smart orchestration** - Claude manages dependencies automatically

## 🚀 Installation

```bash
# In your project directory
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-parallel/main/install.sh | bash
```

That's it! The installer adds commands and tools to your project's `.claude/` directory.

## 🎯 Your First Parallel Session

### Step 1: Initialize Your Project

Open Claude Code in your project and run:

```
/project:setup
```

**What happens:** Claude analyzes your GitHub issues, creates a work queue, and prepares everything for parallel execution.

### Step 2: Start Parallel Work

```
/project:work 5
```

**What happens:** Claude starts 5 parallel sessions, each working on a different issue in its own isolated git worktree. No more waiting for one task to finish before starting the next!

### Step 3: Check Progress

```
/project:status
```

**What happens:** See a real-time dashboard of all active work, completed tasks, and any blockers.

### Step 4: Handle Manual Tasks (if any)

```
/project:manual
```

**What happens:** Some tasks need human input (like API keys). Complete these to unblock more automated work.

### Step 5: Clean Up When Done

```
/project:maintain
```

**What happens:** Removes completed worktrees and stops idle sessions, keeping your workspace tidy.

## 📘 Example Session

```
User: /project:setup

Claude: Analyzing your project...
✓ Found 23 open issues
✓ Created 12 sub-issues for complex tasks
✓ Set up work queue with 35 tasks
Ready to start!

User: /project:work 3 --watch

Claude: Starting 3 parallel sessions...
Session 1: Working on #123 (bug fix)
Session 2: Working on #456 (feature)
Session 3: Working on #789 (refactor)

Monitoring enabled - I'll assign new work automatically.

User: /project:status

Claude: 
=== Development Status ===
Active: 3/3 sessions
Queue: 32 tasks remaining
Completed: 0
Blocked: 5 (need manual work)

Manual tasks blocking automation:
🚨 #101: Setup API credentials (blocks 3 tasks)

User: /project:manual start 101

Claude: Starting manual task #101.
Complete this to unblock 3 automated tasks.

[After completing manual work]

User: /project:manual done 101

Claude: Great! Unblocked 3 tasks.
Assigning them to available sessions...
```

## 🎮 Essential Commands

| Command | Purpose |
|---------|---------|
| `/project:setup` | Analyze and prepare project |
| `/project:work [N]` | Start N parallel sessions |
| `/project:status` | View progress dashboard |
| `/project:manual` | Manage human tasks |
| `/project:maintain` | Clean up resources |
| `/project:auto start` | Run autonomously |

## 💡 Pro Tips

1. **Start Small**: Begin with 3-5 sessions until you're comfortable
2. **Watch Mode**: Add `--watch` to `/project:work` for continuous operation
3. **Regular Cleanup**: Run `/project:maintain` daily
4. **Handle Blockers**: Check `/project:manual` frequently

## 🆘 Need Help?

- Run any command without arguments for help
- Check `docs/WORKFLOW.md` for detailed workflows
- Visit the [GitHub repository](https://github.com/hikarubw/claude-code-parallel)