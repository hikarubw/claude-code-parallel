# Claude Code Tools Architecture

## 🎯 Philosophy: Claude-First Development

We give Claude simple tools and let its intelligence orchestrate complex workflows.

## 🏗️ Architecture Overview

```
User ← → Claude Code ← → Simple Tools ← → Git/GitHub
          ↑
          |
    Intelligence
    (Claude's Brain)
```

## 📦 Tool Organization

### Consolidated Tools (7 total)

#### 1. `task` - Work Management
Combines queue, approval, and dependency tracking:
- Maintains work queue with priorities
- Tracks approval/rejection decisions  
- Manages blocking relationships
- Single source of truth for work state

#### 2. `session` - Execution Environment
Integrates tmux sessions with git worktrees:
- Creates isolated development environments
- Each issue gets dedicated worktree
- Tracks session assignments
- Handles cleanup automatically

#### 3. `github` - GitHub Integration
Unified interface to GitHub operations:
- Issue management (list, create, label)
- Sub-issue creation and linking
- PR status checking
- Recent activity monitoring

#### 4. `analyze` - Project Intelligence
Provides codebase insights:
- File structure analysis
- Dependency detection
- Project type identification
- Metrics gathering

#### 5. `monitor` - Progress Tracking
Real-time development monitoring:
- Session activity tracking
- Queue status
- Blocking task alerts
- Progress dashboards

#### 6. `maintain` - Environment Health
Keeps development environment clean:
- Worktree cleanup (merged/closed)
- Session management
- Data archival
- Usage reporting

#### 7. `oauth-setup` - Configuration
Special-purpose OAuth setup tool.

## 🎮 Command Structure

### Workflow-Oriented Commands

Commands follow natural development flow:

1. **`/setup`** → Initialize and prepare
2. **`/work`** → Start development
3. **`/status`** → Monitor progress
4. **`/manual`** → Handle human tasks
5. **`/maintain`** → Clean up
6. **`/auto`** → Autonomous operation

Each command maps to a clear action verb and workflow stage.

## 🧠 Intelligence Layer

Claude provides all intelligence:

### Decision Making
- Risk assessment for auto-approval
- Task prioritization
- Dependency resolution
- Resource allocation

### Orchestration
- Tool coordination
- Session management
- Error handling
- Progress monitoring

### Adaptation
- Learning from outcomes
- Adjusting strategies
- Optimizing workflows

## 🔄 Data Flow

### Task Lifecycle
```
GitHub Issue → /setup → Task Queue → /work → Session/Worktree → PR → Completion
                ↓                                    ↓
            Dependencies                        Auto-cleanup
```

### State Management
- `.claude/tasks/` - Work queue and approvals
- `.claude/sessions/` - Session tracking
- `.worktrees/` - Git worktrees
- Tools maintain minimal state files

## 🚀 Key Design Principles

### 1. Simplicity First
Each tool does ONE thing well. Complexity emerges from orchestration, not code.

### 2. Transparency
Tools output clear, parseable text. Claude can always understand tool state.

### 3. Idempotency
Tools can be run multiple times safely. State transitions are explicit.

### 4. Composability
Tools work independently but compose into workflows naturally.

### 5. Claude-Aware
Tools are designed for Claude to orchestrate, not for direct human use.

## 📊 Benefits of This Architecture

### For Users
- Simple mental model
- Clear workflow progression
- Powerful automation
- Easy troubleshooting

### for Developers
- Minimal code to maintain
- Clear responsibilities
- Easy to extend
- Simple testing

### For Claude
- Clear tool boundaries
- Predictable outputs
- Flexible orchestration
- Rich context

## 🔮 Future Extensions

The architecture supports:
- Additional tools as needed
- New workflow patterns
- Integration with more services
- Enhanced intelligence

All without breaking the core simplicity principle.