# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Critical: Understanding Claude Code

This repository **extends Claude Code's capabilities** by enabling parallel development. Key Claude Code features to remember:

### Core Claude Code Capabilities
- **Agentic coding tool** that understands entire project context automatically
- **Direct file editing**, bug fixing, and architecture understanding
- **Git operations**: commits, PRs, merge conflict resolution
- **Test execution** and fixing
- **Web search** for documentation

📚 **Source**: [Claude Code Overview](https://docs.anthropic.com/en/docs/claude-code/overview)

### Claude Code Slash Commands
- Commands live in `.claude/commands/` directory as markdown files
- Format: `/project:command-name` or `/user:command-name`
- Can include `$ARGUMENTS` for dynamic inputs
- This repo provides: `/project:setup`, `/project:work`, `/project:status`, etc.

📚 **Source**: [Claude Code CLI Usage - Slash Commands](https://docs.anthropic.com/en/docs/claude-code/cli-usage#slash-commands)

### Extended Thinking
- Use phrases like "think", "think more", "think harder" for complex tasks
- Essential for architectural decisions and debugging
- Shows thinking as italic gray text

📚 **Source**: [Claude Code Tutorials - Extended Thinking](https://docs.anthropic.com/en/docs/claude-code/tutorials#extended-thinking)

### Resume/Continue
- `--continue`: Resume last conversation
- `--resume`: Pick from previous conversations
- Critical for long-running parallel work sessions

📚 **Source**: [Claude Code Tutorials - Resume Conversations](https://docs.anthropic.com/en/docs/claude-code/tutorials#resuming-previous-conversations)

## Architecture Overview

This is **Claude Code Parallel** - a tool that enables parallel development using simple bash scripts + intelligent Claude orchestration.

**Core Philosophy**: Keep tools simple (50-200 lines), let Claude provide the intelligence.

### System Architecture
```
Claude Code (Intelligence) → Slash Commands → Bash Tools → tmux Sessions → Git Worktrees
```

- **Tools** (`/tools/*`): Simple bash scripts that do one thing well
- **Commands** (`/commands/*.md`): Documentation that teaches workflows  
- **Worktrees**: Isolated git branches for each task
- **State**: Simple text files in `.claude/tasks/`

### Key Architectural Decisions

1. **No Build System**: Everything is bash scripts - no compilation, bundling, or complex tooling
2. **File-Based State**: Queue and tracking use simple text files, not databases
3. **Worktree Isolation**: Each task gets its own git worktree for safety
4. **Intelligence in Claude**: Tools stay dumb, Claude makes smart decisions
5. **PR Gateway**: All changes must go through PR review

## Development Commands

### Installation & Deployment
```bash
# Install locally
bash install.sh

# Deploy new version
bash scripts/deploy.sh

# Test installer
bash install.sh --help
```

### Working with Tools
```bash
# Tools are in /tools/ directory
# Each tool is a standalone bash script
# Run directly: ./tools/task add 123
# Or through .claude: .claude/tools/task add 123
```

### Version Management
- Version is in `VERSION` file
- Installer reads version dynamically
- Deploy script creates GitHub releases

## Task-Based Architecture (v2.1.0)

The project is transitioning to task-based parallelism:

1. **Issues contain task checklists** (not sub-issues)
2. **Each checkbox = one parallel work unit**
3. **Task format**: `#47-1` (issue 47, task 1)
4. **Branches**: `task/#47-1-description`
5. **PRs update checklists**, not close issues

Example issue:
```markdown
## Tasks
- [ ] Create API endpoint
- [ ] Add UI component  
- [ ] Write tests
- [ ] 👤 Get design approval (manual)
```

## Tool Patterns

### Task Queue (`/tools/task`)
- Format: `ID|DESCRIPTION|STATUS|DEPENDENCIES`
- Example: `#47-1|Create auth tests|pending|#47-2`
- States: pending, in-progress, completed, blocked

### Session Management (`/tools/session`)
- Creates tmux sessions named `claude-1`, `claude-2`, etc.
- Each session bound to specific task
- Automatic cleanup on completion

### GitHub Integration (`/tools/github`)
- Parses issues into tasks
- Updates checklist items
- Creates task-specific PRs

## State Files

All state lives in `.claude/`:
- `tasks/queue.txt` - Task queue
- `tasks/approvals.txt` - Approved commands
- `tasks/blocking.txt` - Dependencies
- `issues/*.md` - Parsed issue content

## Safety Features

1. **Worktree Settings**: `templates/settings.worktree.json` enables autonomous operation
2. **Main Branch Protection**: Stays restrictive while worktrees are permissive
3. **PR-Only Changes**: No direct main branch modifications
4. **Manual Task Handling**: 👤 prefix identifies manual work

## Common Workflows

### Starting Parallel Work
```bash
/project:setup        # Parse issues into tasks
/project:work 5       # Start 5 parallel sessions
/project:status       # Monitor progress
/project:maintain     # Clean up completed work
```

### Leveraging Claude Code Features
```bash
# Use extended thinking for complex architectural decisions
"Think deeply about how to implement task-based architecture"

# Resume work after interruption
claude --continue  # Continue last session
claude --resume    # Pick specific session

# Work with visual content
"Here's a screenshot of the error" [paste image]
```

📚 **Sources**: 
- [Extended Thinking](https://docs.anthropic.com/en/docs/claude-code/tutorials#extended-thinking)
- [Working with Images](https://docs.anthropic.com/en/docs/claude-code/tutorials#working-with-images)
- [CLI Usage](https://docs.anthropic.com/en/docs/claude-code/cli-usage)

### Manual Task Handling
```bash
/project:manual       # Show manual tasks
# Complete manual task externally
/project:manual 47-3  # Mark as complete
```

## Debugging

- Check `.claude/tasks/queue.txt` for task status
- View tmux sessions: `tmux ls`
- Check worktrees: `git worktree list`
- Session logs in tmux: `tmux attach -t claude-1`

## Important Notes

### Tool Design Principles
- **No Complex Logic**: Keep tools simple, logic belongs in Claude
- **No Tests**: Tools are too simple to need testing
- **No Configuration**: Everything uses command-line arguments
- **Version Updates**: Only change `VERSION` file, installer reads it
- **Task Dependencies**: Use format `blocked-by:#47-1` in task queue

### Claude Code Integration
- **Commands are markdown**: Located in `/commands/*.md`
- **Slash command format**: `/project:*` for this tool's commands
- **Arguments supported**: Use `$ARGUMENTS` in command definitions
- **Extended thinking**: Essential for complex parallel work planning
- **Image support**: Screenshots help debug parallel session issues

## Additional Claude Code Resources

- 📖 [Getting Started Guide](https://docs.anthropic.com/en/docs/claude-code/getting-started)
- ⚙️ [Settings & Configuration](https://docs.anthropic.com/en/docs/claude-code/settings)
- 🔧 [Troubleshooting Guide](https://docs.anthropic.com/en/docs/claude-code/troubleshooting)
- 🚀 [Best Practices](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview)
- 🏢 [Enterprise Usage (Bedrock/Vertex)](https://docs.anthropic.com/en/docs/claude-code/bedrock-vertex-proxies)

### Parallel Work Best Practices
1. Use extended thinking when planning parallel task distribution
2. Leverage `--continue` to resume interrupted parallel sessions
3. Screenshots of `/project:status` output help track progress
4. Each worktree gets permissive settings for autonomous operation
5. All changes must go through PR review for safety