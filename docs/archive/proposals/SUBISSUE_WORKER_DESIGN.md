# 🚀 Subissue-Based Worker Pool System Design

## 🎯 **Vision**

A simple, powerful system where users provide GitHub issues and the system handles everything else through intelligent parallelization.

```
User: "Work on issues #123, #124, #125 with 10 parallel workers"
System: Creates 15-20 subissues, processes them in parallel, creates PRs, closes parent issues when done
User: Drinks coffee ☕
```

---

## 🏗️ **Architecture Overview**

```
┌─────────────────────────────────────────────────────────────────────┐
│                           CONTROL PLANE                              │
├─────────────────┬──────────────────┬──────────────┬────────────────┤
│ Issue Analyzer  │  Queue Manager   │ Worker Pool  │ Progress Monitor│
│  (Claude AI)    │  (Priority Queue)│ (Tmux Sessions)│ (Dashboard)   │
└─────────────────┴──────────────────┴──────────────┴────────────────┘
                                │
                    ┌───────────┴───────────┐
                    │    DATA PLANE         │
                    ├───────────────────────┤
                    │ • Subissue Queue      │
                    │ • Worker States       │
                    │ • Git Worktrees      │
                    │ • Logs & Metrics     │
                    └───────────────────────┘
```

---

## 📋 **Detailed Component Design**

### **1. Issue Analyzer (Claude-Powered)**

```bash
analyze_issue() {
    local issue_number=$1
    
    # Claude analyzes and creates 2-5 subissues
    claude "Analyze issue #$issue_number and break it into 2-5 concrete subissues. 
            Each subissue should be:
            - Independently implementable
            - Completable in 2-4 hours
            - Have clear acceptance criteria
            - Include relevant context from parent"
}
```

**Subissue Creation Template:**
```markdown
Title: [#123] Implement authentication middleware

**Parent Issue**: #123
**Estimated Hours**: 3
**Priority**: High

## Description
Implement JWT authentication middleware for the API endpoints.

## Acceptance Criteria
- [ ] Middleware validates JWT tokens
- [ ] Returns 401 for invalid tokens
- [ ] Passes user context to handlers
- [ ] Unit tests cover all cases

## Technical Context
- Use existing JWT library in package.json
- Follow pattern from logging middleware
- Store user in request context

---
Automated subissue from parent #123
```

### **2. Queue Manager**

**Queue Operations:**
```bash
# Queue structure: PRIORITY|PARENT|SUBISSUE|STATUS|WORKER|TIMESTAMP

# Add to queue
queue_add() {
    echo "1|123|456|pending||$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> queue.txt
}

# Get next item
queue_next() {
    # Get highest priority pending item
    grep "|pending|" queue.txt | sort -n | head -1
}

# Update status
queue_update() {
    local subissue=$1
    local status=$2
    local worker=$3
    # Update in place
}
```

**Priority Levels:**
1. 🔴 **Critical** - Bugs, security issues
2. 🟡 **High** - Core features
3. 🟢 **Normal** - Enhancements
4. 🔵 **Low** - Documentation, refactoring

### **3. Worker Pool Manager**

```bash
#!/bin/bash
# Worker pool implementation

start_workers() {
    local count=$1
    
    for i in $(seq 1 $count); do
        tmux new-session -d -s "worker-$i" \
            "while true; do 
                ./worker-loop.sh $i
                sleep 5
             done"
    done
}

worker_loop() {
    local worker_id=$1
    
    # Get next subissue
    local subissue=$(queue_next)
    if [ -z "$subissue" ]; then
        log "Worker $worker_id: Queue empty, idling..."
        return
    fi
    
    # Extract details
    local subissue_id=$(echo $subissue | cut -d'|' -f3)
    
    # Claim the work
    queue_update $subissue_id "working" "worker-$worker_id"
    
    # Create worktree
    local branch="subissue/$subissue_id"
    git worktree add "worktrees/$subissue_id" -b "$branch"
    
    # Work on it
    cd "worktrees/$subissue_id"
    claude "/work-on-subissue $subissue_id"
    
    # Create PR
    gh pr create --title "[Subissue] $(gh issue view $subissue_id --json title -q .title)" \
                 --body "Closes #$subissue_id\nPart of #$parent_issue"
    
    # Cleanup
    cd ../..
    git worktree remove "worktrees/$subissue_id"
    
    # Mark complete
    queue_update $subissue_id "completed" "worker-$worker_id"
}
```

