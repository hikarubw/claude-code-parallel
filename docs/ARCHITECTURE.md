# 🏗️ Claude Code Tools Architecture v0.3.0 (Experimental)

## Overview

Claude Code Tools extends [Claude Code](https://claude.ai/code) with parallel development capabilities using a **Subissue-Based Worker Pool** architecture.

## Core Architecture: Subissue-Based Worker Pool

```
User Issues → Claude Analysis → Priority Queue → Worker Pool → PRs → Auto-close
    #123      Creates 3-5       Subissues      Tmux         GitHub   Parent
    #124      subissues         ordered        Sessions     PRs      Issues
```

### Key Principles

1. **Simple Interface** - Users just specify issues: `/project:work 123,124 8`
2. **Intelligent Decomposition** - Claude analyzes and creates optimal subissues
3. **Autonomous Workers** - Tmux sessions process queue independently
4. **Natural GitHub Flow** - Subissues → PRs → Auto-close parents

### Components

#### 1. Issue Analyzer (`/tools/analyze`)
- Uses Claude to understand issue requirements
- Creates 2-5 concrete, independent subissues
- Estimates complexity and assigns priorities

#### 2. Priority Queue (`/tools/queue`)
- Manages subissues with priority ordering
- Tracks status: pending → working → completed
- Persists state for resume capability

#### 3. Worker Pool (`/tools/worker`)
- Spawns tmux sessions as autonomous workers
- Each worker: fetch → work → PR → cleanup → repeat
- Health monitoring and auto-recovery

#### 4. User Commands (`/commands/`)
- `/project:work` - Start parallel development
- `/project:status` - Monitor progress
- `/project:add` - Add more issues
- `/project:stop` - Graceful shutdown
- `/project:resume` - Continue from saved state

## Why This Architecture?

### Previous Approaches
1. **v1.0 Issue-Based** - Too coarse, poor parallelism
2. **v2.0 Task-Based** - Complex checklist management

### v3.0 Advantages
- **Natural decomposition** - Issues → Subissues (GitHub native)
- **Simple mental model** - Queue + Workers
- **Fully autonomous** - No manual task creation
- **Resilient** - Automatic recovery and resume
- **Scalable** - Add/remove workers dynamically

## Implementation Details

### Queue Format
```
PRIORITY|PARENT_ISSUE|SUBISSUE_ID|STATUS|WORKER|TIMESTAMP
1|123|456|working|worker-2|2024-12-05T10:00:00Z
```

### Worker Lifecycle
1. Poll queue for next item
2. Create isolated worktree
3. Run Claude on subissue
4. Create PR when complete
5. Clean up and repeat

### State Management
- Queue persisted to `~/.claude/workers/queue.txt`
- Worker logs in `~/.claude/workers/logs/`
- Resume state in `~/.claude/workers/state.json`

## Getting Started

```bash
# Install
./install.sh

# Start work on issues
/project:work 123,124 8

# Monitor progress
/project:status --watch

# Add more work
/project:add 125,126

# Stop when done
/project:stop
```

## Integration with Claude Code

This architecture leverages Claude Code's strengths:
- **Context understanding** - Claude grasps entire codebases
- **Autonomous operation** - Works without approval prompts
- **Git expertise** - Creates proper commits and PRs
- **Extended thinking** - Handles complex architectural decisions

See [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code) for more details.