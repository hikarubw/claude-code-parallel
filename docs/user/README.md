# User Guide

Welcome to Claude Code Parallel! This guide will help you get started and use the tools effectively.

## 📚 Contents

1. **[Quick Start Guide](QUICK_START.md)** - Get running in 5 minutes
   - Installation
   - Basic usage
   - First parallel task

2. **[Workflow Guide](WORKFLOW.md)** - Common development patterns
   - Starting parallel work
   - Monitoring progress
   - Managing sessions
   - Troubleshooting

3. **[Autonomous Operation](AUTONOMOUS_OPERATION.md)** - Reduce interruptions by 90%
   - How it works
   - Setting up autonomous mode
   - Best practices

4. **[FAQ](FAQ.md)** - Frequently asked questions
   - Requirements
   - Common issues
   - Tips and tricks

## 🚀 Getting Started

```bash
# Install Claude Code Parallel
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-tools/main/install.sh | bash

# Start the hybrid architecture
./tools/setup-hybrid 4

# Run your first parallel task
/project:work #123 #124 #125
```

## 💡 Key Concepts

- **Parallel Development**: Work on multiple issues simultaneously
- **Hybrid Architecture**: Pueue for queue management + Tmux for visibility
- **Autonomous Operation**: Claude works without constant approvals
- **Natural Workflow**: Issues → Analysis → Queue → Workers → PRs

## 🆘 Need Help?

- Check the [FAQ](FAQ.md) first
- Review [Troubleshooting](WORKFLOW.md#troubleshooting) section
- Open an [issue](https://github.com/hikarubw/claude-code-tools/issues)

---

*Making AI development simple, visible, and powerful.*