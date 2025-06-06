# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

## 🚧 Project Status: Experimental (v0.3.0)

This project is in active experimentation phase. Architecture and APIs are subject to change.

## 🏗️ Current Architecture: Hybrid Pueue+Tmux (v0.3.0-experimental)

### Overview
Claude Code Parallel extends Claude Code with parallel development capabilities using a **revolutionary hybrid architecture** that combines Pueue's reliability with Tmux's Claude compatibility. Users provide GitHub issues, and the system:

1. Analyzes issues using Claude intelligence
2. Creates logical subissues (2-5 per parent issue)
3. Manages work via Pueue's persistent queue
4. Spawns tmux sessions through Pueue tasks
5. Creates PRs automatically with auto-approval
6. Provides crash recovery and automatic retries

### Key Commands
- `/project:work ISSUES [WORKERS]` - Start parallel development
- `/project:status` - Monitor progress (Pueue + Tmux view)
- `/project:add ISSUES` - Add more work to queue
- `/project:stop` - Graceful shutdown
- `/project:resume` - Continue from saved state (automatic with Pueue)

### Architecture Flow
```
User Issues → Claude Analysis → Pueue Queue → Hybrid Workers → PRs → Auto-close
    #123      Creates 3-5       Persistent     Pueue spawns    GitHub   Parent
    #124      subissues         & Reliable     Tmux sessions   PRs      Issues
```

### Why Hybrid Architecture?
- **Pueue**: Industrial-grade task queue with persistence, crash recovery, and retry logic
- **Tmux**: Provides terminal sessions that Claude Code requires for interaction
- **Best of Both**: Professional queue management + Claude visibility
- **Auto-Approval**: Continues to work with tmux sessions for 99% autonomy

## 🛠️ Development Guidelines

### Critical: CLAUDE.md as Project Memory
**This file is the persistent "mind" of the project**. Since Claude cannot remember between sessions, CLAUDE.md serves as the memory. Always update this file with:
- Architecture changes
- Important decisions
- New features or commands
- Experimental findings
- Version updates

### Architecture Decision Records (ADR)
When making architecture changes or redesigns:
1. Create ADR in `docs/ADR-XXX-title.md` format
2. Document: Context, Decision, Consequences, Alternatives
3. Link to ADR from CLAUDE.md
4. Keep ADRs even if decisions are reversed (shows evolution)

**Important**: ADRs are essential history - NEVER delete them. They can be moved to archives but must be preserved. While other files can be cleaned/reorganized aggressively, ADRs document the "why" of our journey.

Current ADRs:
- `docs/archive/proposals/ADR-001-SUBISSUE-WORKER-ARCHITECTURE.md` - v0.3.0 architecture
- `docs/ADR-002-SINGLE-TMUX-VS-PUEUE.md` - Analysis of single tmux session vs Pueue (Keep current architecture)
- `docs/ADR-003-HYBRID-PUEUE-TMUX.md` - **Revolutionary hybrid approach** - Pueue for queue + Tmux for visibility (Game changer!)
- `docs/ADR-004-PUEUE-NATIVE-AND-PUEUE-TUI.md` - **Next evolution** - Extract Pueue-TUI as independent visualization tool!

### When Working on This Project
1. **Maintain Simplicity** - The power is in simplicity, not complexity
2. **User-First Design** - Users should only need to provide issue numbers
3. **Leverage Claude Intelligence** - Let AI handle the complexity
4. **Preserve Safety** - All changes go through PR review
5. **Update CLAUDE.md** - "Keep in mind" = "Keep in CLAUDE.md"

### Code Organization
```
/commands/   - User-facing slash commands
/tools/      - Implementation scripts
/docs/       - Documentation (with archives)
/.claude/    - Claude Code configuration
```

### Key Tools
- `setup-hybrid` - One-command hybrid architecture setup
- `hybrid-worker` - Pueue+Tmux worker implementation
- `queue-pueue` - Pueue queue adapter
- `analyze` - Claude-powered issue analysis
- `github` - GitHub API operations
- `auto-approve` - Autonomous operation enabler
- `grid-manager` - Advanced tmux layout management

## 🧪 Testing Guidelines

When testing changes:
1. Start with small issue counts (1-2)
2. Monitor worker behavior with `/project:status` or `pueue follow`
3. Check queue state with `pueue status`
4. Verify PR creation and linking
5. Run test suites:
   - `./tests/test-suite.sh` - Comprehensive Pueue tests
   - `./tests/hybrid-integration-tests.sh` - Full workflow tests

## 📚 Important Context

### Hybrid Architecture Benefits
The Pueue+Tmux hybrid approach provides:
- **Persistence**: Queue state survives crashes and reboots
- **Reliability**: Automatic retry on failures
- **Visibility**: Tmux sessions for Claude Code compatibility
- **Scalability**: Easy worker scaling with `pueue parallel`
- **Monitoring**: Rich status and logging capabilities

### Auto-Approval Mechanism
The project includes an auto-approval daemon (`tools/auto-approve`) that:
- Monitors tmux sessions for approval prompts
- Automatically approves safe operations
- Achieves 99% autonomous operation
- Works seamlessly with hybrid architecture

### Testing & Documentation
Comprehensive test coverage and documentation:
- **Test Suites**: Full coverage of failure scenarios, stress tests, and integration
- **Architecture Diagrams**: Visual representation of hybrid system
- **User Guides**: Quick start, troubleshooting, and Pueue commands
- **Developer Docs**: ADRs and implementation details

## 🎯 Project Goals

1. **Simplicity** - One command to parallelize development
2. **Intelligence** - Claude analyzes and optimizes work distribution
3. **Autonomy** - Minimal human intervention required
4. **Safety** - All changes reviewable through PRs

## 🚀 Future Directions

### Current: Hybrid Architecture IMPLEMENTED ✅
The revolutionary hybrid Pueue + Tmux approach (ADR-003) is now fully implemented:
- Professional queue management (Pueue) ✅
- Maintained Claude visibility (Tmux) ✅
- Auto-approval continues working ✅
- Comprehensive test suite ✅
- Full documentation ✅

**Available Now**:
- `tools/setup-hybrid` - One-command setup
- `tools/hybrid-worker` - Worker implementation  
- `tools/queue-pueue` - Queue adapter
- `tests/test-suite.sh` - Comprehensive tests
- `docs/user-guide/` - Complete user documentation
- `docs/developer-guide/` - Architecture details

### Roadmap:
- ✅ v0.3.0 - Hybrid architecture implementation (DONE)
- v0.4.0 - Pueue-TUI extraction for visualization
- v0.5.0 - Enhanced intelligence with dependencies
- v0.6.0 - Distributed workers across machines
- v1.0.0 - Production-ready system

---

Remember: This is experimental software. Be bold in experimentation but careful with user experience.