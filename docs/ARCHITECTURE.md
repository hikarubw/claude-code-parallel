# Claude Code Parallel Architecture v0.3.0

## Overview

Claude Code Parallel extends [Claude Code](https://claude.ai/code) with parallel development capabilities using a **Hybrid Pueue+Tmux Architecture**.

## Core Architecture: Hybrid Pueue+Tmux

```
User Issues → Claude Analysis → Pueue Queue → Tmux Workers → Pull Requests
    #123      Creates 3-5       Priority       Visible       GitHub
    #124      subissues         Queue          Sessions      Auto-close
```

### Why Hybrid?

1. **Pueue**: Professional queue management, persistence, crash recovery
2. **Tmux**: Claude Code compatibility, visual debugging, monitoring
3. **Best of Both**: Robust backend + Visible frontend

## System Components

### 1. Issue Analyzer (`/tools/analyze`)
- Uses Claude to decompose issues into 2-5 subissues
- Creates concrete, independent work items
- Assigns priorities based on complexity

### 2. Queue Manager (`/tools/queue-pueue`)
- Interfaces with Pueue daemon
- Manages task priorities and dependencies
- Handles worker assignment

### 3. Hybrid Workers (`/tools/hybrid-worker`)
- Run inside tmux panes for visibility
- Poll Pueue for tasks
- Execute Claude Code with `/work-on` commands
- Create PRs automatically

### 4. Monitoring (`/tools/worker-monitor`)
- Unified dashboard showing queue and worker status
- Real-time health monitoring
- Error detection and recovery

### 5. Setup (`/tools/setup-hybrid`)
- One-command initialization
- Configures Pueue groups and settings
- Creates tmux session structure

## Key Features

### Automatic Recovery
- Pueue restarts failed tasks
- Workers auto-reconnect
- No lost work on crashes

### Priority Management
- User priorities (1-4) map to Pueue priorities (9-6)
- Higher priority tasks processed first
- Smart queue reordering

### Autonomous Operation
- 99% unattended execution
- Auto-approval for common prompts
- Self-healing workers

## Usage Flow

1. **Start System**: `./start-parallel.sh work 123,124 4`
2. **Claude Analyzes**: Creates subissues automatically
3. **Queue Fills**: Subissues added to Pueue
4. **Workers Process**: Visible in tmux panes
5. **PRs Created**: Linked to parent issues
6. **Auto-Close**: Parents close when all subissues complete

## Technical Details

### Pueue Configuration
- Group: `subissues` (isolated queue)
- Parallel tasks: Configurable (default 4)
- Restart on failure: Enabled
- Status socket: For real-time monitoring

### Tmux Layout
- Session: `claude-workers`
- Monitor: Pane 0 (status dashboard)
- Workers: Panes 1-N (Claude instances)
- Grid layout: Automatic adjustment

### Git Workflow
- Worktrees: Isolated development
- Branches: `subissue/PARENT-SUBISSUE`
- Commits: Automated with context
- PRs: Created via GitHub CLI

## Architecture Evolution

### v0.1.0 (Original)
- Direct issue parallelism
- Manual orchestration

### v0.2.0 (Task-Based) 
- Checklist decomposition
- Complex ID system

### v0.3.0 (Current)
- Hybrid Pueue+Tmux
- Automatic recovery
- Production-ready

### Future (v0.4.0)
- Extract Pueue-TUI
- Multi-backend support
- Distributed workers

## Design Decisions

See Architecture Decision Records:
- [ADR-001](adr/ADR-001-SUBISSUE-WORKER-ARCHITECTURE.md): Subissue-based parallelism
- [ADR-002](adr/ADR-002-SINGLE-TMUX-VS-PUEUE.md): Pueue evaluation
- [ADR-003](adr/ADR-003-HYBRID-PUEUE-TMUX.md): Hybrid architecture
- [ADR-004](adr/ADR-004-PUEUE-NATIVE-AND-PUEUE-TUI.md): Future Pueue-TUI extraction