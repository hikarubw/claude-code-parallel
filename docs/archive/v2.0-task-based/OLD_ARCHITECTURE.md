# Claude Code Parallel Architecture

## 🎯 Philosophy: Claude-First Development

We give Claude simple tools and let its intelligence orchestrate complex workflows.

## 🏗️ System Architecture

```
Claude Code (Intelligence)
    ↓
Slash Commands (Orchestration)
    ↓
Simple Tools (Execution)
    ↓
Parallel Sessions (tmux)
    ↓
Isolated Worktrees (Git)
```

## 📊 Architecture Decision Matrix

| Architecture | Complexity | Autonomy | Scalability | GitHub Integration | Implementation Time |
|--------------|------------|----------|-------------|-------------------|-------------------|
| **Issue-Based** | Low | Medium | Limited | Natural | Existing |
| **Task-Based** ✓ | Medium | High | Good | Excellent | 3 weeks (~40 hours) |
| **Dependency Graph** | Very High | Very High | Excellent | Complex | 8-12 weeks |
| **Emergent Swarm** | Extreme | Complete | Unlimited | Difficult | 16+ weeks |

**Decision**: Task-based architecture provides the best balance of simplicity and power for immediate needs, allowing issues to contain task checklists where each checkbox becomes a parallel work unit.

## 🔑 Core Principles

1. **Simple Tools**: Each tool does ONE thing well (~50-200 lines)
2. **Claude Intelligence**: Complex logic lives in Claude's interpretation
3. **Worktree Isolation**: Each task works in an isolated environment
4. **Autonomous Operation**: Permissive settings reduce interruptions by 90%

## 📦 Core Tools

### 1. `task` - Work Queue Management
```bash
task add ISSUE [PRIORITY]      # Add to queue
task next                      # Get unblocked task
task block BLOCKER BLOCKED     # Track dependencies
task approve/reject ISSUE      # Record decisions
```
- File-based queue (`.claude/tasks/queue`)
- Simple dependency tracking
- No complex logic - just data management

### 2. `session` - Parallel Execution
```bash
session start [N]              # Start N tmux sessions
session assign ID ISSUE        # Assign work with worktree
session stop [ID|all]          # Clean up
```
- Each session gets isolated worktree
- Automatic branch creation (feature/, bugfix/, etc.)
- Applies autonomous settings automatically

### 3. `github` - GitHub Integration
```bash
github split ISSUE             # Break into sub-tasks
github pr ISSUE                # Create pull request
github issues [--my-work]      # List issues
```
- Wraps GitHub CLI (`gh`)
- Handles issue labeling
- Manages PR lifecycle

### 4. `maintain` - Cleanup & Maintenance
```bash
maintain [what]                # Smart cleanup
maintain worktrees             # Remove completed
maintain sessions              # Stop idle sessions
```
- Prevents resource accumulation
- Automatic detection of completed work

### 5. `setup-autonomous` - Permission Management
```bash
setup-autonomous init          # Create settings template
setup-autonomous apply PATH    # Apply to worktree
setup-autonomous check         # Verify configuration
```
- Enables autonomous operation
- Manages worktree-specific settings

## 🧠 Intelligence Layer (Claude)

### Commands as Documentation
Each command file teaches Claude:
```markdown
# commands/work.md
## What I'll Do
1. Get next task from queue
2. Check dependencies
3. Create worktree
4. Apply autonomous settings
5. Assign to session
```

### Decision Making
Claude decides:
- Which branch name to use (feature/, bugfix/, docs/)
- Whether an issue needs a branch
- How to break down complex issues
- When to create PRs

### Error Recovery
Claude handles:
- Failed sessions
- Merge conflicts
- Test failures
- Build issues

## 🔐 Security Model

### Worktree Isolation
```
main (protected)
├── feature/101-oauth (autonomous)
├── bugfix/102-error (autonomous)
└── docs/103-guide (autonomous)
```

### Permission Boundaries
- **In Main Branch**: Restrictive permissions
- **In Worktrees**: Permissive permissions
- **PR Gateway**: All merges reviewed

### Autonomous but Safe
- Can't push to main
- Can't delete important files
- Can't access production
- All changes traceable

## 📊 Data Flow

### Task Lifecycle
```
GitHub Issue
    ↓
Task Queue (task add)
    ↓
Dependency Check (task next)
    ↓
Worktree Creation (session assign)
    ↓
Autonomous Work (in worktree)
    ↓
PR Creation (github pr)
    ↓
Review & Merge (human)
```

### Parallel Execution
```
Main Claude Instance
├── Session 1 → Worktree 1 → feature/101
├── Session 2 → Worktree 2 → bugfix/102
├── Session 3 → Worktree 3 → feature/103
├── Session 4 → Worktree 4 → docs/104
└── Session 5 → Worktree 5 → refactor/105
```

## 🚀 Performance Characteristics

### Scalability
- **Comfortable**: 5-10 parallel sessions
- **Possible**: 20-30 with optimization
- **Bottlenecks**: Disk I/O, tmux limits

### Efficiency
- Task assignment: ~2 seconds
- Worktree creation: ~5 seconds
- Autonomous operation: No delays
- PR creation: ~3 seconds

## 🔄 Extension Points

### Adding New Tools
1. Create simple bash script (<200 lines)
2. One clear purpose
3. No embedded intelligence
4. Clear output format

### Adding New Commands
1. Create markdown documentation
2. Describe workflow steps
3. Reference tools to use
4. Let Claude interpret

## 🌟 Why This Works

1. **Simplicity**: Easy to understand and modify
2. **Flexibility**: Claude adapts to any workflow  
3. **Reliability**: Simple tools rarely break
4. **Autonomy**: Isolation enables freedom
5. **Scalability**: Parallel by design

The architecture embodies the principle: **Simple tools + Intelligent orchestration + Safe isolation = Powerful automation**