# 🚀 Claude Code Tools - Parallel Development Made Simple

> Transform single-threaded development into massively parallel workflows using Claude Code's intelligence

## What is this?

Claude Code Tools extends [Claude Code](https://claude.ai/code) to enable **parallel development** - multiple Claude sessions working on different parts of your codebase simultaneously.

## 🎯 The Problem

Traditional development is sequential:
1. Work on issue A
2. Wait for PR review
3. Work on issue B
4. Context switch back to A...

## ✨ The Solution

With Claude Code Tools:
```bash
# Start 8 parallel workers on your GitHub issues
/project:work 123,124,125 8

# Claude automatically:
# - Analyzes each issue
# - Creates logical subissues
# - Assigns work to parallel workers
# - Creates PRs when complete
# - Closes parent issues when done
```

## 🏗️ Architecture

**Subissue-Based Worker Pool (v3.0)**
```
GitHub Issues → Claude Analysis → Priority Queue → Worker Pool → Pull Requests
    #123         Creates 3-5        Ordered         Parallel      Auto-merged
    #124         subissues          by priority     Claude        when approved
    #125                                            sessions
```

## 🚀 Quick Start

### 1. Install
```bash
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-tools/main/install.sh | bash
```

### 2. Start Parallel Work
```bash
# In your project directory
cd my-project

# Start 4 workers on issue #123
/project:work 123 4

# Or work on multiple issues with 8 workers
/project:work 123,124,125 8
```

### 3. Monitor Progress
```bash
# Check status
/project:status

# Watch live progress
/project:status --watch
```

## 📋 Commands

| Command | Description |
|---------|-------------|
| `/project:work ISSUES [N]` | Start N workers on specified issues |
| `/project:status` | Show current progress |
| `/project:add ISSUES` | Add more issues to queue |
| `/project:stop` | Gracefully stop all workers |
| `/project:resume` | Resume from saved state |

## 🎯 Key Features

### 🤖 Intelligent Issue Analysis
Claude analyzes each issue and creates 2-5 concrete, independent subissues with clear acceptance criteria.

### 🔄 Autonomous Workers
Each worker operates independently in its own git worktree, fetching work from the queue until complete.

### 📊 Real-time Monitoring
Watch progress with a live dashboard showing worker status, queue state, and completion metrics.

### 💾 Resume Capability
Stop and resume work anytime - the system saves state and picks up where it left off.

### 🔧 Zero Configuration
Just provide issue numbers - Claude handles everything else.

## 📚 Documentation

- [Architecture Overview](docs/ARCHITECTURE.md)
- [Quick Start Guide](docs/QUICK_START.md)
- [Workflow Examples](docs/WORKFLOW.md)
- [FAQ](docs/FAQ.md)

## 🤝 Requirements

- [Claude Code](https://claude.ai/code) subscription
- Git repository with GitHub issues
- macOS or Linux (Windows WSL supported)
- tmux (installed automatically)

## 📈 Performance

Typical throughput with 8 workers:
- **Simple changes**: 10-15 PRs/hour
- **Complex features**: 4-8 PRs/hour
- **With reviews**: 20-30 PRs/day

## 🔒 Security

- All work happens in isolated git worktrees
- No credential storage - uses your existing git auth
- Respects .gitignore and security policies
- Workers run in restricted tmux sessions

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/hikarubw/claude-code-tools/issues)
- **Discussions**: [GitHub Discussions](https://github.com/hikarubw/claude-code-tools/discussions)

## 📄 License

MIT License - see [LICENSE](LICENSE) file.

---

**Making parallel development simple, autonomous, and powerful.**