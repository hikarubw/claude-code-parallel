# Changelog

All notable changes to Claude Code Parallel will be documented in this file.

## [2.0.0] - 2024-06-03

### 🎉 Major Release: Autonomous Operation

This release introduces **autonomous operation** - reducing approval interruptions by 90% through intelligent use of worktree isolation.

### Added
- **Autonomous Operation** - Worktree-specific permissive settings
- **Intelligent Branch Naming** - Claude decides feature/, bugfix/, docs/ prefixes
- **Manual Work Detection** - Monitor GitHub issue states for completion
- **setup-autonomous Tool** - Manage worktree permissions
- **Enhanced Documentation** - Complete docs overhaul with FAQ, guides, and TOC

### Changed
- **session Tool** - Now applies autonomous settings automatically
- **Approval Model** - From interruption-heavy to autonomous-by-default
- **Branch Strategy** - From manual/auto prefixes to intelligent naming
- **Documentation Structure** - Reorganized for better navigation

### Security
- Maintained safety through worktree isolation
- All changes still require PR review
- No direct main branch access

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

### Initial Public Release

After extracting OAuth features and renaming from `claude-code-tools` to `claude-code-parallel`, this marks the first public release focused on parallel development automation.

### Features
- **Parallel Development** - Work on multiple issues simultaneously
- **Task Queue Management** - File-based queue with dependency tracking
- **tmux Integration** - Parallel sessions with isolated environments
- **Git Worktrees** - Safe isolation for each task
- **GitHub Integration** - Issue breakdown and PR automation
- **Smart Maintenance** - Automatic cleanup of completed work

### Commands
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

### Philosophy
Built on "Claude-first" architecture where simple tools (50-200 lines) are orchestrated by Claude's intelligence, not embedded logic.

---

For migration notes and detailed changes, see the [documentation](docs/).