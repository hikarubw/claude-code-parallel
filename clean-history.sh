#!/bin/bash
# Script to create a clean git history for public release

set -e

echo "⚠️  WARNING: This will rewrite git history!"
echo "Make sure you have a backup of your repository."
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 1
fi

# Create a new temporary branch
git checkout -b clean-history

# Remove all history and create new initial commit
rm -rf .git
git init
git add .
git commit -m "Initial commit: Claude Code Parallel - Parallel development automation for Claude Code

Features:
- Parallel task execution with tmux sessions
- Git worktree isolation for each task
- Task queue with dependency management
- GitHub issue breakdown and automation
- Intelligent cleanup and maintenance

Tools:
- task: Queue and dependency management
- session: Parallel tmux/worktree control
- github: Issue operations
- maintain: Cleanup utilities

This is a personal project for enhancing Claude Code workflows."

# Add remote
git remote add origin git@github.com:hikarubw/claude-code-parallel.git

# Set main branch
git branch -M main

echo ""
echo "✅ Clean history created!"
echo ""
echo "To push (this will overwrite remote):"
echo "  git push -f origin main"
echo ""
echo "⚠️  This is a force push - make sure the repo is still private!"