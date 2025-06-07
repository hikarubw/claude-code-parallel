# GitHub Issue: Extract and Build Pueue-TUI Core (Week 2)

## Title
Extract and build Pueue-TUI as standalone terminal UI for task queues

## Description

### Overview
Extract the queue visualization components from Claude Code Parallel into a standalone, backend-agnostic tool called Pueue-TUI. This tool will make any task queue visible in the terminal using tmux, starting with Pueue support.

### Background
Currently, Claude Code Parallel has excellent visualization capabilities that show workers processing tasks in real-time. This functionality is valuable beyond just Claude - any developer debugging distributed systems at 3am needs to see what their queues are doing. By extracting this into Pueue-TUI, we can benefit the broader developer community.

### Objectives
1. Create a new repository and project structure for Pueue-TUI
2. Extract and refactor the visualization logic to be backend-agnostic
3. Implement a clean Pueue backend adapter
4. Create a simple CLI interface that "just works"
5. Build a worker management system for spawning/monitoring processes
6. Ensure comprehensive test coverage for reliability

### Technical Requirements

#### Architecture
```
pueue-tui/
├── src/
│   ├── core/          # Queue abstractions
│   ├── backends/      # Pueue, Celery, etc.
│   ├── ui/            # Tmux visualization
│   ├── workers/       # Worker management
│   └── cli/           # CLI interface
├── bin/
│   └── pueue-tui     # Main executable
├── tests/
├── examples/
└── docs/
```

#### Core Interfaces
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
}
```

#### Key Features
- **Zero Configuration**: Should work with just `pueue-tui`
- **Live Monitoring**: Real-time task and worker status
- **Worker Management**: Spawn, monitor, restart workers
- **Backend Agnostic**: Clean abstraction for future backends
- **Terminal Native**: Pure terminal UI using tmux

### Implementation Tasks

#### 1. Repository Setup
- [ ] Create GitHub repository `pueue-tui`
- [ ] Initialize TypeScript/Node.js project
- [ ] Configure build system (esbuild/tsup)
- [ ] Set up GitHub Actions CI/CD
- [ ] Add MIT license
- [ ] Create initial README

#### 2. Core Extraction
- [ ] Extract worker-monitor visualization logic
- [ ] Remove Claude-specific dependencies
- [ ] Create QueueBackend interface
- [ ] Implement VisualizationProvider interface
- [ ] Add configuration system
- [ ] Create plugin architecture

#### 3. Pueue Backend
- [ ] Implement PueueBackend class
- [ ] Parse Pueue JSON status
- [ ] Handle group management
- [ ] Implement task claiming
- [ ] Add error handling
- [ ] Create reconnection logic

#### 4. CLI Development
- [ ] Create main entry point
- [ ] Implement `pueue-tui` command
- [ ] Add `pueue-tui workers N` command
- [ ] Handle --help and --version
- [ ] Add graceful shutdown
- [ ] Create example usage

#### 5. Worker System
- [ ] Extract worker spawning logic
- [ ] Create WorkerManager class
- [ ] Implement health monitoring
- [ ] Add auto-restart capability
- [ ] Support dynamic scaling
- [ ] Handle worker templates

#### 6. Testing
- [ ] Set up test framework (Jest/Vitest)
- [ ] Unit tests for core logic (90% coverage)
- [ ] Integration tests with mock Pueue
- [ ] Test tmux operations
- [ ] Performance benchmarks
- [ ] Example scenarios

### Success Criteria
- [ ] `npm install -g pueue-tui` works
- [ ] `pueue-tui` starts visualization immediately
- [ ] Workers visible in tmux panes
- [ ] Queue status updates in real-time
- [ ] Clean separation from Claude Code Parallel
- [ ] All tests passing with >85% coverage
- [ ] Documentation complete

### Technical Notes
- Use TypeScript for better maintainability
- Keep dependencies minimal
- Ensure cross-platform compatibility (Mac/Linux)
- Follow terminal UI best practices
- Make it fast (startup < 1 second)

### Future Considerations
- Celery backend support
- RabbitMQ backend support  
- Kubernetes job visualization
- Web dashboard companion
- Recording/playback features

### References
- Current implementation: `/tools/worker-monitor`, `/tools/hybrid-worker`
- Pueue API: https://github.com/Nukesor/pueue
- Similar tools: htop, k9s, lazydocker

### Time Estimate
This is estimated as 40-50 hours of work, perfect for parallel processing with 5-6 Claude workers to complete in 2-3 days instead of a week.

---

**Labels**: enhancement, extraction, new-tool, week-2
**Assignees**: Claude workers 1-6
**Milestone**: Phase 2 - Pueue-TUI MVP