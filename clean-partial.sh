#!/bin/bash
# Partial history cleanup - removes oauth references

set -e

echo "Cleaning OAuth references from history..."

# Remove files from all history
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch tools/oauth-setup commands/setup-oauth.md .github/workflows/claude.yml SUMMARY.md' \
  --prune-empty --tag-name-filter cat -- --all

# Clean up
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo "✅ OAuth references removed from history"
echo ""
echo "To push (force required):"
echo "  git push -f origin main"