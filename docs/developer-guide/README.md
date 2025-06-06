# Developer Guide

Technical documentation for understanding, contributing to, and extending Claude Code Parallel.

## 📁 Contents

### Current Architecture
- **[Architecture Overview](current-architecture/ARCHITECTURE.md)** - System design (v0.3.0-experimental)
- **[Hybrid Architecture Guide](current-architecture/HYBRID-ARCHITECTURE-GUIDE.md)** - Pueue + Tmux details
- **[Hybrid Architecture Summary](current-architecture/HYBRID-ARCHITECTURE-SUMMARY.md)** - Quick overview
- **[Monitoring Pane Design](current-architecture/MONITORING-PANE-DESIGN.md)** - Dashboard implementation

### Implementation Plans
- **[Master Plan & Roadmap](implementation/MASTER-PLAN-AND-ROADMAP.md)** - 6-phase implementation
- **[Strategic Priorities](implementation/STRATEGIC-PRIORITIES.md)** - What matters most
- **[Week 1 Implementation](implementation/WEEK-1-IMPLEMENTATION-PLAN.md)** - Immediate tasks
- **[Immediate Action Plan](implementation/IMMEDIATE-ACTION-PLAN.md)** - Next 48 hours
- **[Integration Enhancements](implementation/INTEGRATION_ENHANCEMENTS.md)** - VS Code & more

### Future Vision
- **[Pueue-TUI Vision](future-vision/PUEUE-TUI-FUTURE-VISION.md)** - Extracted visualization tool
- **[Pueue-TUI Implementation](future-vision/PUEUE-TUI-IMPLEMENTATION-PLAN.md)** - How to build it
- **[Future with Pueue-TUI](future-vision/FUTURE-WITH-PUEUE-TUI.md)** - Simplified architecture

### Architecture Decision Records (ADRs)
- **[ADR-002](adr/ADR-002-SINGLE-TMUX-VS-PUEUE.md)** - Single Tmux vs Pueue analysis
- **[ADR-003](adr/ADR-003-HYBRID-PUEUE-TMUX.md)** - Current hybrid architecture ⭐
- **[ADR-004](adr/ADR-004-PUEUE-NATIVE-AND-PUEUE-TUI.md)** - Future Pueue-TUI extraction

## 🏗️ Architecture Overview

```
User Issues → Claude Analysis → Pueue Queue → Hybrid Workers → PRs
                                     ↓              ↓
                                Persistence    Tmux Visibility
```

### Key Components

1. **Pueue Queue Manager**
   - Task persistence
   - Priority scheduling
   - Crash recovery
   - Dependency management

2. **Hybrid Workers**
   - Poll Pueue for tasks
   - Execute Claude in tmux panes
   - Update queue status
   - Handle failures gracefully

3. **Monitoring System**
   - Live tmux dashboard
   - Queue status display
   - Worker health checks
   - Performance metrics

## 🔧 Development Setup

```bash
# Clone repository
git clone https://github.com/hikarubw/claude-code-parallel
cd claude-code-parallel

# Install dependencies
brew install tmux pueue jq

# Run tests
./test.sh

# Start development
./tools/setup-hybrid 4
```

## 📝 Contributing

1. **Understand Current State**
   - Read [Architecture Overview](current-architecture/ARCHITECTURE.md)
   - Review [ADR-003](adr/ADR-003-HYBRID-PUEUE-TMUX.md)
   - Check [Strategic Priorities](implementation/STRATEGIC-PRIORITIES.md)

2. **Follow Guidelines**
   - Keep tools simple (50-200 lines)
   - Let Claude provide intelligence
   - Maintain hybrid architecture
   - Write clear commit messages

3. **Test Thoroughly**
   - Test with real GitHub issues
   - Verify Pueue integration
   - Check tmux visibility
   - Ensure backwards compatibility

## 🚀 Future Direction

We're moving towards:
1. **Extracting Pueue-TUI** as independent tool
2. **Simplifying** Claude Code Parallel to pure AI logic
3. **Enabling** distributed workers across machines

See [Future Vision](future-vision/) for details.

---

*Building the future of AI-powered development, one queue at a time.*