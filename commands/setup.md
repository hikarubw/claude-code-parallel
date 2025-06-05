# Initialize Project

Prepare your project for parallel development.

Usage: /project:setup

Arguments: $ARGUMENTS

## What I'll Do

### 1. Verify Environment
- Check git repository status
- Ensure GitHub CLI is authenticated
- Verify tmux is installed
- Check directory permissions

### 2. Create Directories
- Initialize `.claude/` structure
- Set up worker directories at `~/.claude/workers/`
- Create logs directory

### 3. Configure Settings
- Apply autonomous operation settings
- Set up git worktree configuration
- Configure command aliases

### 4. Test Setup
- Verify GitHub API access
- Test tmux session creation
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
✓ Created .claude/ directory
✓ Configured autonomous settings
✓ Setup complete!

Ready to start parallel development.
Next: Create issues and run /project:work
```