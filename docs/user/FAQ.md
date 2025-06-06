# Frequently Asked Questions

## General Questions

### What is Claude Code Parallel?
Claude Code Parallel extends Claude Code with parallel development capabilities using a hybrid Pueue+Tmux architecture. It enables working on multiple GitHub issues simultaneously with intelligent orchestration.

### How is this different from regular Claude Code?
- **Parallel Execution**: Work on multiple issues at once via Pueue
- **Autonomous Operation**: 99% fewer approval interruptions
- **Queue Management**: Robust Pueue backend for reliability
- **Smart Orchestration**: Claude manages issue decomposition
- **Crash Recovery**: Automatic recovery via Pueue persistence

### What is the Hybrid Pueue+Tmux Architecture?
The hybrid architecture combines:
- **Pueue**: Industrial-grade task queue for reliability and persistence
- **Tmux**: Terminal sessions for Claude Code compatibility
- **Best of both worlds**: Professional queue management + Claude visibility

### Why not use pure Pueue or pure Tmux?
- **Pure Pueue**: Claude Code requires terminal interaction, which Pueue alone doesn't provide
- **Pure Tmux**: No persistence, no crash recovery, manual queue management
- **Hybrid**: Pueue manages tasks, spawns Tmux sessions, provides recovery

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
- GitHub CLI (`gh`)
- Tmux
- Pueue (installed automatically)

### How does the hybrid setup work?
The setup process:
1. Installs Pueue if not present
2. Configures Pueue daemon with worker groups
3. Sets up autonomous Claude Code settings
4. Starts auto-approval daemon
5. Verifies all components are working

Run: `./tools/setup-hybrid`

### How do I update to the latest version?
```bash
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-tools/main/install.sh | bash
```

### Can I uninstall it?
```bash
./install.sh --uninstall
```

## Usage Questions

### Why am I still getting approval prompts?
Check that:
1. You're working in a worktree (not main branch)
2. Autonomous settings are applied: `./tools/setup-hybrid check`
3. You're using the latest version
4. Pueue daemon is running: `pueue status`

### How many parallel sessions can I run?
- **Recommended**: 5-10 sessions
- **Possible**: Up to 20-30 with good hardware
- **Factors**: CPU, memory, disk I/O

### What happens if a session fails?
- Pueue automatically retries failed tasks
- Work is preserved in the worktree
- Other sessions continue working
- Use `/project:status` to check queue health
- Failed tasks appear in `pueue status`

### How does Pueue handle crashes?
Pueue provides robust crash recovery:
- **Daemon crash**: State is persisted, tasks resume on restart
- **Worker crash**: Task marked as failed, automatically retried
- **System reboot**: Pueue daemon starts on boot, resumes queue
- **Network issues**: Built-in retry logic with exponential backoff

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

## Hybrid Architecture Questions

### How do I monitor the hybrid system?
Multiple monitoring options:
```bash
# Check Pueue queue status
pueue status

# Watch queue in real-time
pueue follow

# Check specific worker
tmux attach -t worker-1

# View task logs
pueue log <task-id>

# Monitor all workers
/project:status --watch
```

### Can I pause/resume work?
Yes, with fine-grained control:
```bash
# Pause all workers
pueue pause

# Pause specific group
pueue pause --group workers

# Resume all
pueue start

# Resume specific task
pueue start <task-id>
```

### How do I scale workers up/down?
```bash
# Increase concurrent workers
pueue parallel 16 --group workers

# Decrease for resource constraints
pueue parallel 4 --group workers

# Check current setting
pueue status --group workers
```

### What Pueue commands should I know?
Essential commands:
- `pueue status` - View queue state
- `pueue log <id>` - View task output
- `pueue restart <id>` - Retry failed task
- `pueue clean` - Remove completed tasks
- `pueue kill <id>` - Stop running task
- `pueue edit <id>` - Modify queued task
- `pueue follow <id>` - Live task output

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

### "Command not found: pueue"
Install Pueue:
```bash
# macOS
brew install pueue

# Linux
curl -sSL https://github.com/Nukesor/pueue/releases/latest/download/pueued-linux-x86_64 -o pueued
curl -sSL https://github.com/Nukesor/pueue/releases/latest/download/pueue-linux-x86_64 -o pueue
chmod +x pueued pueue
sudo mv pueued pueue /usr/local/bin/
```

### Sessions seem stuck
1. Check Pueue status: `pueue status`
2. View task logs: `pueue log <task-id>`
3. Restart task: `pueue restart <task-id>`
4. Check tmux session: `tmux attach -t worker-<id>`

### Pueue daemon won't start
```bash
# Check if already running
ps aux | grep pueued

# Kill existing daemon
pueue shutdown

# Reset state if corrupted
pueue reset

# Start fresh
pueued -d
```

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