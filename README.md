# Claude Code Parallel

> ⚠️ **Personal Project**: This is a personal tool for parallel development automation with Claude Code. Use at your own risk.

Parallel development automation tools that give Claude Code the ability to work on multiple tasks simultaneously.

## 🚀 What It Does

**Parallel Development at Scale** - Claude Code can:
- Work on multiple issues simultaneously in isolated environments
- Manage task queues with dependency tracking
- Create and switch between git worktrees automatically
- Run parallel tmux sessions with different Claude instances
- Break down large issues into manageable subtasks

## ⚡ Quick Start

```bash
# In your project directory
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-parallel/main/install.sh | bash
```

Then in Claude Code:
```bash
/project:setup    # Analyze project and prepare work queue
/project:work 5   # Start 5 parallel development sessions
```

### Other Options

```bash
# See help
bash install.sh --help

# Uninstall
bash install.sh --uninstall
```

## 🛠️ Core Tools

- **`task`** - Queue management with dependency tracking
- **`session`** - Parallel tmux sessions with git worktrees
- **`github`** - Issue breakdown and PR automation
- **`maintain`** - Cleanup and resource management

## 📋 Commands

```bash
/project:setup       # Initialize project for parallel work
/project:work N      # Start N parallel sessions
/project:status      # View all parallel work status
/project:manual      # Handle tasks requiring human input
/project:maintain    # Clean up worktrees and sessions
/project:auto        # Run continuously with scheduling
```

## 💡 Philosophy

**"Simple tools, intelligent orchestration"**

Each tool is intentionally simple (~50-200 lines). The intelligence comes from Claude orchestrating these tools based on natural language commands.

## 🔧 Requirements

- Git repository
- Bash shell
- Claude Code (MAX subscription recommended)
- GitHub CLI (`gh`) - for issue management
- tmux - for parallel sessions

## ⚠️ Security Note

These tools execute bash commands. Only use in trusted environments and review the code before running.

## 📄 License

MIT License - see [LICENSE](LICENSE)

---

*Parallel development automation for Claude Code.*