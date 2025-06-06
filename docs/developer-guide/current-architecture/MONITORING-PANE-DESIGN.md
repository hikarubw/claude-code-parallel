# Monitoring Pane Design for Single Tmux Session

## Visual Layout

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          CLAUDE WORKERS MONITOR                          │
├─────────────────────────────────────────────────────────────────────────┤
│ Time: 14:32:15 | Workers: 8/8 | Queue: 12 | Active: 5 | Complete: 47  │
├─────────────────────────────────────────────────────────────────────────┤
│ WORKER STATUS                           │ QUEUE OVERVIEW                 │
│ ┌─────────────────────────────────────┐ │ ┌─────────────────────────────┐│
│ │ W1: ✓ #201 PR created      [45m]   │ │ │ Priority 1: ████░░ 3/5     ││
│ │ W2: ⚡ #202 Running tests   [12m]   │ │ │ Priority 2: ██████ 7/7     ││
│ │ W3: ⚡ #203 Writing code    [8m]    │ │ │ Priority 3: ░░░░░░ 0/4     ││
│ │ W4: ◷ Idle - queue empty           │ │ │ Priority 4: ██░░░░ 2/6     ││
│ │ W5: ⚡ #205 Creating PR     [22m]   │ │ └─────────────────────────────┘│
│ │ W6: ✗ #206 Failed - retry  [5m]    │ │                                │
│ │ W7: ⚡ #207 Analyzing issue [3m]    │ │ PERFORMANCE                    │
│ │ W8: ◷ Starting #208               │ │ ┌─────────────────────────────┐│
│ └─────────────────────────────────────┘ │ │ Throughput: 3.2 PR/hour     ││
│                                         │ │ Avg Time:   18 min/task     ││
│ RECENT ACTIVITY                         │ │ Success:    94%             ││
│ ┌─────────────────────────────────────┐ │ │ CPU Usage:  45%             ││
│ │ 14:31:02 W1 Created PR #142        │ │ │ Memory:     2.3 GB          ││
│ │ 14:30:45 W3 Passed all tests       │ │ └─────────────────────────────┘│
│ │ 14:28:33 W6 Error: test failure    │ │                                │
│ │ 14:27:12 W2 Started tests          │ │ ALERTS                         │
│ │ 14:25:55 W5 Committed changes      │ │ ┌─────────────────────────────┐│
│ └─────────────────────────────────────┘ │ │ ⚠ W6: Retry after failure   ││
├─────────────────────────────────────────┴─┴─────────────────────────────┘│
│ [Q]ueue [W]orker-logs [P]erformance [H]elp | Auto-refresh: ON          │
└─────────────────────────────────────────────────────────────────────────┘
```

## Implementation Code

```bash
#!/bin/bash
# monitoring-pane.sh - Live dashboard for worker monitoring

# Colors and symbols
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Unicode symbols
RUNNING="⚡"
COMPLETE="✓"
FAILED="✗"
IDLE="◷"

# Get terminal dimensions
COLS=$(tput cols)
LINES=$(tput lines)

# Dashboard components
draw_header() {
    local time=$(date +%H:%M:%S)
    local total_workers=$(tmux list-panes -t claude-workers -F '#{pane_id}' | wc -l)
    local active_workers=$((total_workers - 1))  # Minus monitor pane
    local queue_size=$(queue status | grep "Pending:" | awk '{print $2}')
    local active=$(queue status | grep "Working:" | awk '{print $2}')
    local complete=$(queue status | grep "Completed:" | awk '{print $2}')
    
    printf "${BLUE}Time: %s | Workers: %d/%d | Queue: %d | Active: %d | Complete: %d${NC}\n" \
        "$time" "$active_workers" "$active_workers" "$queue_size" "$active" "$complete"
}

draw_worker_status() {
    echo "WORKER STATUS"
    echo "┌─────────────────────────────────────┐"
    
    for i in $(seq 1 8); do
        local worker_info=$(get_worker_status $i)
        printf "│ W%d: %-30s │\n" "$i" "$worker_info"
    done
    
    echo "└─────────────────────────────────────┘"
}

get_worker_status() {
    local worker_id=$1
    local log_tail=$(tail -1 "$HOME/.claude/workers/logs/worker-${worker_id}.log" 2>/dev/null)
    
    if [[ -z "$log_tail" ]]; then
        echo "$IDLE Offline"
        return
    fi
    
    # Parse log for status
    if [[ "$log_tail" =~ "Queue empty" ]]; then
        echo "$IDLE Idle - queue empty"
    elif [[ "$log_tail" =~ "Processing subissue #([0-9]+)" ]]; then
        local issue="${BASH_REMATCH[1]}"
        local duration=$(get_task_duration $worker_id)
        echo "$RUNNING #$issue $(get_task_stage $worker_id) [$duration]"
    elif [[ "$log_tail" =~ "Created PR" ]]; then
        local issue=$(get_last_issue $worker_id)
        echo "$COMPLETE #$issue PR created"
    elif [[ "$log_tail" =~ "Failed" ]]; then
        local issue=$(get_last_issue $worker_id)
        echo "$FAILED #$issue Failed - retry"
    fi
}

