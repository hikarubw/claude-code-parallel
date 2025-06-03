# Claude Code Tools Workflow Guide

## 🚀 Quick Start Workflow

```bash
# 1. Setup your project
/project:setup

# 2. Start working
/project:work 5

# 3. Check progress
/project:status

# 4. Handle blockers
/project:manual

# 5. Clean up
/project:maintain
```

## 📋 Detailed Workflows

### Starting Fresh Project

```bash
# First time setup
cd your-project
/path/to/claude-code-tools/install.sh

# Initialize
/project:setup
# Claude analyzes code and issues, creates sub-tasks

# Start development
/project:work 5 --watch
# 5 parallel sessions with continuous monitoring

# Check anytime
/project:status
```

### Daily Development Flow

```bash
# Morning: Check status
/project:status

# Resume work
/project:work --watch

# Handle manual tasks
/project:manual
/project:manual start 45
# Do the manual work
/project:manual done 45

# End of day cleanup
/project:maintain
```

### Autonomous Operation

```bash
# Start autonomous mode with work hours
/project:auto start --hours=09-18 --sessions=5

# Check in periodically
/project:status

# Stop when needed
/project:auto stop
```

## 🎯 Common Scenarios

### Blocked by Manual Work

```bash
/project:status
# Shows manual tasks blocking automation

/project:manual
# See priority manual tasks

/project:manual start 101
# Complete the manual task

/project:manual done 101
# Automated work resumes
```

### PR Cleanup

```bash
/project:maintain status
# Shows merged PRs and closed issues

/project:maintain worktrees
# Cleans up completed work

/project:maintain all
# Full cleanup
```

### Focus on Specific Work

```bash
# Only work on bugs
/project:work --focus=bug:*

# Aggressive auto-approval
/project:work --aggressive

# Safe mode (default)
/project:work --safe
```

## 💡 Pro Tips

### 1. Use Watch Mode
Add `--watch` to keep assigning new work:
```bash
/project:work 5 --watch
```

### 2. Regular Maintenance
Run maintenance daily:
```bash
/project:maintain
```

### 3. Unblock Early
Check manual tasks frequently:
```bash
/project:manual
```

### 4. Monitor Progress
Status gives you everything:
```bash
/project:status
```

### 5. Adjust Parallelism
Start conservative, increase as needed:
```bash
/project:work 3  # Start small
/project:work 8  # Scale up
```

## 🔧 Troubleshooting

### Sessions Not Starting
```bash
# Check tmux
tmux ls

# Clean and restart
/project:maintain sessions
/project:work
```

### Work Not Progressing
```bash
# Check blockers
/project:status
/project:manual

# Check session state
session list
```

### Disk Space Issues
```bash
# Clean aggressively
/project:maintain all
maintain prune 3  # Keep only 3 days
```

## 📊 Best Practices

1. **Start with `/setup`** - Always analyze first
2. **Use appropriate parallelism** - 3-5 sessions is usually optimal
3. **Handle manual tasks promptly** - They block automation
4. **Clean up regularly** - Prevents resource accumulation
5. **Monitor autonomous mode** - Check in every few hours

## 🎭 Example Day

```
09:00 - /project:setup
09:15 - /project:work 5 --watch
10:00 - /project:manual (handle blockers)
12:00 - /project:status (check progress)
14:00 - /project:manual done 45
16:00 - /project:status
17:30 - /project:maintain
18:00 - /project:auto start --hours=09-18
```

This workflow maximizes productivity while maintaining control and visibility.