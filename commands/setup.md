# Initialize Project for Task-Based Parallel Development

Prepare your project for intelligent task-based parallel development with Claude.

Usage: /project:setup

Arguments: $ARGUMENTS

## What I'll Do

### 1. Analyze Codebase Structure
- Scan all source files to understand architecture
- Read configuration files (package.json, etc.)
- Map module organization and dependencies
- Identify test patterns and CI/CD setup
- **Extended thinking**: For complex architectures, I'll think deeply about component relationships

### 2. Create or Fetch GitHub Issues
- Check for existing open issues
- If no issues exist, help create high-level issues (features/bugs)
- Issues are containers for related tasks, not individual work items
- Fetch full issue details including existing checklists

### 3. Break Down Issues into Tasks
- Analyze each issue to identify discrete tasks
- Create or update checklist in issue body/comments
- Separate tasks into:
  - `claude-work`: Automated development tasks
  - `manual-work`: Human tasks (prefixed with 👤)
- Each task should be 1-4 hours of work
- Ensure tasks are independent when possible

### 4. Task Complexity Assessment
- Estimate effort for each task (not whole issues)
- Identify task dependencies within and across issues
- Detect blocking manual tasks
- Assign task IDs in format `#<issue>-<task>` (e.g., #47-3)

### 5. Prepare Task Queue
- Extract all tasks from issue checklists
- Add tasks to queue with `task add`
- Set up dependency relationships
- Prioritize based on:
  - Unblocked tasks first
  - Manual tasks that unblock others
  - Logical development order

## New Architecture: Task-Based Parallelism

Instead of creating sub-issues, we now:
- Use issues as containers for related work
- Break work into checklist tasks within issues
- Each checklist item becomes a parallel work unit
- PRs update checklist items, not close issues
- Issues close only when all tasks complete

## Example Output
```
Analyzing codebase...
✓ Found TypeScript project with 127 files
✓ Detected Jest tests and GitHub Actions CI

Fetching GitHub issues...
✓ Found 12 open issues
✓ No issues found - creating initial issues...

Breaking down into tasks...
Issue #1: User Authentication
  ✓ Created 6 tasks (4 claude-work, 2 manual-work)
Issue #2: API Rate Limiting  
  ✓ Created 4 tasks (3 claude-work, 1 manual-work)

Analyzing task dependencies...
✓ Identified 5 task dependencies
✓ 3 manual tasks block automated work

Preparing task queue...
✓ Added 23 tasks to queue
✓ 14 tasks ready to start
✓ 9 tasks blocked

Setup complete! Ready for task-based parallel execution.
- Total tasks: 23 (7 manual, 16 automated)
- Ready to start: 14
- Blocked tasks: 9

Run /project:work to begin parallel development!
```

## Task Checklist Format

Tasks are added to issues as markdown checklists:

```markdown
## Tasks

### Claude Work
- [ ] Implement user model and database schema
- [ ] Create authentication service with JWT
- [ ] Add login/logout API endpoints
- [ ] Write unit tests for auth service

### Manual Work  
- [ ] 👤 Choose authentication strategy (OAuth vs local)
- [ ] 👤 Set up authentication provider credentials
```

## Extended Thinking Usage
When dealing with complex projects, leverage Claude Code's extended thinking:
- Say "think about the architecture" for deep codebase analysis
- Say "think harder about dependencies" for intricate relationships
- Say "think more" if initial analysis seems incomplete

📚 **Reference**: [Extended Thinking in Claude Code](https://docs.anthropic.com/en/docs/claude-code/tutorials#extended-thinking)

## Next Steps
After setup completes:
1. Review manual tasks with `/project:manual`
2. Start parallel work with `/project:work`
3. Monitor task progress with `/project:status`