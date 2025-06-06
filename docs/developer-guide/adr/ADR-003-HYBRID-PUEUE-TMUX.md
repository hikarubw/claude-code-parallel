# Architecture Decision Record: Hybrid Pueue + Tmux Architecture

**ADR-003** | **Status**: Proposed | **Date**: 2024-12-05

## Context

The discovered code shows a sophisticated hybrid approach that combines:
- Pueue for queue management (persistence, dependencies, scheduling)
- Tmux for visibility and interaction (Claude remains observable)
- Auto-response system using tmux capture-pane (maintains our 99% autonomy)

This solves the fundamental conflict between queue robustness and Claude visibility.

## Revolutionary Hybrid Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Pueue Daemon (Queue Manager)              │
│  - Persistent queue                                          │
│  - Dependency management                                     │
│  - Job scheduling                                           │
│  - NOT executing commands directly                          │
└────────────────────────┬────────────────────────────────────┘
                         │ Workers poll queue
┌────────────────────────┴────────────────────────────────────┐
│                  Tmux Session: claude-workers                │
├─────────┬─────────┬─────────┬─────────┬────────────────────┤
│ Pane 0  │ Pane 1  │ Pane 2  │ Pane 3  │    Pane N         │
│ Monitor │Worker 1 │Worker 2 │Worker 3 │   Worker N         │
│ Status  │ Claude  │ Claude  │ Claude  │   Claude           │
│Dashboard│ #201    │ #202    │ #203    │   #204             │
└─────────┴─────────┴─────────┴─────────┴────────────────────┘
```

## How It Works

### 1. Worker Loop (Inside Tmux Pane)
```bash
while true; do
    # Poll Pueue for next job
    job_info=$(pueue status --json | jq -r '.tasks | select(.status == "Queued")')
    
    if [[ -n "$job_info" ]]; then
        job_id=$(echo "$job_info" | jq -r '.id')
        
        # Mark as started in Pueue
        pueue start $job_id
        
        # Execute Claude IN THE TMUX PANE (visible!)
        claude --work-on-subissue $subissue_id
        
        # Update Pueue on completion
        pueue finish $job_id
    fi
    sleep 2
done
```

### 2. Auto-Response System (Preserved!)
```bash
# Monitors tmux pane content, not Pueue output
content=$(tmux capture-pane -t "$pane_id" -p)
if echo "$content" | grep -q "Do you want to proceed?"; then
    tmux send-keys -t "$pane_id" "1" C-m