draw_queue_overview() {
    echo "QUEUE OVERVIEW"
    echo "┌─────────────────────────────┐"
    
    # Get queue statistics by priority
    for priority in 1 2 3 4; do
        local total=$(queue status | grep -c "^$priority|.*|pending")
        local working=$(queue status | grep -c "^$priority|.*|working")
        local progress=$(calculate_progress $working $total)
        printf "│ Priority %d: %-15s │\n" "$priority" "$progress"
    done
    
    echo "└─────────────────────────────┘"
}

draw_performance_metrics() {
    echo "PERFORMANCE"
    echo "┌─────────────────────────────┐"
    
    local throughput=$(calculate_throughput)
    local avg_time=$(calculate_avg_time)
    local success_rate=$(calculate_success_rate)
    local cpu=$(ps aux | awk '{sum+=$3} END {print sum}')
    local mem=$(free -h | awk '/^Mem:/ {print $3}')
    
    printf "│ Throughput: %-15s │\n" "$throughput PR/hour"
    printf "│ Avg Time:   %-15s │\n" "$avg_time min/task"
    printf "│ Success:    %-15s │\n" "$success_rate%"
    printf "│ CPU Usage:  %-15s │\n" "$cpu%"
    printf "│ Memory:     %-15s │\n" "$mem"
    
    echo "└─────────────────────────────┘"
}

# Main dashboard loop
main_dashboard() {
    while true; do
        clear
        
        # Header
        echo "┌─────────────────────────────────────────────────────────────────────────┐"
        echo "│                          CLAUDE WORKERS MONITOR                          │"
        echo "├─────────────────────────────────────────────────────────────────────────┤"
        printf "│ %-71s │\n" "$(draw_header)"
        echo "├─────────────────────────────────────────────────────────────────────────┤"
        
        # Two column layout
        paste <(draw_worker_status) <(draw_queue_overview) | column -t -s $'\t'
        
        # Activity log
        echo ""
        echo "RECENT ACTIVITY"
        echo "┌─────────────────────────────────────┐"
        tail -5 "$HOME/.claude/workers/activity.log" | while read line; do
            printf "│ %-37s │\n" "$line"
        done
        echo "└─────────────────────────────────────┘"
        
        # Footer
        echo "[Q]ueue [W]orker-logs [P]erformance [H]elp | Auto-refresh: ON"
        
        sleep 1
    done
}

# Interactive commands
handle_keypress() {
    read -n 1 -t 1 key
    case $key in
        q|Q) show_queue_details ;;
        w|W) show_worker_logs ;;
        p|P) show_performance_details ;;
        h|H) show_help ;;
    esac
}

# Run dashboard
main_dashboard
```

## Integration with Current System

To integrate this monitoring with our current multi-session approach:

```bash
#!/bin/bash
# tools/monitor - Unified monitoring for multi-session architecture

start_monitor() {
    # Create dedicated monitoring session
    tmux new-session -d -s claude-monitor
    
    # Main monitoring pane
    tmux send-keys -t claude-monitor:0 './tools/monitoring-pane.sh' C-m
    
    # Split for log aggregation
    tmux split-window -h -t claude-monitor
    tmux send-keys -t claude-monitor:0.1 'tail -f ~/.claude/workers/logs/*.log | ccze -A' C-m
    
    # Bottom pane for interactive commands
    tmux split-window -v -t claude-monitor
    tmux resize-pane -t claude-monitor:0.2 -y 5
    
    echo "Monitor started. Attach with: tmux attach -t claude-monitor"
}

# Alternative: Floating popup monitor
popup_monitor() {
    tmux display-popup -E -w 80% -h 80% \
        -T "Worker Monitor" \
        './tools/monitoring-pane.sh'
}
```

## Key Features

1. **Real-time Updates**: Refreshes every second
2. **Worker States**: Visual indicators (⚡✓✗◷)
3. **Queue Overview**: Priority-based progress bars
4. **Performance Metrics**: Throughput, success rate
5. **Activity Log**: Recent events
6. **Interactive**: Keyboard shortcuts for details

## Benefits Over Pueue Status

- **Visual**: Designed for terminal display vs text output
- **Integrated**: Shows our specific metrics
- **Real-time**: Live updates vs polling
- **Contextual**: Understands Claude's workflow stages