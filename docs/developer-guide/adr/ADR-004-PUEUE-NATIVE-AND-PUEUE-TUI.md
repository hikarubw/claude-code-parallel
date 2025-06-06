# Architecture Decision Record: Native Pueue + Independent Visualization Tool

**ADR-004** | **Status**: Proposed | **Date**: 2024-12-05

## Context

Following the hybrid architecture breakthrough (ADR-003), a deeper insight emerged:

1. **Complete Pueue adoption**: Replace our file-based queue entirely with Pueue
2. **Extract visualization**: Create an independent, publishable tool for Pueue+Tmux visualization
3. **Use as core engine**: Claude Code Parallel becomes a consumer of this general-purpose tool

## The Vision: "Pueue-TUI" - Tmux Visualization for Pueue

### What is Pueue-TUI?

An independent, open-source tool that provides:
- **Tmux-based visualization** for any Pueue queue
- **Live monitoring dashboards** in terminal
- **Worker pool management** with visual feedback
- **Auto-response capabilities** for interactive commands
- **Not specific to Claude** - works with any command

### Architecture Evolution

```
Current (Hybrid):
┌─────────────────────┐
│ Claude Code Parallel   │
├─────────────────────┤
│ File Queue │ Pueue  │ ← Dual system complexity
├─────────────────────┤
│ Hybrid Workers      │
└─────────────────────┘

Proposed (Native + Pueue-TUI):
┌─────────────────────┐
│ Claude Code Parallel   │ ← Pure Claude logic
├─────────────────────┤
│    Uses Pueue-TUI ↓     │
└─────────────────────┘

┌─────────────────────┐
│   Pueue-TUI (NPM/Gem)   │ ← Independent package
├─────────────────────┤
│ Tmux Visualization  │
│ Worker Management   │
│ Auto-responses      │
├─────────────────────┤
│   Pueue Daemon ↓    │
└─────────────────────┘
```

## Pueue-TUI Design

### Core Features

1. **Visual Worker Pools**
```bash
# Start visual workers for any Pueue group
pueue-tui start --group compile --workers 4
pueue-tui start --group test --workers 8

# Creates tmux sessions with live workers
```

2. **Dashboard Monitoring**
```bash
# Rich TUI dashboard
pueue-tui monitor

# Shows:
# - Queue status with progress bars
# - Worker activity in real-time
# - Performance metrics
# - Task dependencies graph
```

3. **Auto-Response System**
```yaml
# .pueue-tui.yml
auto_responses:
  - match: "Continue? [y/N]"
    response: "y"
  - match: "Overwrite?"
    response: "yes"
```

4. **Flexible Visualization**
```bash
# Different layouts
pueue-tui start --layout grid    # N×M grid
pueue-tui start --layout stack   # Vertical stack
pueue-tui start --layout focus   # 1 main + N small

# Attach to specific worker
pueue-tui attach worker-3
```

### Why This Is Revolutionary

1. **Solves General Problem**: Many people use Pueue but lack visibility
2. **First of Its Kind**: No existing Pueue visualization tool
3. **Perfect Match**: Pueue (Rust) + Pueue-TUI (visualization) = Complete solution
4. **Community Value**: Benefits entire Pueue ecosystem

## Implementation for Claude Code Parallel

### Phase 1: Complete Pueue Migration

```bash
# Before: Dual system
tools/queue add ...        # File-based
tools/queue-pueue sync     # Sync to Pueue

# After: Direct Pueue
pueue add --group subissues --label "..." "..."
```

### Phase 2: Pueue-TUI Integration

```javascript
// commands/work.js
const { Pueue-TUI } = require('pueue-tui');

async function processIssues(issues) {
  // Initialize Pueue-TUI
  const pueue-tui = new Pueue-TUI({
    group: 'claude-subissues',
    workers: 8,
    layout: 'grid',
    autoResponses: [{
      match: /proceed with \d+ files?/i,
      response: '1'  // Yes
    }]
  });
  
  // Start visual workers
  await pueue-tui.start();
  
  // Add tasks
  for (const subissue of subissues) {
    await pueue-tui.queue({
      label: `subissue-${subissue.id}`,
      priority: subissue.priority,
      command: `claude /work-on ${subissue.id}`
    });
  }
  
  // Monitor until complete
  await pueue-tui.waitForCompletion();
}
```

