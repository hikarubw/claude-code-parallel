# Claude Code Parallel Documentation

Welcome to the Claude Code Parallel documentation. This directory is organized to help you quickly find the information you need.

## 📑 Table of Contents

See **[TOC.md](TOC.md)** for a complete documentation index.

## 🚀 Getting Started

- **[Quick Start Guide](QUICK_START.md)** - Get running in 5 minutes
- **[Workflow Guide](WORKFLOW.md)** - Common development patterns
- **[FAQ](FAQ.md)** - Frequently asked questions

## 🏗️ Current Architecture (Hybrid Pueue + Tmux)

- **[Architecture Overview](current-architecture/ARCHITECTURE.md)** - System design and philosophy
- **[Hybrid Architecture Guide](current-architecture/HYBRID-ARCHITECTURE-GUIDE.md)** - Detailed hybrid approach
- **[Autonomous Operation](AUTONOMOUS_OPERATION.md)** - How worktree isolation enables 90% fewer interruptions

## 📋 Implementation

- **[Master Plan](implementation/MASTER-PLAN-AND-ROADMAP.md)** - Overall implementation strategy
- **[Strategic Priorities](implementation/STRATEGIC-PRIORITIES.md)** - Key priorities
- **[Week 1 Plan](implementation/WEEK-1-IMPLEMENTATION-PLAN.md)** - Immediate tasks

## 🔮 Future Vision (Pueue-TUI)

- **[Pueue-TUI Vision](future-vision/PUEUE-TUI-FUTURE-VISION.md)** - Extracted Pueue-TUI tool concept
- **[Pueue-TUI Implementation](future-vision/PUEUE-TUI-IMPLEMENTATION-PLAN.md)** - Building Pueue-TUI

## 📚 Reference

- **[Commands Reference](../commands/)** - All slash commands
- **[Tools Reference](../tools/)** - All available tools
- **[Roadmap](ROADMAP.md)** - Project roadmap

## 💡 Key Concepts

### Parallel Development
Run multiple Claude instances working on different issues simultaneously, each in an isolated git worktree.

### Autonomous Operation
With permissive settings in isolated worktrees, Claude can work without constant approval requests.

### Simple Tools
Each tool does one thing well (~50-200 lines). Claude provides the intelligence.

### Natural Workflows
Works with your existing GitHub workflow. No new concepts to learn.

## 📁 Archive

The `archive/` directory contains historical proposals and research documents that informed the current design but are not part of the active documentation.

## 🆘 Help & Support

- **Issues**: [GitHub Issues](https://github.com/hikarubw/claude-code-tools/issues)
- **Discussions**: [GitHub Discussions](https://github.com/hikarubw/claude-code-tools/discussions)

---

*Making parallel development simple, autonomous, and powerful.*