# Unified Monitoring Dashboard Guide

## Overview

The unified monitoring dashboard provides comprehensive real-time visibility into the Claude Code Parallel hybrid architecture. It consolidates queue status, worker health, task metrics, and debugging information into a single, intuitive interface.

## Features

### 1. Real-Time Dashboard
- **Live Updates**: Refreshes every 2 seconds (configurable)
- **Visual Progress Bars**: Color-coded task status visualization
- **Interactive Controls**: Keyboard shortcuts for navigation
- **System Health**: Pueue daemon and Tmux session status

### 2. Queue Visualization
- **Task Distribution**: Pending, working, completed, and failed tasks
- **Visual Progress Bar**: Intuitive representation of queue state
- **Queue Depth**: Real-time count of tasks in each state

### 3. Worker Monitoring
- **Active Workers**: Shows which workers are processing tasks
- **Current Activities**: Displays the specific subissue each worker is handling
- **Idle Detection**: Identifies workers waiting for tasks

### 4. Performance Metrics
- **Average Completion Time**: Task processing duration
- **Success Rate**: Percentage of successfully completed tasks
- **Throughput**: Tasks completed per hour
- **Estimated Time**: Projected completion based on current rate

### 5. Activity Log
- **Recent Completions**: Last 5 completed tasks with timestamps
- **Failed Tasks**: Highlighted failures for quick attention
- **Parent Issue Tracking**: Links subissues to their parent issues

## Usage

### Command Line Interface

```bash
# Live monitoring dashboard (default)
unified-monitor

# Single status snapshot
unified-monitor once

# Performance metrics only
unified-monitor metrics

# JSON output for integration
unified-monitor json

# Debug information
unified-monitor debug
```

### Dashboard Controls

When in live monitoring mode:
- `q` - Quit the dashboard
- `r` - Refresh immediately
- `w` - Switch to tmux worker view
- `p` - Show Pueue status

### Integration with /project:status

The unified monitor powers the enhanced `/project:status` command:

```bash
# Basic status
/project:status

# Live monitoring
/project:status --watch

# Specific views
/project:status --workers
/project:status --queue
/project:status --issues

# Verbose output
/project:status --verbose

# JSON format
/project:status --json
```

## Architecture

### Data Sources

1. **File Queue** (`~/.claude/queue/`)
   - `queue.txt`: Active tasks
   - `completed.txt`: Finished tasks
   - `failed.txt`: Failed tasks

2. **Pueue Daemon**
   - Task scheduling status
   - Running task information
   - Queue management

3. **Tmux Sessions**
   - Worker pane status
   - Active command detection
   - Session health

### Display Components

```
┌─────────────────────────────────────────┐
│        UNIFIED MONITOR HEADER           │
├─────────────────────────────────────────┤
│ SYSTEM STATUS                           │
│ • Pueue: ✅ Running                     │
│ • Tmux: ✅ Active (4 workers)           │
├─────────────────────────────────────────┤
│ QUEUE OVERVIEW                          │
│ Progress: [████████▓▓▓▒▒▒░░░] 40%       │
│ ✅ Completed: 8   ⚙ Working: 3          │
│ ⏳ Pending: 5     ❌ Failed: 1          │
├─────────────────────────────────────────┤
│ ACTIVE WORKERS                          │
│ Worker-1: ⚙ Working on #201 (parent #123)│
│ Worker-2: ⏳ Idle - waiting for tasks   │
├─────────────────────────────────────────┤
│ PERFORMANCE METRICS                     │
│ Avg Completion: 22 minutes              │
│ Success Rate: 89%                       │
│ Throughput: ~3 min/task                 │
├─────────────────────────────────────────┤
│ RECENT ACTIVITY                         │
│ ✓ #200 (parent #123) at 14:32:15       │
│ ✗ #199 (parent #122) - failed          │
└─────────────────────────────────────────┘
```

## Customization

### Environment Variables

- `REFRESH_RATE`: Update interval in seconds (default: 2)
- `QUEUE_DIR`: Custom queue directory location
- `PUEUE_GROUP`: Pueue group name (default: "subissues")

### Color Scheme

The monitor uses ANSI color codes for visual clarity:
- 🟢 Green: Success/Completed
- 🟡 Yellow: Working/In Progress
- 🔵 Blue: Pending/Queued
- 🔴 Red: Failed/Error
- 🟣 Magenta: Headers/Sections
- 🔷 Cyan: System information

## Debugging

### Debug Mode

```bash
unified-monitor debug
```

Shows:
- Configuration paths
- File existence and timestamps
- Pueue daemon status
- Tmux session information
- Raw queue data

### Common Issues

1. **"No active workers"**
   - Check if tmux session exists: `tmux ls`
   - Verify session name: `claude-workers`

2. **"Pueue daemon not running"**
   - Start daemon: `pueued -d`
   - Check status: `pueue status`

3. **Empty queue statistics**
   - Verify queue file location
   - Check file permissions
   - Ensure queue directory exists

## Performance Considerations

- **Minimal Resource Usage**: Uses efficient file parsing and caching
- **Non-Blocking Updates**: Asynchronous data collection
- **Scalable Design**: Handles hundreds of tasks efficiently
- **Terminal Optimization**: Smart screen updates reduce flicker

## Future Enhancements

Planned improvements:
- Graph visualization for metrics over time
- Worker efficiency scoring
- Predictive completion estimates
- Alert thresholds and notifications
- Historical data persistence
- Web-based dashboard option

## Example Workflow

1. Start monitoring before launching workers:
   ```bash
   unified-monitor &
   ```

2. Launch parallel work:
   ```bash
   /project:work 123,124 4
   ```

3. Monitor progress:
   - Watch the dashboard update in real-time
   - Check worker utilization
   - Monitor success rates

4. Investigate issues:
   ```bash
   # Check failed tasks
   /project:status --queue --verbose
   
   # Debug specific worker
   tmux attach -t claude-workers
   ```

5. Generate report:
   ```bash
   unified-monitor json > status-report.json
   ```

The unified monitor provides complete visibility into your parallel development workflow, making it easy to track progress, identify bottlenecks, and ensure successful completion of all tasks.