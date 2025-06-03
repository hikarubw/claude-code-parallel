# Frequently Asked Questions

## General Questions

### What is Claude Code Parallel?
Claude Code Parallel is a tool that enables Claude Code to work on multiple tasks simultaneously using git worktrees and tmux sessions. It manages parallel development with intelligent orchestration.

### How is this different from regular Claude Code?
- **Parallel Execution**: Work on multiple issues at once
- **Autonomous Operation**: 90% fewer approval interruptions
- **Isolated Environments**: Each task gets its own git worktree
- **Smart Orchestration**: Claude manages dependencies and assignments

### Is it safe to give Claude so many permissions?
Yes! The key is **worktree isolation**:
- Each worktree is separate from your main branch
- All changes must go through PR review
- Worktrees are disposable if something goes wrong
- Full git history is preserved

## Installation & Setup

### What are the requirements?
- Git repository
- Bash shell
- Claude Code (MAX subscription recommended)
- Optional: GitHub CLI (`gh`), tmux

### How do I update to the latest version?
```bash
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-parallel/main/install.sh | bash
```

### Can I uninstall it?
```bash
./install.sh --uninstall
```

## Usage Questions

### Why am I still getting approval prompts?
Check that:
1. You're working in a worktree (not main branch)
2. Autonomous settings are applied: `./tools/setup-autonomous check`
3. You're using the latest version

### How many parallel sessions can I run?
- **Recommended**: 5-10 sessions
- **Possible**: Up to 20-30 with good hardware
- **Factors**: CPU, memory, disk I/O

### What happens if a session fails?
- Work is preserved in the worktree
- You can restart the session
- Other sessions continue working
- Use `/project:status` to check health

### Can I use this without GitHub?
The core parallel execution works without GitHub, but you'll miss:
- Automatic issue fetching
- PR creation
- Issue state detection

## Autonomous Operation

### What operations are allowed in autonomous mode?
In worktrees, Claude can:
- ✅ Modify any files
- ✅ Run tests and builds
- ✅ Install dependencies
- ✅ Commit and push to feature branches
- ✅ Create pull requests

### What's still restricted?
- ❌ Direct pushes to main/master
- ❌ Destructive operations (rm -rf /)
- ❌ System-level changes (sudo)
- ❌ Production deployments

### How do I disable autonomous mode?
```bash
/project:work 5 --interactive
```

## Troubleshooting

### "Command not found: tmux"
Install tmux:
```bash
# macOS
brew install tmux

# Linux
sudo apt install tmux
```

### "Command not found: gh"
Install GitHub CLI:
```bash
# macOS
brew install gh

# Linux
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

### Sessions seem stuck
1. Check status: `/project:status`
2. View logs: `tmux attach -t claude-1`
3. Restart session: `./tools/session stop 1 && ./tools/session start 1`

### Worktrees taking too much space
```bash
/project:maintain
```
This cleans up completed worktrees and frees space.

## Best Practices

### When should I use parallel mode?
- Multiple independent issues
- Large refactoring with many files
- Creating multiple features simultaneously
- Running different experiments

### When should I NOT use parallel mode?
- Single focused task
- Learning a new codebase
- Debugging complex issues
- Tasks with many dependencies

### How do I organize work effectively?
1. Use `/project:setup` to analyze and organize
2. Let Claude handle dependency management
3. Review PRs as they're created
4. Use `/project:manual` for human tasks

## Advanced Usage

### Can I customize the autonomous settings?
Yes! Edit `.claude/templates/settings.worktree.json` to adjust permissions.

### Can I run this on multiple machines?
Currently designed for single machine, but you can:
- Run on a powerful cloud instance
- Use remote development tools
- Share worktrees via git

### How do I contribute?
See [Contributing Guidelines](https://github.com/hikarubw/claude-code-parallel/blob/main/CONTRIBUTING.md)

## Philosophy

### Why are the tools so simple?
We follow "Claude-first" design:
- Tools are "hands" not "brains"
- Claude provides all intelligence
- Simple tools are maintainable
- Easy to understand and modify

### Is this replacing human developers?
No! It's augmenting human capabilities:
- Humans set direction and review
- Claude handles implementation
- Collaboration, not replacement
- Quality gates remain human-controlled