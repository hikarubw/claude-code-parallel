# Changelog

All notable changes to Claude Code Parallel will be documented in this file.

## [1.0.1] - 2024-06-03

### Added
- Unified installer with better error handling
- `--uninstall` option for easy removal
- `--help` option with detailed information
- Installation verification with detailed feedback
- Version management system
- Retry logic for downloads
- Improved launcher script with error messages

### Changed
- Simplified installation process
- Better progress indicators during installation
- Clearer error messages
- Consolidated deployment scripts into single `deploy.sh`

### Removed
- Redundant deployment scripts (cdn, gist, pages)
- OAuth tools (moved to separate repository)
- Non-core tools (analyze, monitor)

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