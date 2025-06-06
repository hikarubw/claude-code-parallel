# 🏗️ Claude Code Parallel Architecture v0.3.0-experimental (Hybrid)

## Overview

Claude Code Parallel extends [Claude Code](https://claude.ai/code) with parallel development capabilities using a **Hybrid Pueue+Tmux Architecture** (ADR-003).

## Core Architecture: Hybrid Pueue+Tmux

```
User Issues → Claude Analysis → Pueue Queue → Pueue Tasks → Tmux Sessions → PRs
    #123      Creates 3-5       Managed by     Spawns       Claude Code    GitHub
    #124      subissues         Pueue daemon   workers      instances      Auto-close
```

### Key Principles

1. **Simple Interface** - Users just specify issues: `/project:work 123,124 8`
2. **Intelligent Decomposition** - Claude analyzes and creates optimal subissues
3. **Robust Queue** - Pueue manages tasks with persistence and recovery
4. **Autonomous Workers** - Tmux sessions spawned by Pueue process tasks
5. **Natural GitHub Flow** - Subissues → PRs → Auto-close parents

### Components

#### 1. Issue Analyzer (`/tools/analyze`)
- Uses Claude to understand issue requirements
- Creates 2-5 concrete, independent subissues
- Estimates complexity and assigns priorities

#### 2. Pueue Queue Manager
- **Pueue Daemon** - System-level task queue
- **Task Management** - Add, pause, resume, retry tasks
- **Persistence** - Survives crashes and reboots
- **Groups** - Organize workers by project/type

#### 3. Worker Orchestrator (`/tools/worker`)
- Creates Pueue tasks that spawn tmux sessions
- Each task runs: setup → tmux → Claude → PR → cleanup
- Automatic retry on failure via Pueue
- Health monitoring through Pueue status

#### 4. User Commands (`/commands/`)
- `/project:work` - Start parallel development
- `/project:status` - Monitor Pueue queue and workers
- `/project:add` - Add more issues to queue
- `/project:stop` - Graceful shutdown via Pueue
- `/project:resume` - Automatic via Pueue persistence

## Why This Architecture?

### Previous Approaches
1. **v1.0 Issue-Based** - Too coarse, poor parallelism
2. **v2.0 Task-Based** - Complex checklist management
3. **v2.5 File-Based Queue** - Fragile, manual recovery

### v3.0 Hybrid Advantages
- **Rock-solid reliability** - Pueue handles crashes gracefully
- **Natural decomposition** - Issues → Subissues (GitHub native)
- **Simple mental model** - Pueue queue + Tmux workers
- **Zero data loss** - Persistent queue survives reboots
- **Native operations** - Pause, resume, retry built-in
- **Scalable** - Pueue groups for multi-project work

## Implementation Details

### Pueue Integration
```bash
# Worker task in Pueue
pueue add --group workers --label "worker-1-issue-456" \
  "tmux new-session -d -s worker-1 'claude-code /path/to/repo'"
```

### Worker Lifecycle
1. Pueue spawns task with tmux command
2. Tmux session runs Claude Code
3. Worker creates isolated worktree
4. Processes subissue and creates PR
5. Task completes, Pueue marks as done
6. Next task automatically starts

### State Management
- **Queue State** - Managed by Pueue daemon
- **Task Logs** - `pueue log <task-id>`
- **Worker Output** - Tmux session logs
- **Persistence** - Pueue database at `~/.local/share/pueue/`

## Getting Started

```bash
# Install (includes Pueue setup)
./install.sh

# Start Pueue daemon
pueued -d

# Start work on issues
/project:work 123,124 8

# Monitor progress
/project:status --watch

# Check Pueue directly
pueue status

# Add more work
/project:add 125,126

# Stop when done
/project:stop
```

## Integration with Claude Code

This hybrid architecture leverages:
- **Pueue's reliability** - Industrial-grade task queue
- **Claude's intelligence** - AI-driven development
- **Tmux compatibility** - Works with Claude Code's requirements
- **GitHub integration** - Natural issue/PR workflow

### Future: Pueue-TUI Extraction (ADR-004)
We plan to extract the queue orchestration logic into an independent tool called Pueue-TUI, which will:
- Support multiple queue backends
- Provide a unified interface
- Enable easier testing and maintenance

See [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code) for more details.