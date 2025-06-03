# Initialize Project for Parallel Development

Prepare your project for intelligent parallel development with Claude.

Usage: /project:setup

Arguments: $ARGUMENTS

## What I'll Do

### 1. Analyze Codebase Structure
- Scan all source files to understand architecture
- Read configuration files (package.json, etc.)
- Map module organization and dependencies
- Identify test patterns and CI/CD setup

### 2. Fetch and Analyze GitHub Issues
- Get all open issues with full details
- If no issues exist, help create initial task breakdown
- Analyze issue descriptions and checklists

### 3. Complexity Assessment
- Estimate work required for each issue
- Identify issues needing breakdown (>4 hours)
- Detect dependencies between issues
- Assess risk levels (UI, logic, data, security)

### 4. Create/Update Issues
- Break complex issues into sub-tasks using `github split`
- Add appropriate labels:
  - `claude-work` for automated tasks
  - `manual-work` for human tasks (prefix with 👤)
  - Size labels: `size-xs` (<1hr), `size-s` (1-2hr), `size-m` (2-4hr)
- Track dependencies with `task block`

### 5. Prepare Work Queue
- Add all ready issues to queue with `task add`
- Prioritize based on dependencies
- Separate manual vs automated work
- Set up blocking relationships

## Example Output
```
Analyzing codebase...
✓ Found TypeScript project with 127 files
✓ Detected Jest tests and GitHub Actions CI

Fetching GitHub issues...
✓ Found 47 open issues

Breaking down complex issues...
✓ Created 23 sub-issues for large tasks
✓ Added size labels to all issues

Identifying dependencies...
✓ Found 8 blocking relationships
✓ 5 manual tasks block automated work

Preparing work queue...
✓ Added 35 automated tasks to queue
✓ Prioritized based on dependencies

Setup complete! Ready for parallel execution.
- Total tasks: 47 (12 manual, 35 automated)
- Blocked tasks: 8 (waiting on manual work)
- Ready to start: 27

Run /project:work to begin parallel development!
```

## Next Steps
After setup completes:
1. Review manual tasks with `/project:manual`
2. Start parallel work with `/project:work`
3. Monitor progress with `/project:status`