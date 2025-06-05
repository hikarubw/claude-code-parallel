# Parse Issues into Task-Based Work Units

Convert GitHub issue checklists into granular tasks for parallel execution.

Usage: /project:setup-tasks [ISSUE_NUMBERS]

Arguments: $ARGUMENTS

## What I'll Do

### 1. Fetch Issue Details
- Get specified issues or all open issues if none specified
- Retrieve full issue bodies with checklists
- Identify issues with task lists (checkbox format)

### 2. Parse Task Checklists
- Extract checkbox items from issue descriptions
- Assign task IDs in format `#ISSUE-N` (e.g., `#47-1`)
- Preserve task descriptions and completion status
- Identify manual tasks (👤 prefix) vs automated tasks

### 3. Analyze Task Dependencies
- Look for dependency indicators in task text
- Common patterns: "after", "depends on", "requires", "blocked by"
- Create blocking relationships between tasks
- Ensure manual tasks block dependent automated tasks

### 4. Create Task Queue Entries
- Add each incomplete task to queue with `task add`
- Format: `#ISSUE-TASK|DESCRIPTION|STATUS|DEPENDENCIES`
- Set appropriate priorities based on:
  - Issue labels (bug = high, enhancement = medium)
  - Manual vs automated (manual = higher to unblock work)
  - Dependency chain position

### 5. Update Issue Tracking
- Store parsed task data in `.claude/tasks/issues/`
- Track task-to-issue mapping for PR updates
- Label issues with `has-tasks` for easy filtering

## Example Output
```
Parsing issues into tasks...

Issue #47: Implement authentication system
✓ Found 4 tasks in checklist
  - #47-1: Create database schema (automated)
  - #47-2: 👤 Get security review approval (manual)
  - #47-3: Implement login endpoint (automated, blocked by #47-2)
  - #47-4: Add session management (automated, blocked by #47-3)

Issue #48: Update documentation
✓ Found 2 tasks in checklist
  - #48-1: Generate API docs (automated)
  - #48-2: 👤 Review and approve docs (manual, blocked by #48-1)

Issue #49: Fix performance issues
✓ No checklist found - creating single task
  - #49-1: Fix performance issues (automated)

Summary:
- Parsed 3 issues into 7 tasks
- Added 4 automated tasks to queue
- Found 2 manual tasks blocking work
- Created 3 dependency relationships

Ready tasks in queue: #47-1, #48-1, #49-1
Blocked tasks: #47-3 (by #47-2), #47-4 (by #47-3), #48-2 (by #48-1)

Run /project:work to start parallel execution!
```

## Task Format Examples

### Simple Task
```markdown
- [ ] Add error handling to API endpoints
```
Becomes: `#50-1|Add error handling to API endpoints|pending|`

### Manual Task
```markdown
- [ ] 👤 Get design approval from team
```
Becomes: `#50-2|👤 Get design approval from team|manual|`

### Task with Dependencies
```markdown
- [ ] Deploy to staging (after security review)
```
Becomes: `#50-3|Deploy to staging|pending|blocked-by:#50-2`

### Completed Task (Skipped)
```markdown
- [x] Set up development environment
```
Not added to queue (already complete)

## Dependency Detection

I'll look for these patterns to identify dependencies:
- "after [task/issue reference]"
- "depends on [task/issue reference]"  
- "blocked by [task/issue reference]"
- "requires [task/issue reference]"
- Sequential numbering (task N blocks N+1 by default)
- Manual tasks block subsequent automated tasks

## Integration with Work Command

After setup-tasks completes:
1. `/project:work` will pick up tasks from the queue
2. Each task creates a branch: `task/#47-1-description`
3. PRs update the issue checklist when tasks complete
4. Manual tasks must be marked complete with `/project:manual`

## Tips
- Use `/project:status` to see parsed task breakdown
- Run setup-tasks periodically to catch new issues
- Tasks maintain issue context for accurate PRs
- Each task is a focused unit of work (<4 hours)