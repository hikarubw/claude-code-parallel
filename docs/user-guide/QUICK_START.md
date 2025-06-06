# 🚀 Quick Start Guide

Get up and running with Claude Code Parallel's hybrid architecture in 5 minutes.

## Prerequisites

- [Claude Code](https://claude.ai/code) subscription (MAX recommended)
- Git repository with GitHub issues
- macOS or Linux (Windows WSL works too)

## 1. Install

```bash
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-parallel/main/install.sh | bash
```

This installs:
- Claude Code Parallel commands in `.claude/commands/`
- Support tools in `~/bin/claude-tools/`
- Dependencies (tmux, gh CLI, pueue)

## 2. Setup Hybrid Architecture

```bash
# Run the hybrid setup (one-time)
./tools/setup-hybrid

# This will:
# ✓ Install and configure Pueue daemon
# ✓ Set up worker groups
# ✓ Configure autonomous Claude settings
# ✓ Start auto-approval daemon
# ✓ Verify all components
```

## 3. Create GitHub Issues

Create issues describing what you want to build:

```markdown
Title: Add user authentication

Description:
- Implement JWT authentication
- Add login/logout endpoints  
- Create user profile page
- Add tests
```

## 4. Start Parallel Development

```bash
# Navigate to your project
cd my-project

# Start 4 workers on issue #123
/project:work 123 4

# Or work on multiple issues with 8 workers
/project:work 123,124,125 8
```

## 5. Watch Progress

```bash
# Check current status
/project:status

# Watch live updates
/project:status --watch

# Or use Pueue directly
pueue status
pueue follow  # Live view
```

You'll see:
- Pueue queue status with task states
- Workers processing subissues in tmux
- PRs being created automatically
- Real-time progress metrics
- Failed tasks with retry counts

## 6. Manage Work

```bash
# Add more issues
/project:add 126,127

# Pause all work
pueue pause

# Resume work
pueue start

# Stop gracefully
/project:stop

# Resume later (automatic with Pueue)
/project:resume

# Scale workers
pueue parallel 16 --group workers  # More workers
pueue parallel 4 --group workers   # Fewer workers
```

## What Happens Under the Hood?

1. **Claude analyzes** your issues and creates logical subissues
2. **Pueue daemon** manages the task queue with persistence
3. **Hybrid workers** are Pueue tasks that spawn tmux sessions
4. **Each tmux session** runs Claude Code on a subissue
5. **Auto-approval** watches sessions and handles prompts
6. **PRs are created** automatically when work completes
7. **Parent issues close** when all subissues are done

### The Hybrid Architecture Advantage

```
GitHub Issue → Claude Analysis → Pueue Queue → Tmux Worker → PR
     #42         Creates 4         Reliable      Visible      Auto
                 subissues        & Persistent   to Claude    Created
```

## Example Session

```bash
$ /project:work 42 4

🤖 Analyzing issue #42...
✓ Created #101: [#42] Design database schema
✓ Created #102: [#42] Implement API endpoints
✓ Created #103: [#42] Create frontend components
✓ Created #104: [#42] Add integration tests

🚀 Starting 4 workers...
✓ worker-1: Processing #101
✓ worker-2: Processing #102
✓ worker-3: Processing #103
✓ worker-4: Processing #104

📊 Progress: 0/4 complete

# ... workers create PRs automatically ...

✅ All done! Created 4 PRs. Issue #42 will close when merged.
```

## Tips for Success

- **Start small**: Try with 1-2 issues first
- **Clear descriptions**: Better issues = better subissues
- **Monitor first run**: Use `pueue follow` to watch workers
- **Scale gradually**: Start with 4 workers, increase as needed
- **Check failures**: `pueue log <id>` shows why tasks failed
- **Trust recovery**: Pueue automatically retries failed tasks

## Troubleshooting Quick Fixes

```bash
# Pueue daemon not running?
pueued -d

# Workers stuck?
pueue restart --all-failed

# Need to stop everything?
pueue kill --all
pueue clean

# System overloaded?
pueue parallel 2 --group workers
```

## Next Steps

- Learn [Pueue Commands](PUEUE_COMMANDS.md) for power users
- Read [Troubleshooting Guide](TROUBLESHOOTING.md) for issues
- Check [Architecture](../developer-guide/current-architecture/ARCHITECTURE.md) for details
- See [FAQ](FAQ.md) for common questions

---

Ready? Pick an issue and run `/project:work` to begin parallel development!