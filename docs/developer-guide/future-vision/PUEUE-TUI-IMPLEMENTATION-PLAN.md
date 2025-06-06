# Pueue-TUI Implementation Plan

## Phase 1: Internal Extraction (Week 1-2)

### 1.1 Complete Pueue Migration
```bash
# Remove file-based queue
rm tools/queue
rm -rf ~/.claude/queue/

# Update all references to use Pueue directly
tools/analyze → adds directly to Pueue
tools/worker → simplified to just poll Pueue
```

### 1.2 Extract Core Pueue-TUI Components
```
claude-code-parallel/
└── pueue-tui-core/           # Internal package first
    ├── src/
    │   ├── worker.ts     # From hybrid-worker
    │   ├── monitor.ts    # From monitoring-pane
    │   ├── grid.ts       # From grid-manager
    │   └── cli.ts        # New CLI interface
    └── package.json
```

### 1.3 Create Pueue-TUI CLI
```bash
# Internal commands
pueue-tui start --workers 8 --group claude
pueue-tui monitor
pueue-tui attach 3
pueue-tui stop
```

## Phase 2: Standalone Package (Week 3-4)

### 2.1 Repository Setup
```bash
# Create separate repo
github.com/anthropics/pueue-tui  # or personal/org

# Core structure
pueue-tui/
├── packages/
│   ├── pueue-tui-core/      # Core library
│   ├── pueue-tui-cli/       # CLI tool
│   └── pueue-tui-web/       # Future: Web dashboard
├── examples/
├── docs/
└── README.md
```

### 2.2 NPM Package
```json
{
  "name": "pueue-tui",
  "version": "0.1.0",
  "description": "Tmux visualization for Pueue - See what your tasks are doing!",
  "bin": {
    "pueue-tui": "./dist/cli.js"
  },
  "keywords": ["pueue", "tmux", "task-queue", "visualization", "cli"],
  "dependencies": {
    "commander": "^9.0.0",
    "inquirer": "^9.0.0",
    "chalk": "^5.0.0",
    "blessed": "^0.1.81"
  }
}
```

### 2.3 Core Features Implementation

#### Worker Manager
```typescript
// src/worker-manager.ts
export class WorkerManager {
  private session: string;
  private workers: Map<number, Worker>;
  
  async start(count: number, group: string) {
    // Create tmux session
    await this.createSession();
    
    // Start workers
    for (let i = 1; i <= count; i++) {
      await this.createWorker(i, group);
    }
    
    // Start monitor in pane 0
    await this.startMonitor();
  }
  
  private async createWorker(id: number, group: string) {
    // Create pane
    await tmux.splitWindow(this.session);
    
    // Start worker loop
    const workerScript = `
      while true; do
        task=$(pueue status --json | jq 'task for worker')
        if [[ -n "$task" ]]; then
          pueue start $task_id
          # Execute visible command
          eval "$command"
          pueue finish $task_id
        fi
        sleep 1
      done
    `;
    
    await tmux.sendKeys(this.session, id, workerScript);
  }
}
```

#### Rich Monitor
```typescript
// src/monitor.ts
export class Monitor {
  private screen: blessed.screen;
  
  async start() {
    this.screen = blessed.screen({
      smartCSR: true,
      title: 'Pueue-TUI Monitor'
    });
    
    // Queue status box
    const queueBox = blessed.box({
      label: 'Queue Status',
      top: 0,
      left: 0,
      width: '50%',
      height: '50%'
    });
    
    // Worker status box
    const workerBox = blessed.box({
      label: 'Workers',
      top: 0,
      left: '50%',
      width: '50%',
      height: '50%'
    });
    
    // Update loop
    setInterval(() => this.update(), 1000);
  }
}
```

#### Auto Response System
```typescript
// src/auto-response.ts
export class AutoResponse {
  private patterns: Pattern[];
  
  async monitor(session: string) {
    while (true) {
      const panes = await tmux.listPanes(session);
      
      for (const pane of panes) {
        const content = await tmux.capturePane(pane);
        
        for (const pattern of this.patterns) {
          if (pattern.test(content)) {
            await tmux.sendKeys(pane, pattern.response);
          }
        }
      }
      
      await sleep(100);
    }
  }
}
```

