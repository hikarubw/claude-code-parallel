# Claude Code Parallel

Supercharge Claude Code with parallel development capabilities. Work on multiple tasks simultaneously with 90% fewer interruptions.

## 🚀 What Is This?

Claude Code Parallel enables Claude to work on multiple issues at once using isolated git worktrees and tmux sessions. Each parallel session operates autonomously in its own sandbox, dramatically reducing approval prompts while keeping your main branch safe.

### Key Features:
- **🔄 Parallel Execution** - Work on 5-10 issues simultaneously
- **🤖 Autonomous Operation** - 90% fewer approval interruptions
- **📦 Isolated Worktrees** - Each task in its own git sandbox  
- **🧠 Smart Orchestration** - Automatic dependency management
- **✅ Safe by Design** - All changes through PR review

## ⚡ Quick Start

```bash
# Install in your project
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-parallel/main/install.sh | bash

# Then in Claude Code:
/project:setup    # Initialize project
/project:work 5   # Start 5 parallel sessions
```

See [Quick Start Guide](docs/QUICK_START.md) for a 5-minute walkthrough.

## 📚 Documentation

- **[Quick Start Guide](docs/QUICK_START.md)** - Get running in 5 minutes
- **[Architecture Overview](docs/ARCHITECTURE.md)** - How it works
- **[Workflow Guide](docs/WORKFLOW.md)** - Common usage patterns
- **[FAQ](docs/FAQ.md)** - Frequently asked questions
- **[All Documentation](docs/README.md)** - Complete docs index

## 🎮 Commands

| Command | Description |
|---------|-------------|
| `/project:setup` | Analyze project and prepare work queue |
| `/project:work N` | Start N parallel sessions |
| `/project:status` | View progress dashboard |
| `/project:manual` | Handle manual tasks |
| `/project:maintain` | Clean up resources |

## 🛡️ Safety & Security

- **Worktree Isolation**: Each task works in an isolated git worktree
- **PR Gateway**: All changes must go through pull request review
- **No Main Branch Access**: Parallel sessions can't modify main directly
- **Full Traceability**: Complete git history for all changes

## 📋 Requirements

- Git repository
- Bash shell  
- Claude Code (MAX subscription recommended)
- Optional: GitHub CLI (`gh`), tmux

## ⚠️ Disclaimer

This is a personal project for parallel development automation. While designed to be safe through worktree isolation, always review PRs before merging. Use at your own risk.

## 📄 License

MIT License - see [LICENSE](LICENSE)

---

*Built with the philosophy: Simple tools + Intelligent orchestration + Safe isolation = Powerful automation*