# 🚀 Quick Start Guide

Get up and running with Claude Code Tools in 5 minutes.

## Prerequisites

- [Claude Code](https://claude.ai/code) subscription
- Git repository with GitHub issues
- macOS or Linux (Windows WSL works too)

## 1. Install

```bash
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-tools/main/install.sh | bash
```

This installs:
- Claude Code Tools commands in `.claude/commands/`
- Support tools in `~/bin/claude-tools/`
- Dependencies (tmux, gh CLI)

## 2. Create GitHub Issues

Create issues describing what you want to build:

```markdown
Title: Add user authentication

Description:
- Implement JWT authentication
- Add login/logout endpoints  
- Create user profile page
- Add tests
```

## 3. Start Parallel Development

```bash
# Navigate to your project
cd my-project

# Start 4 workers on issue #123
/project:work 123 4

# Or work on multiple issues with 8 workers
/project:work 123,124,125 8
```

## 4. Watch Progress

```bash
# Check current status
/project:status

# Watch live updates
/project:status --watch
```

You'll see:
- Workers processing subissues
- PRs being created
- Real-time progress metrics

## 5. Manage Work

```bash
# Add more issues
/project:add 126,127

# Stop gracefully
/project:stop

# Resume later
/project:resume
```

## What Happens?

1. **Claude analyzes** your issues and creates logical subissues
2. **Workers start** in parallel tmux sessions
3. **Each worker** picks subissues from the queue
4. **PRs are created** automatically when work completes
5. **Parent issues close** when all subissues are done

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

## Tips

- **Start small**: Try with 1-2 issues first
- **Clear descriptions**: Better issues = better subissues
- **Monitor first run**: Watch to ensure quality
- **Scale up**: Add more workers as needed

## Next Steps

- Read [Workflow Examples](WORKFLOW.md)
- Check [Architecture](ARCHITECTURE.md) for details
- See [FAQ](FAQ.md) for common questions

---

Ready? Pick an issue and run `/project:work` to begin!