# Enhanced Worker System with Error Recovery and Health Monitoring

## Overview

The Enhanced Worker System builds upon the hybrid Pueue + Tmux architecture to provide resilient, self-healing workers with comprehensive health monitoring and performance tracking.

## Components

### 1. **worker-health-monitor**
Tracks and reports worker health status with real-time metrics.

**Features:**
- Heartbeat monitoring (5-second intervals)
- Dead worker detection (30-second threshold)
- Task completion tracking
- Performance metrics per worker
- Alert logging for critical events
- Live health dashboard

**Usage:**
```bash
# Update worker heartbeat
worker-health-monitor heartbeat WORKER_ID [STATUS] [TASK]

# Check worker health
worker-health-monitor check WORKER_ID

# View live dashboard
worker-health-monitor dashboard

# Generate health report
worker-health-monitor report
```

### 2. **hybrid-worker-enhanced**
An improved worker implementation with error recovery and resilience.

**Enhanced Features:**
- Automatic retry logic (up to 3 attempts)
- Git error recovery
- Worktree conflict resolution
- State persistence across restarts
- Timeout protection for stuck tasks
- Detailed error logging

**Error Handling:**
- **Worktree errors**: Automatic cleanup and retry
- **Git errors**: Repository state reset
- **Claude failures**: Retry with exponential backoff
- **Pueue disconnection**: Reconnection attempts

### 3. **worker-manager**
Monitors all workers and automatically restarts failed ones.

**Features:**
- Continuous health monitoring
- Automatic worker restart (max 5 attempts)
- Worker scaling (up/down)
- Centralized logging
- Background daemon operation

**Usage:**
```bash
# Start manager daemon
worker-manager start

# Check status
worker-manager status

# Scale workers
worker-manager scale 8

# Restart specific worker
worker-manager restart 3
```

### 4. **worker-performance**
Analyzes and reports on worker performance metrics.

**Metrics Tracked:**
- Task completion rates
- Success/failure ratios
- Average task duration
- Worker efficiency percentages
- Restart frequencies
- Queue throughput

**Usage:**
```bash
# Generate performance report
worker-performance report

# Analyze bottlenecks
worker-performance analyze

# Real-time monitoring
worker-performance monitor

# Export metrics
worker-performance export metrics.csv
```

## Architecture Flow

```
┌─────────────────────────────────────────────────────────────┐
│                     Worker Manager (Daemon)                  │
│  - Monitors all workers                                      │
│  - Restarts dead workers                                     │
│  - Scales worker pool                                        │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ├─── Monitors ───┐
                   │                │
┌──────────────────▼─────────┐      ▼
│   Health Monitor Service   │  ┌─────────────────────┐
│  - Tracks heartbeats       │  │  Enhanced Workers   │
│  - Collects metrics        │  │  - Error recovery   │
│  - Generates alerts        │  │  - State persist    │
└────────────────────────────┘  │  - Auto-retry       │
                                └─────────────────────┘
```

## Health States

Workers can be in the following health states:

1. **healthy** - Operating normally
2. **working** - Processing a task
3. **slow** - Task taking longer than expected (>15 min)
4. **unresponsive** - Missing heartbeats (15-30 sec)
5. **dead** - No heartbeat for >30 seconds
6. **recovering** - In recovery process

## Setup

Use the enhanced setup script for one-command initialization:

```bash
# Setup with 4 enhanced workers
./tools/setup-hybrid-enhanced 4

# Or set environment variable
USE_ENHANCED=true ./tools/setup-hybrid-enhanced 6
```

This will:
1. Check all dependencies
2. Start Pueue daemon
3. Create tmux session with workers
4. Initialize health monitoring
5. Start worker manager daemon
6. Launch enhanced workers

## Monitoring

### Live Dashboards

```bash
# Worker health dashboard
worker-health-monitor dashboard

# Performance monitoring
worker-performance monitor

# Queue status
queue-pueue monitor
```

### Status Commands

```bash
# Manager status
worker-manager status

# Health report
worker-health-monitor report

# Performance analysis
worker-performance analyze
```

## Troubleshooting

### Worker Stuck or Unresponsive

1. Check worker status:
   ```bash
   worker-manager status
   ```

2. View worker logs:
   ```bash
   tail -f ~/.claude/workers/errors/worker-N.log
   ```

3. Manually restart if needed:
   ```bash
   worker-manager restart N
   ```

### High Failure Rate

1. Check performance metrics:
   ```bash
   worker-performance analyze
   ```

2. Review error patterns:
   ```bash
   tail -f ~/.claude/workers/health/alerts.log
   ```

3. Scale workers if queue is backing up:
   ```bash
   worker-manager scale 8
   ```

### Recovery from Crashes

The system automatically recovers from:
- Worker process crashes
- Git worktree conflicts  
- Pueue daemon restarts
- Network interruptions
- Claude execution timeouts

Manual intervention is only needed for:
- Persistent git repository corruption
- Authentication failures
- System resource exhaustion

## Performance Tuning

### Configuration Options

Edit the scripts to adjust:
- `HEARTBEAT_INTERVAL`: How often workers report status (default: 5s)
- `DEAD_WORKER_THRESHOLD`: When to consider worker dead (default: 30s)
- `SLOW_TASK_THRESHOLD`: When to flag slow tasks (default: 15min)
- `MAX_RETRIES`: Task retry attempts (default: 3)
- `MAX_RESTART_ATTEMPTS`: Worker restart limit (default: 5)

### Scaling Guidelines

- **Light workload**: 2-4 workers
- **Normal workload**: 4-8 workers  
- **Heavy workload**: 8-16 workers
- **Maximum tested**: 32 workers

Scale based on:
- Queue depth (pending tasks)
- Average task completion time
- System resources (CPU/memory)

## Best Practices

1. **Monitor Regularly**
   - Check `worker-manager status` periodically
   - Review performance reports weekly
   - Watch for high restart counts

2. **Proactive Maintenance**
   - Clean old completed tasks: `queue clean 7`
   - Reset metrics monthly: `worker-health-monitor reset`
   - Archive old logs periodically

3. **Resource Management**
   - Don't oversubscribe workers to CPU cores
   - Leave headroom for Claude's resource needs
   - Monitor system memory usage

4. **Error Investigation**
   - Check worker-specific error logs
   - Review health alerts for patterns
   - Analyze failed task characteristics

## Integration with Main System

The enhanced worker system is fully compatible with the existing `/project:*` commands:

```bash
# Start work with enhanced workers
/project:work 123,124,125 8

# Status shows health information
/project:status

# Add more work seamlessly
/project:add 126,127
```

The enhanced features operate transparently, providing better reliability without changing the user interface.