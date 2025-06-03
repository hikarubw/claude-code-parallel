# Changelog

## [1.0.0] - 2024-06-03

### Initial Release
- Parallel development automation for Claude Code
- Task queue management with dependency tracking
- tmux session management with git worktrees
- GitHub integration for issue breakdown
- Automatic cleanup and maintenance tools

### Features
- `/project:setup` - Initialize project for parallel work
- `/project:work N` - Start N parallel sessions
- `/project:status` - View all parallel work status
- `/project:manual` - Handle manual tasks
- `/project:maintain` - Clean up resources
- `/project:auto` - Continuous automation

### Tools
- `task` - Queue and dependency management
- `session` - Parallel tmux/worktree control
- `github` - Issue operations
- `maintain` - Cleanup utilities