# Initialize Project

Prepare your project for parallel development with the hybrid Pueue+Tmux architecture.

Usage: /project:setup

Arguments: $ARGUMENTS

## What I'll Do

### 1. Verify Environment
- Check git repository status
- Ensure GitHub CLI is authenticated
- Verify tmux is installed
- Check Pueue installation
- Verify directory permissions

### 2. Install Dependencies
- Install Pueue if not present
- Configure Pueue daemon
- Set up Pueue groups for workers
- Initialize `.claude/` structure

### 3. Configure Settings
- Apply autonomous operation settings
- Set up git worktree configuration
- Configure Pueue for Claude Code Parallel
- Set up command aliases

### 4. Test Setup
- Verify GitHub API access
- Test Pueue task creation
- Test tmux session via Pueue
- Check worktree operations

## Post-Setup

After setup, you're ready to:
1. Create GitHub issues for your work
2. Run `/project:work` to start development
3. Use `/project:status` to monitor progress

## Troubleshooting

If setup fails:
- Check `gh auth status` for GitHub access
- Ensure you're in a git repository
- Verify you have write permissions
- Run with `--verbose` for detailed output

## Example

```bash
/project:setup

✓ Git repository detected
✓ GitHub CLI authenticated
✓ Tmux available
✓ Pueue installed and configured
✓ Created .claude/ directory
✓ Configured autonomous settings
✓ Pueue daemon started
✓ Worker group created
✓ Setup complete!

Ready to start parallel development.
Next: Create issues and run /project:work
```