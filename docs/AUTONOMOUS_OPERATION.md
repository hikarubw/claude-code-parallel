# Autonomous Operation Guide

> 🌟 **Game Changer**: With worktree isolation, Claude Code Parallel reduces approval interruptions by 90-95%, enabling true autonomous development.

## The Power of Worktree Isolation

Claude Code Parallel leverages git worktrees to enable near-complete autonomous operation. Since each worktree is isolated from your main branch, Claude can work freely without risk.

## How It Works

### 1. Isolated Environments
Each parallel session works in its own worktree:
```
main branch (protected)
├── .worktrees/101/ (feature/101-oauth)
├── .worktrees/102/ (bugfix/102-nav-error)
└── .worktrees/103/ (refactor/103-cleanup)
```

### 2. Permissive Settings
The setup process creates worktree-specific settings that allow:
- ✅ All file modifications
- ✅ Running any tests or builds
- ✅ Installing dependencies
- ✅ Git commits and pushes to feature branches
- ✅ Creating pull requests

### 3. Safety Through Isolation
- Changes can't affect main branch directly
- Each worktree is disposable
- All merges go through PR review
- Full audit trail maintained

## Enabling Autonomous Operation

### Quick Start
```bash
# Standard setup enables autonomy by default
/project:setup
/project:work 5
```

### What Happens
1. Setup creates permissive settings for worktrees
2. Each session gets its own isolated environment
3. Claude works without interruptions
4. PRs created when work is ready

## Reduction in Approvals

### Traditional Claude Code
```
20-30 approval requests per task:
- May I read this file?
- May I edit this file?
- May I run tests?
- May I commit?
- May I push?
```

### With Worktree Autonomy
```
0-2 approval requests per task:
- Only for operations outside the worktree
- Only for truly destructive operations
```

**Result**: 90-95% reduction in interruptions!

## Example Workflow

```bash
/project:work 5 --autonomous

Session 1: Working on feature/101-oauth
  ✓ Modified 12 files (no approval needed)
  ✓ Ran test suite 3 times (no approval needed)
  ✓ Fixed failing tests (no approval needed)
  ✓ Committed and pushed (no approval needed)
  ✓ Created PR #234 (no approval needed)
  
Session 2: Working on bugfix/102-nav-error
  ✓ Debugged issue (no approval needed)
  ✓ Applied fix (no approval needed)
  ✓ Added test case (no approval needed)
  ✓ All tests passing (no approval needed)
  ✓ Created PR #235 (no approval needed)
```

## Configuration Options

### Autonomy Levels

```bash
# Full autonomy (default)
/project:work --autonomous

# Traditional approval flow
/project:work --interactive

# Middle ground
/project:work --semi-autonomous
```

### Custom Permissions

Modify `.claude/templates/settings.worktree.json` to adjust permissions for your needs.

## Best Practices

1. **Let Claude work freely** - The worktree isolation makes it safe
2. **Review PRs carefully** - This is your quality gate
3. **Use branch protection** - Ensure main branch requires PR reviews
4. **Monitor progress** - Use `/project:status` to track work

## Troubleshooting

### Too many operations still need approval?
- Check that worktree settings are properly applied
- Ensure you're using the latest version
- Verify `.claude/settings.local.json` in worktrees

### Want more control?
- Use `--interactive` mode for sensitive work
- Customize permissions in settings template
- Set up additional branch protection rules

## The Future is Autonomous

With proper worktree isolation and permissive settings, Claude Code Parallel transforms from an interactive assistant to an autonomous development force. Start 10 sessions, grab coffee, and come back to 10 PRs ready for review!

This is the future of AI-assisted development - not constant approvals, but trusted autonomous work in safe environments.