### **4. Progress Monitor**

```bash
show_progress() {
    clear
    echo "🚀 WORKER POOL STATUS"
    echo "===================="
    
    # Worker status
    echo -e "\n👷 Workers:"
    for i in $(tmux ls | grep "^worker-" | cut -d: -f1); do
        local status=$(tmux capture-pane -t $i -p | tail -1)
        echo "$i: $status"
    done
    
    # Queue status
    local pending=$(grep -c "|pending|" queue.txt)
    local working=$(grep -c "|working|" queue.txt)
    local completed=$(grep -c "|completed|" queue.txt)
    
    echo -e "\n📊 Queue:"
    echo "Pending: $pending | Working: $working | Completed: $completed"
    
    # Parent issue progress
    echo -e "\n📋 Parent Issues:"
    for parent in $(cut -d'|' -f2 queue.txt | sort -u); do
        local total=$(grep -c "|$parent|" queue.txt)
        local done=$(grep -c "|$parent|.*|completed|" queue.txt)
        echo "#$parent: $done/$total subissues complete"
    done
}
```

---

## 🎮 **Command Interface**

### **Primary Commands**

```bash
# Start work on issues
/project:work ISSUES WORKERS [OPTIONS]

# Examples:
/project:work 123 4                    # Work on issue 123 with 4 workers
/project:work 123,124,125 10          # Multiple issues, 10 workers
/project:work 123 4 --priority=high   # Set priority for all subissues

# Add more work
/project:add ISSUES [OPTIONS]
/project:add 126,127                   # Add to existing queue

# Monitor
/project:status                        # Show dashboard
/project:status --watch               # Live updates

# Control
/project:pause                        # Pause all workers
/project:resume                       # Resume work
/project:stop                         # Graceful shutdown
```

### **Advanced Commands**

```bash
# Worker management
/project:workers add 5                # Add 5 more workers
/project:workers remove 3             # Remove 3 workers
/project:workers list                 # Show all workers

# Queue management  
/project:queue show                   # Display queue
/project:queue priority 456 high      # Change priority
/project:queue retry 789              # Retry failed subissue

# Debugging
/project:logs worker-3                # Show worker logs
/project:debug 456                    # Debug specific subissue
```

---

## 💡 **Key Improvements Over Original Design**

### **1. Intelligent Subissue Generation**
- Claude analyzes issue complexity
- Creates right-sized work units
- Adds technical context
- Estimates time accurately

### **2. Smart Queue Management**
- Priority-based processing
- Automatic retry for failures
- Queue persistence across restarts
- Real-time reordering

### **3. Worker Health Monitoring**
```bash
health_check() {
    local worker=$1
    local last_activity=$(get_last_activity $worker)
    local now=$(date +%s)
    local idle_time=$((now - last_activity))
    
    if [ $idle_time -gt 1800 ]; then  # 30 minutes
        restart_worker $worker
    fi
}
```

### **4. Progressive PR Strategy**
- Each subissue gets its own PR
- PRs reference parent issue
- Auto-close parent when all subissues merged
- Clean PR descriptions with context

### **5. Resume Capability**
```bash
resume_work() {
    # Load saved state
    source .claude/workers/state.json
    
    # Restart workers at last count
    start_workers $LAST_WORKER_COUNT
    
    # Workers automatically pick up from queue
    echo "Resumed with $LAST_WORKER_COUNT workers"
}
```

---

## 🔧 **Implementation Example**