## Phase 3: Claude Code Parallel Integration (Week 5)

### 3.1 Replace Internal Implementation
```javascript
// commands/work.js
const { Pueue-TUI } = require('pueue-tui');

export async function workCommand(issues, workers = 4) {
  // Initialize Pueue-TUI
  const pueue-tui = new Pueue-TUI({
    group: 'claude-subissues',
    workers,
    autoResponses: [
      { match: /proceed.*files?/i, response: '1' }
    ]
  });
  
  // Start workers
  await pueue-tui.start();
  
  // Analyze and queue
  for (const issue of issues) {
    const subissues = await analyzeIssue(issue);
    
    for (const sub of subissues) {
      await pueue.add({
        group: 'claude-subissues',
        label: `subissue-${sub.id}`,
        priority: sub.priority,
        command: `claude /work-on ${sub.id}`
      });
    }
  }
}
```

### 3.2 Simplified Tools
```bash
tools/
├── analyze        # Still needed for Claude analysis
├── github         # Still needed for GitHub operations  
├── session        # Replaced by Pueue-TUI
├── worker         # Replaced by Pueue-TUI
├── monitor        # Replaced by Pueue-TUI
└── auto-approve   # Integrated into Pueue-TUI
```

## Phase 4: Community Launch (Week 6+)

### 4.1 Documentation Site
```markdown
# docs.pueue-tui.dev

## What is Pueue-TUI?

Pueue-TUI brings visibility to Pueue by running tasks in tmux panes.

## Quick Start

npm install -g pueue-tui
pueue add --group build "make all"
pueue-tui start --group build --workers 4

## Use Cases

### CI/CD Visualization
Watch your builds happen in parallel

### AI Agent Monitoring  
See what your AI agents are doing

### Data Pipeline Observation
Monitor ETL processes in real-time
```

### 4.2 Marketing Strategy

1. **Pueue Community**
   - Open issue: "Tmux visualization for Pueue"
   - Contribute to Pueue docs

2. **Dev Communities**
   - Post on HN: "Show HN: Pueue-TUI - See your background tasks"
   - Dev.to article: "Finally, visibility for Pueue tasks"
   - Reddit r/commandline

3. **AI/LLM Communities**
   - "Making AI agents observable with Pueue-TUI"
   - Integration guides for LangChain, AutoGPT

### 4.3 Example Showcases

```yaml
# examples/compile.yml
name: "Parallel Compilation"
group: "build"
workers: 8
layout: "grid"
tasks:
  - "gcc -c module1.c"
  - "gcc -c module2.c"
  - "gcc -c module3.c"

# examples/ai-agent.yml  
name: "AI Agent Swarm"
group: "agents"
workers: 4
auto_responses:
  - match: "Proceed?"
    response: "yes"
tasks:
  - "python agent1.py --task research"
  - "python agent2.py --task analyze"
```

## Success Metrics

### Phase 1-2 (Internal)
- [ ] Complete Pueue migration
- [ ] Pueue-TUI core working internally
- [ ] Claude Code Parallel simplified

### Phase 3-4 (Public)
- [ ] NPM package published
- [ ] 100+ GitHub stars in first month
- [ ] Adopted by 5+ projects
- [ ] Featured in Pueue documentation

## Risk Mitigation

1. **Maintain Both During Transition**
   - Keep file queue until Pueue-TUI stable
   - Gradual migration path

2. **Start Simple**
   - Basic features first
   - Community feedback driven

3. **Clear Separation**
   - Pueue-TUI = generic visualization
   - Claude Code Parallel = AI-specific logic

## Conclusion

By extracting Pueue-TUI as an independent tool, we:
1. Solve our immediate need (Claude visibility)
2. Create value for the community
3. Simplify our architecture
4. Enable future innovations

This is not just refactoring - it's creating a new category of developer tool.