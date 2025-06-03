# Architecture Memo

## Current: Issue-Based
- One issue = One worktree
- Simple but limited parallelism

## Chosen: Task-Based ✓
- Issues contain task checklists
- Each checkbox = parallel work unit
- Natural GitHub workflow
- **Implementation: 3 weeks, ~40 hours**

## Future Options
1. **Dependency Graph** - Automatic work discovery from code analysis
2. **Emergent Swarm** - Self-organizing agents with no central control
3. **Intent-Directed** - Focus on business value, not just code

## Decision
Task-based provides best balance of simplicity and power for immediate needs.