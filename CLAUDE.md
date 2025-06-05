# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

## 🚧 Project Status: Experimental (v0.3.0)

This project is in active experimentation phase. Architecture and APIs are subject to change.

## 🏗️ Current Architecture: Subissue-Based Worker Pool

### Overview
Claude Code Tools extends Claude Code with parallel development capabilities. Users provide GitHub issues, and the system:
1. Analyzes issues using Claude intelligence
2. Creates logical subissues (2-5 per parent issue)
3. Manages work via priority queue
4. Processes queue with autonomous worker pool (tmux sessions)
5. Creates PRs automatically

### Key Commands
- `/project:work ISSUES [WORKERS]` - Start parallel development
- `/project:status` - Monitor progress
- `/project:add ISSUES` - Add more work
- `/project:stop` - Graceful shutdown
- `/project:resume` - Continue from saved state

### Architecture Flow
```
User Issues → Claude Analysis → Subissue Queue → Worker Pool → PRs → Auto-close
    #123      Creates 3-5       Priority         Tmux         GitHub   Parent
    #124      subissues         Queue           Workers       PRs      Issues
```

## 🛠️ Development Guidelines

### When Working on This Project
1. **Maintain Simplicity** - The power is in simplicity, not complexity
2. **User-First Design** - Users should only need to provide issue numbers
3. **Leverage Claude Intelligence** - Let AI handle the complexity
4. **Preserve Safety** - All changes go through PR review

### Code Organization
```
/commands/   - User-facing slash commands
/tools/      - Implementation scripts
/docs/       - Documentation (with archives)
/.claude/    - Claude Code configuration
```

### Key Tools
- `queue` - Priority queue management
- `worker` - Worker pool orchestration
- `analyze` - Claude-powered issue analysis
- `github` - GitHub API operations
- `session` - Tmux session management

## 🧪 Testing Guidelines

When testing changes:
1. Start with small issue counts (1-2)
2. Monitor worker behavior with `/project:status`
3. Check queue state with `queue status`
4. Verify PR creation and linking

## 📚 Important Context

### Auto-Approval Mechanism
The project includes an auto-approval daemon (`tools/auto-approve`) that:
- Monitors tmux sessions for approval prompts
- Automatically approves safe operations
- Achieves 99% autonomous operation

### Experimental Features
Currently experimenting with:
- Optimal subissue sizing algorithms
- Worker pool scaling strategies
- Queue prioritization methods
- Error recovery mechanisms

## 🎯 Project Goals

1. **Simplicity** - One command to parallelize development
2. **Intelligence** - Claude analyzes and optimizes work distribution
3. **Autonomy** - Minimal human intervention required
4. **Safety** - All changes reviewable through PRs

## 🚀 Future Directions

Working towards:
- v0.4.0 - Enhanced intelligence and learning
- v0.5.0 - Distributed workers and scale
- v1.0.0 - Production-ready system

---

Remember: This is experimental software. Be bold in experimentation but careful with user experience.