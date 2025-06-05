# Claude Code Tools Workflow Guide

## 🚀 Quick Start Workflow

```bash
# 1. Start working on issues
/project:work 123,124 6

# 2. Monitor progress
/project:status --watch

# 3. Add more work as needed
/project:add 125,126

# 4. Stop when done
/project:stop
```

## 📋 Detailed Workflows

### Starting Fresh Project

```bash
# First time setup
cd your-project
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-tools/main/install.sh | bash

# Create GitHub issues describing what you want
# Then start working on them
/project:work 1,2,3 4

# Claude will:
# - Analyze each issue
# - Create 2-5 subissues per parent
# - Start 4 workers processing the queue
# - Create PRs automatically
```

### Daily Development Flow

```bash
# Morning: Start work on new issues
/project:work 10,11,12 6

# Check progress anytime
/project:status

# Add urgent issue to queue
/project:add 13 --priority=high

# End of day: Stop gracefully
/project:stop

# Next day: Resume where you left off
/project:resume
```

### Continuous Development

```bash
# Start workers on initial issues
/project:work 20,21,22 8

# Monitor live progress
/project:status --watch

# Add issues throughout the day
/project:add 23
/project:add 24,25
/project:add 26 --priority=critical

# Workers automatically pick up new work
# No manual intervention needed
```

## 🎯 Common Scenarios

### Working on Large Feature

```bash
# Create comprehensive issue
# Title: Implement user authentication system
# Body: JWT auth, login/logout, user profiles, tests

# Start with more workers
/project:work 42 8

# Claude creates subissues:
# - #101: Design auth database schema
# - #102: Implement JWT generation
# - #103: Create login/logout endpoints
# - #104: Build user profile pages
# - #105: Add comprehensive tests

# Monitor the feature progress
/project:status --issues
```

### Handling Bug Fixes

```bash
# Add critical bugs with high priority
/project:add 50,51,52 --priority=critical

# Workers automatically prioritize critical work
/project:status --queue

# See which workers are on bugs
/project:status --workers
```

### Scaling Up/Down

```bash
# Start with few workers
/project:work 60 3

# Add more workers if queue grows
/project:status  # Check queue size
worker add 5     # Add 5 more workers

# Remove workers if queue is small
worker stop 3    # Stop 3 workers
```

## 💡 Pro Tips

### 1. Batch Similar Issues
```bash
# Work on related issues together
/project:work 70,71,72 6  # All UI issues
```

### 2. Use Priority Wisely
```bash
# Set priority for urgent work
/project:add 80 --priority=critical  # Do first
/project:add 81 --priority=low       # Do last
```

### 3. Monitor First Runs
```bash
# Watch initial PRs to ensure quality
/project:work 90 2          # Start small
/project:status --watch     # Monitor closely
# If quality is good, scale up
worker add 6                # Add more workers
```

### 4. Resume Capability
```bash
# Stop anytime without losing progress
/project:stop

# Resume exactly where you left off
/project:resume
```

### 5. Check Worker Health
```bash
# Monitor worker efficiency
worker health
worker logs 3  # Check specific worker
```

## 🔧 Troubleshooting

### Workers Not Picking Up Tasks
```bash
# Check queue status
queue status

# Check worker status
worker status

# Restart stuck worker
worker logs 5        # Identify issue
tmux kill-session -t worker-5
worker add 1         # Start replacement
```

### Queue Issues
```bash
# Check for failed items
queue status

# Retry failed subissues
queue retry all

# Check specific parent issue
queue by-parent 100
```

### Performance Issues
```bash
# Check worker health
worker health

# Reduce workers if system is slow
worker stop 4

# Clean old completed items
queue clean 7  # Remove items older than 7 days
```

## 📊 Best Practices

1. **Clear Issue Descriptions** - Better issues = better subissues
2. **Appropriate Worker Count** - 1-2 workers per CPU core
3. **Regular Monitoring** - Check status periodically
4. **Use Priorities** - Critical/high for urgent work
5. **Clean Up Old Data** - Run `queue clean` weekly

## 🎭 Example Day

```
09:00 - Create/review GitHub issues for the day
09:15 - /project:work 101,102,103 6
09:30 - Coffee while workers analyze and start ☕
10:00 - /project:status (check initial progress)
11:00 - /project:add 104 --priority=high (urgent request)
12:00 - /project:status --watch (monitor during lunch)
14:00 - Review some PRs, merge approved ones
15:00 - /project:add 105,106 (afternoon work)
16:30 - /project:status (check day's progress)
17:00 - /project:stop (graceful shutdown)

Next day:
09:00 - /project:resume (continue queue)
```

## 🚀 Advanced Workflows

### Continuous Integration
```bash
# Start workers with auto-merge
/project:work 110,111 8 --auto-merge

# Small, safe PRs get merged automatically
# Large changes wait for review
```

### Multi-Repository Work
```bash
# In repo A
/project:work 1,2 4

# In repo B  
/project:work 10,11 4

# Workers isolated per repository
# Monitor both with separate status commands
```

### Team Collaboration
```bash
# Developer 1: Frontend issues
/project:work 201,202,203 4

# Developer 2: Backend issues
/project:work 301,302,303 4

# Each developer runs their own workers
# No conflicts as they work on different issues
```

This workflow maximizes parallel development while maintaining simplicity and control!