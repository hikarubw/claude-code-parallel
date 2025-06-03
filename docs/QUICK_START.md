# Quick Start Guide

Get up and running with Claude Code Tools in 5 minutes!

## 🚀 Installation

```bash
# One-line install
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-tools/main/scripts/install.sh | bash

# Go to your project
cd your-project

# Install for this project
claude-tools-install
```

## 🎯 Basic Workflow

### 1. Initialize Your Project

Open Claude Code in your project and run:

```
/project:setup
```

Claude will:
- Analyze your codebase
- Fetch GitHub issues
- Create sub-tasks for complex work
- Set up the work queue

### 2. Start Working

```
/project:work 5
```

This starts 5 parallel sessions. Claude will:
- Create isolated worktrees for each issue
- Assign work to sessions
- Begin development

### 3. Monitor Progress

```
/project:status
```

See a complete dashboard showing:
- Active sessions and their work
- Queue status
- Manual tasks blocking automation
- Recent completions

### 4. Handle Manual Tasks

```
/project:manual
```

Shows tasks that need human intervention:
- Tasks blocking automated work get priority
- Complete them to unblock automation

### 5. Clean Up

```
/project:maintain
```

Removes:
- Completed worktrees
- Idle sessions
- Old log files

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
- Visit the [GitHub repository](https://github.com/hikarubw/claude-code-tools)