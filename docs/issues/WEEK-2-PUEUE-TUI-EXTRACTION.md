# Week 2: Pueue-TUI Extraction Issues

## Overview
Extract the queue visualization logic from Claude Code Parallel into a standalone, backend-agnostic tool that can benefit the broader developer community.

---

## Issue #25: Create Pueue-TUI repository and project structure

### Description
Set up a new repository for Pueue-TUI with proper structure, licensing, and initial documentation.

### Tasks
- [ ] Create new GitHub repository `pueue-tui`
- [ ] Set up TypeScript/JavaScript project structure
- [ ] Configure build tools (esbuild or similar)
- [ ] Add MIT license
- [ ] Create initial README with vision
- [ ] Set up CI/CD with GitHub Actions
- [ ] Configure NPM package.json

### Directory Structure
```
pueue-tui/
├── src/
│   ├── core/          # Core abstractions
│   ├── backends/      # Queue backend implementations
│   ├── ui/            # Terminal UI components
│   ├── workers/       # Worker management
│   └── cli/           # CLI interface
├── bin/
│   └── pueue-tui     # Executable entry point
├── tests/
├── examples/
└── docs/
```

---

## Issue #26: Extract and refactor core visualization logic

### Description
Extract the monitoring and visualization code from Claude Code Parallel and refactor it to be backend-agnostic.

### Tasks
- [ ] Extract worker-monitor visualization code
- [ ] Create abstract QueueBackend interface
- [ ] Refactor tmux session management
- [ ] Remove Claude-specific dependencies
- [ ] Create pluggable UI components
- [ ] Add configuration system

### Key Abstractions
```typescript
interface QueueBackend {
  name: string;
  connect(): Promise<void>;
  getTasks(): Promise<Task[]>;
  getWorkers(): Promise<Worker[]>;
  claimTask(taskId: string): Promise<void>;
  updateTask(taskId: string, status: TaskStatus): Promise<void>;
}

interface VisualizationProvider {
  render(state: SystemState): void;
  updateWorker(workerId: string, status: WorkerStatus): void;
  showNotification(message: string): void;
}
```

---

## Issue #27: Implement Pueue backend adapter

### Description
Create a clean Pueue backend implementation that interfaces with Pueue's JSON API.

### Tasks
- [ ] Create PueueBackend class
- [ ] Implement Pueue status parsing
- [ ] Handle Pueue group management
- [ ] Add task claim/release logic
- [ ] Implement error handling
- [ ] Add reconnection logic

### Implementation
```typescript
class PueueBackend extends QueueBackend {
  constructor(private config: PueueConfig) {}
  
  async getTasks(): Promise<Task[]> {
    const status = await exec('pueue status --json');
    return this.parsePueueTasks(status);
  }
  
  async claimTask(taskId: string): Promise<void> {
    await exec(`pueue start ${taskId}`);
  }
}
```

---

## Issue #28: Create minimal CLI interface

### Description
Build a simple, intuitive CLI that starts the visualization with minimal configuration.

### Tasks
- [ ] Create main CLI entry point
- [ ] Add command: `pueue-tui` (default visualization)
- [ ] Add command: `pueue-tui workers N` (with N workers)
- [ ] Add `--backend` flag for future backends
- [ ] Implement `--help` and `--version`
- [ ] Add graceful shutdown handling

### Usage Examples
```bash
# Start with auto-detected workers
pueue-tui

# Start with 8 workers
pueue-tui workers 8

# Use specific Pueue group
pueue-tui --group mygroup

# Future: Use different backend
pueue-tui --backend celery
```

---

## Issue #29: Implement worker management system

### Description
Create a worker management system that can spawn and monitor worker processes in tmux panes.

### Tasks
- [ ] Extract worker spawning logic
- [ ] Create WorkerManager class
- [ ] Implement health monitoring
- [ ] Add auto-restart capability
- [ ] Create worker templates
- [ ] Handle worker scaling

### Features
- Spawn workers in tmux panes
- Monitor worker health
- Auto-restart failed workers
- Dynamic scaling up/down
- Worker command templates

---

## Issue #30: Create comprehensive test suite

### Description
Build a test suite that ensures reliability and makes the tool trustworthy for production use.

### Tasks
- [ ] Set up Jest or Vitest
- [ ] Create unit tests for core logic
- [ ] Add integration tests with mock Pueue
- [ ] Test tmux session management
- [ ] Add performance benchmarks
- [ ] Create example scenarios

### Test Coverage Goals
- Core logic: 90%+
- Backend adapters: 85%+
- CLI commands: 80%+
- Worker management: 85%+

---

## Success Metrics for Week 2
- [ ] Repository created and structured
- [ ] Core logic extracted and refactored
- [ ] Pueue backend working
- [ ] Basic CLI functional
- [ ] Workers can be spawned and monitored
- [ ] Test suite running in CI

## Deliverables
1. Working `pueue-tui` command
2. Clean, documented codebase
3. Passing test suite
4. Draft README with examples