fi
```

### 3. Best of Both Worlds

| Feature | Pure Pueue | Pure Tmux | Hybrid Approach |
|---------|------------|-----------|-----------------|
| Queue Persistence | ✅ | ❌ | ✅ |
| Dependencies | ✅ | ❌ | ✅ |
| Claude Visibility | ❌ | ✅ | ✅ |
| Auto-Approval | ❌ | ✅ | ✅ |
| Crash Recovery | ✅ | ❌ | ✅ |
| Scalability | ✅ | Limited | ✅ |
| Single View | ❌ | ✅ | ✅ |

## Implementation for Claude Code Parallel

### Phase 1: Core Integration
```bash
# Modified worker loop
create_hybrid_worker() {
    local worker_id=$1
    cat << 'EOF'
#!/bin/bash
WORKER_ID=$1

while true; do
    # Get next subissue from Pueue
    job=$(pueue status --json | jq -r --arg w "$WORKER_ID" '
        .tasks | to_entries[] | 
        select(.value.status == "Queued" and .value.label | startswith("subissue-")) |
        .value | {id, label, command} | @json
    ' | head -1)
    
    if [[ -n "$job" ]]; then
        job_id=$(echo "$job" | jq -r '.id')
        subissue_id=$(echo "$job" | jq -r '.label' | cut -d- -f2)
        
        # Start in Pueue
        pueue start $job_id
        
        # Run Claude in this tmux pane (visible!)
        cd $(git rev-parse --show-toplevel)
        git worktree add "worktrees/subissue-$subissue_id" -b "subissue/$subissue_id"
        cd "worktrees/subissue-$subissue_id"
        
        # This runs IN THE PANE where we can see and auto-approve
        claude /project:work-on-subissue $subissue_id
        
        # Create PR
        gh pr create --title "[Subissue #$subissue_id] ..." 
        
        # Cleanup
        cd ../..
        git worktree remove "worktrees/subissue-$subissue_id"
        
        # Mark complete in Pueue
        pueue finish $job_id
    else
        echo -ne "\r[Worker $WORKER_ID] Waiting... $(date +%H:%M:%S)"
        sleep 2
    fi
done
EOF
}
```

### Phase 2: Queue Migration
```bash
# Convert our file-based queue to Pueue
migrate_to_pueue() {
    # Read existing queue
    while IFS='|' read -r priority parent subissue status worker created; do
        if [[ "$status" == "pending" ]]; then
            # Add to Pueue with priority
            pueue add \
                --priority $priority \
                --label "subissue-$subissue" \
                --group "parent-$parent" \
                "process_subissue $subissue"
        fi
    done < "$QUEUE_FILE"
}
```

### Phase 3: Enhanced Features

1. **Dependency Management**
```bash
# Subissue B depends on A
pueue add --after $job_a --success --label "subissue-202" "..."
```

2. **Intelligent Scheduling**
```bash
# High priority bugs
pueue add --priority 10 --label "subissue-bug-203" "..."

# Scheduled maintenance
pueue add --delay "2h" --label "subissue-cleanup-204" "..."
```

3. **Worker Groups**
```bash
# Frontend workers
pueue group add frontend
pueue parallel 3 --group frontend

# Backend workers  
pueue group add backend
pueue parallel 5 --group backend
```

## Critical Advantages

1. **Maintains Claude Visibility**: Claude runs in tmux panes, not hidden
2. **Preserves Auto-Approval**: Our mechanism still works perfectly
3. **Adds Queue Robustness**: Crash recovery, persistence, dependencies
4. **Unified Monitoring**: Single tmux session shows everything
5. **Advanced Scheduling**: Priority, delays, groups, limits

## Migration Path

### Step 1: Install Pueue (2 hours)
```bash
# Add to install.sh
install_pueue() {
    if ! command -v pueue &> /dev/null; then
        # Install based on OS
        brew install pueue || cargo install pueue
    fi
    
    # Start daemon
    pueued -d
}
```

### Step 2: Adapter Layer (4 hours)
- Create `tools/queue-pueue` adapter
- Implement same interface as current queue
- Gradual migration without breaking changes

### Step 3: Worker Grid (4 hours)
- Implement grid manager with Pueue integration
- Update auto-approve for single session
- Create monitoring dashboard

### Step 4: Enhanced Features (8 hours)
- Add dependency support
- Implement priority scheduling
- Create worker groups
- Add scheduled execution

## Decision

**Recommendation: Implement Hybrid Architecture**

This hybrid approach eliminates all disadvantages while combining all benefits:
- ✅ Claude remains visible and interactive
- ✅ Auto-approval continues working
- ✅ Gain queue persistence and crash recovery
- ✅ Add dependency management
- ✅ Enable advanced scheduling
- ✅ Maintain single session monitoring

## Implementation Effort

- **Total**: 18-24 hours (vs 40+ for pure Pueue)
- **Risk**: Low (adapter pattern allows gradual migration)
- **Benefit**: Massive (professional queue + maintained visibility)

## Consequences

### Positive
- Best of both worlds architecture
- Professional-grade queue management
- Maintains all current features
- Enables new advanced features
- Single session monitoring achieved

### Negative
- Additional dependency (Pueue)
- Slightly more complex than current
- Need to learn Pueue commands

### Mitigations
- Pueue is well-maintained and stable
- Adapter pattern hides complexity
- Can fall back to file queue if needed