```bash
# User starts work
$ /project:work 123,124 8

🤖 Analyzing issues...
✓ Issue #123: Found 4 logical subissues
✓ Issue #124: Found 3 logical subissues

📋 Creating subissues...
✓ Created #201: [#123] Implement user model
✓ Created #202: [#123] Add authentication endpoints
✓ Created #203: [#123] Create login UI
✓ Created #204: [#123] Add test coverage
✓ Created #205: [#124] Design API schema
✓ Created #206: [#124] Implement REST endpoints
✓ Created #207: [#124] Add OpenAPI documentation

🚀 Starting 8 workers...
✓ worker-1: Working on #201
✓ worker-2: Working on #202
✓ worker-3: Working on #203
✓ worker-4: Working on #204
✓ worker-5: Working on #205
✓ worker-6: Working on #206
✓ worker-7: Working on #207
✓ worker-8: Idle (waiting for work)

📊 Progress: 0/7 complete
```

---

## 📈 **Monitoring Dashboard**

```
┌─────────────────────────────────────────────────┐
│          WORKER POOL DASHBOARD                   │
├─────────────────────────────────────────────────┤
│ Time: 2024-12-05 14:30:45 | Uptime: 2h 15m     │
├─────────────────────────────────────────────────┤
│ WORKERS (8/8 active)                            │
│ ├─ worker-1: PR #208 created                    │
│ ├─ worker-2: Working on #202 (45m)             │
│ ├─ worker-3: Working on #203 (12m)             │
│ ├─ worker-4: Idle                              │
│ ├─ worker-5: Working on #205 (23m)             │
│ ├─ worker-6: PR #209 in review                 │
│ ├─ worker-7: Cloning worktree                  │
│ └─ worker-8: Working on #210 (5m)              │
├─────────────────────────────────────────────────┤
│ QUEUE STATUS                                    │
│ Pending: 2 | Working: 5 | Complete: 3          │
├─────────────────────────────────────────────────┤
│ PARENT ISSUES                                   │
│ #123: ████████░░ 75% (3/4 subissues)          │
│ #124: ███░░░░░░░ 33% (1/3 subissues)          │
├─────────────────────────────────────────────────┤
│ THROUGHPUT                                      │
│ Last hour: 4 PRs | Today: 15 PRs | Avg: 22m   │
└─────────────────────────────────────────────────┘
```

---

## 🚨 **Error Handling**

### **Graceful Degradation**
1. Worker crashes → Automatic restart
2. Subissue fails → Move to retry queue
3. API rate limit → Backoff and retry
4. Network issues → Local queue persistence

### **Recovery Procedures**
```bash
# Recover from crash
./tools/worker recover

# Rebuild queue from GitHub
./tools/queue rebuild

# Force retry all failed
./tools/queue retry-all
```

---

## ✨ **Future Enhancements**

1. **Machine Learning**
   - Learn optimal subissue sizing
   - Predict completion times
   - Auto-adjust worker count

2. **Distributed Mode**
   - Run workers on multiple machines
   - Central queue server
   - Load balancing

3. **Integration Ecosystem**
   - Slack notifications
   - Metrics to Datadog/Grafana
   - Custom webhooks

---

## 🎯 **Success Metrics**

- **Throughput**: PRs/hour per worker
- **Quality**: PR approval rate
- **Efficiency**: Idle time percentage
- **Reliability**: Crash recovery time

**Target Performance**:
- 2-3 PRs/hour/worker
- <5% idle time
- 95% PR approval rate
- <2 min recovery time

---

## 🔑 **Key Benefits**

1. **Simple Mental Model**: Issues → Subissues → PRs
2. **Fully Autonomous**: Single command starts everything
3. **Intelligent**: Claude analyzes and optimizes
4. **Scalable**: Add/remove workers dynamically
5. **Resilient**: Handles failures gracefully
6. **Observable**: Clear progress visibility

This design provides a clean, powerful system for parallel development with minimal user interaction! 🚀