# Architecture Decision Record: Single Tmux Session vs Pueue Integration

**ADR-002** | **Status**: Proposed | **Date**: 2024-12-05

## Context and Problem Statement

Our current v0.3.0 architecture uses multiple tmux sessions (worker-1, worker-2, etc.) with each worker running independently. We're evaluating two architectural changes:
1. Consolidate to a single tmux session with N+1 grid panes
2. Replace our custom queue with Pueue task manager

## Deep Technical Analysis

### Current Architecture Strengths
```
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│  worker-1   │ │  worker-2   │ │  worker-3   │  Multiple tmux sessions
│ (tmux sess) │ │ (tmux sess) │ │ (tmux sess) │  Each polls queue independently
└─────────────┘ └─────────────┘ └─────────────┘
       ↓               ↓               ↓
┌─────────────────────────────────────────────┐
│            Priority Queue (files)            │  Simple file-based queue
└─────────────────────────────────────────────┘
```

### Option A: Pueue Integration

**Architecture:**
```
┌─────────────────────────────────────────────┐
│              Pueue Daemon                    │  External process manager
├─────────────────────────────────────────────┤
│ Task 1: claude --work-on-subissue 201       │  Commands queued
│ Task 2: claude --work-on-subissue 202       │  Not in tmux
│ Task 3: claude --work-on-subissue 203       │  
└─────────────────────────────────────────────┘
```

**Required Changes:**
1. **Complete worker loop rewrite** - Pueue executes commands, not our loop
2. **Auto-approval redesign** - Can't monitor tmux panes anymore
3. **Logging overhaul** - Pueue manages stdout/stderr
4. **Queue migration** - From our file-based to Pueue's database

**Critical Issues:**
- **Loss of Claude visibility**: Claude runs as Pueue tasks, not in observable tmux
- **Auto-approval breaks**: Our daemon relies on tmux pane capture
- **No interactive debugging**: Can't attach to see Claude's current state
- **External dependency**: 12MB Rust binary, another moving part

### Option B: Single Tmux Session Grid

**Architecture:**
```
┌─────────────────────────────────────────────┐
│            claude-workers (tmux)             │
├─────────┬─────────┬─────────┬───────────────┤
│ Pane 0  │ Pane 1  │ Pane 2  │    Pane N     │
│ Monitor │Worker-1 │Worker-2 │   Worker-N    │
│ Status  │ #201    │ #202    │    #203       │
└─────────┴─────────┴─────────┴───────────────┘
```

**Implementation Design:**
```bash
# Grid layout manager
create_worker_grid() {
    local workers=$1
    tmux new-session -d -s claude-workers
    
    # Create monitoring pane (pane 0)
    tmux send-keys -t claude-workers:0.0 'watch -n 1 "queue status && worker status"' C-m
    
    # Create worker panes
    for i in $(seq 1 $workers); do
        tmux split-window -t claude-workers -h
        tmux select-layout -t claude-workers tiled
        
        # Start worker in new pane
        tmux send-keys -t claude-workers:0.$i "./worker-loop.sh $i" C-m
    done
    
    # Final layout adjustment
    tmux select-pane -t claude-workers:0.0
    tmux resize-pane -t claude-workers:0.0 -x 40  # Monitor pane width
}
```

**Required Changes:**
1. **Session management** - Replace multi-session with single-session logic
2. **Pane management** - Dynamic grid layout as workers scale
3. **Auto-approval** - Simpler: monitor one session instead of many
4. **Monitoring pane** - New component for live status dashboard

**Critical Issues:**
- **Single point of failure**: One crash affects all workers
- **Terminal constraints**: ~8 workers max before readability suffers
- **Complex pane math**: Grid layout calculations get tricky
- **Resource concerns**: One large terminal vs distributed sessions

## Decision Matrix

| Criteria | Current (Multi-Session) | Option A (Pueue) | Option B (Single Grid) |
|----------|------------------------|------------------|----------------------|
| **Complexity** | Medium | High (rewrite) | Medium (refactor) |
| **Claude Visibility** | ✅ Excellent | ❌ None | ✅ Excellent |
| **Auto-Approval** | ✅ Works | ❌ Breaks | ✅ Simpler |
| **Scalability** | ✅ Unlimited | ✅ Unlimited | ⚠️ ~8 workers |
| **Reliability** | ✅ Isolated failures | ✅ Daemon robust | ❌ Single failure point |
| **Dependencies** | ✅ None | ❌ External | ✅ None |
| **Monitoring** | ⚠️ Distributed | ⚠️ CLI only | ✅ Unified view |
| **Implementation** | - | 40+ hours | 8-12 hours |

## Recommendation

**Keep current multi-session architecture** with incremental improvements:

1. **Add unified monitoring** without changing worker architecture:
```bash
# New monitoring tool
tmux new-window -n monitor
tmux send-keys 'watch -n 1 "./tools/worker status --dashboard"' C-m
```

2. **Implement session grouping** for easier management:
```bash
tmux new-session -t claude-main -s worker-1
tmux new-session -t claude-main -s worker-2  # Grouped sessions
```

3. **Create dashboard pane** in a dedicated window:
```bash
┌─────────────────────────────────────────────┐
│          claude-monitor (tmux)               │
├─────────────┬───────────────────────────────┤
│   Status    │        Worker Logs            │
│  Dashboard  │   (tail -f multiple logs)     │
└─────────────┴───────────────────────────────┘
```

## Why Not Change?

1. **Pueue breaks our core value**: Direct Claude observability
2. **Single session limits scale**: 8 workers vs unlimited
3. **Current architecture works**: 99% autonomous already
4. **Risk vs reward**: Major rewrite for marginal benefits

## Incremental Improvements Instead

1. **Better monitoring** - Unified dashboard without architectural change
2. **Session templates** - Faster worker creation
3. **Log aggregation** - Central log viewer
4. **Health checks** - Automatic worker restart

## Consequences

### Positive
- ✅ Preserves working system
- ✅ Maintains Claude visibility
- ✅ No external dependencies
- ✅ Incremental improvements possible

### Negative
- ❌ Miss unified view (mitigated by monitoring window)
- ❌ Multiple sessions to manage (automated already)

### Neutral
- 🔄 Continue with current patterns
- 🔄 Focus on polish vs rewrite

## Implementation Plan

If we were to implement Option B (single session), here's the plan:

### Phase 1: Prototype (2 days)
```bash
# Grid manager prototype
tools/grid-manager create 4        # Create 4-worker grid
tools/grid-manager add-worker      # Dynamically add
tools/grid-manager remove-worker 3 # Remove specific worker
```

### Phase 2: Migration (3 days)
- Adapt worker loops for pane execution
- Update auto-approval for single session
- Implement monitoring pane

### Phase 3: Testing (2 days)
- Stress test with 8+ workers
- Failure recovery testing
- Performance comparison

## Alternative: Hybrid Approach

Use tmux session groups with a dedicated monitoring session:
```
claude-group/
├── monitor (dashboard session)
├── worker-1
├── worker-2
└── worker-N
```

This gives us unified monitoring without single point of failure.

## Final Verdict

**Recommendation: Keep current architecture, add monitoring layer**

The current multi-session approach is superior for our use case. Pueue would break core features, and single-session introduces unnecessary constraints. Instead, we should focus on better monitoring and management tools that work with our existing architecture.