### Benefits for Claude Code Parallel

1. **Simplified Architecture**: Remove queue management complexity
2. **Better Features**: Inherit all Pueue capabilities
3. **Focus on Core**: Claude-specific logic only
4. **Community Contribution**: Give back to open source

## Pueue-TUI as Independent Project

### Repository Structure
```
pueue-tui/
├── README.md           # "Tmux visualization for Pueue"
├── package.json        # NPM package
├── src/
│   ├── cli.ts         # CLI interface
│   ├── worker.ts      # Worker management
│   ├── monitor.ts     # Dashboard
│   ├── layouts.ts     # Tmux layouts
│   └── auto.ts        # Auto-response
├── examples/
│   ├── compile.yml    # C++ build example
│   ├── test.yml       # Test suite example
│   └── ai-agent.yml   # AI agent example
└── docs/
```

### Marketing Potential

```markdown
# Pueue-TUI - See What Pueue is Doing! 👀

Finally visualize your Pueue tasks in real-time with tmux.

## Problem
❌ Pueue runs tasks in background - no visibility
❌ Can't see what's happening inside tasks
❌ Hard to debug interactive commands

## Solution
✅ Every task runs in a visible tmux pane
✅ Live monitoring dashboard
✅ Auto-response for interactive prompts
✅ Perfect for CI, builds, AI agents

## Quick Start
npm install -g pueue-tui
pueue-tui start --group build --workers 4
```

### Use Cases Beyond Claude

1. **Build Systems**: Watch compilation in parallel
2. **Test Suites**: See test output live
3. **Data Processing**: Monitor ETL pipelines
4. **AI Agents**: Any LLM that needs visibility
5. **DevOps**: Deployment scripts with progress

## Decision

**Recommendation: Proceed with both proposals**

1. **Immediate**: Complete Pueue migration in Claude Code Parallel
2. **Next**: Extract and publish Pueue-TUI as independent tool
3. **Future**: Claude Code Parallel uses Pueue-TUI as dependency

## Consequences

### Positive
- ✅ Cleaner architecture (single queue system)
- ✅ Valuable open source contribution
- ✅ Benefits entire Pueue community
- ✅ Claude Code Parallel becomes simpler
- ✅ Potential for wide adoption

### Negative
- ⚠️ More initial work to extract
- ⚠️ Need to maintain separate project
- ⚠️ Dependency on external tool (but we control it)

### Mitigations
- Start with internal extraction, publish when stable
- Clear separation of concerns
- Can always vendor if needed

## Technical Specification

### Pueue-TUI Core API

```typescript
interface Pueue-TUIConfig {
  group?: string;
  workers?: number;
  layout?: 'grid' | 'stack' | 'focus';
  session?: string;
  autoResponses?: AutoResponse[];
  theme?: 'default' | 'minimal' | 'rich';
}

class Pueue-TUI {
  constructor(config: Pueue-TUIConfig);
  
  // Core methods
  async start(): Promise<void>;
  async stop(): Promise<void>;
  async queue(task: Task): Promise<number>;
  async monitor(): Promise<void>;
  async attach(worker: number): Promise<void>;
  
  // Events
  on(event: 'task-start', callback: (task) => void);
  on(event: 'task-complete', callback: (task) => void);
  on(event: 'worker-idle', callback: (worker) => void);
}
```

### Integration Pattern

```bash
# Pueue-TUI CLI wraps Pueue + adds visualization
pueue-tui add "npm test"         # → pueue add + visual setup
pueue-tui status                 # → enhanced status with tmux info
pueue-tui monitor               # → rich dashboard
pueue-tui attach 3              # → jump to worker 3
```

## Profound Implications

This isn't just an architectural improvement - it's the creation of a missing piece in the Pueue ecosystem. By solving our specific need (Claude visibility), we're solving a general problem that affects anyone using Pueue for interactive or long-running tasks.

The combination of:
- **Pueue**: Robust queue management (Rust)
- **Pueue-TUI**: Beautiful visualization (TypeScript/Tmux)
- **Claude Code Parallel**: AI-powered development

Creates a new paradigm for observable, parallel task execution.