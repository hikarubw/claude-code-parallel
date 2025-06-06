# Task-Based Parallelism Architecture

## Overview

This document describes the redesigned architecture for claude-code-parallel, shifting from issue-based to task-based parallelism. This approach treats GitHub issues as containers for related tasks (checklist items), with each task becoming an independent unit of parallel work.

## Core Concepts

### Issues as Task Containers
- GitHub issues represent features, bugs, or epics
- Each issue contains multiple tasks as checklist items
- Issues remain open while tasks are being completed
- Issues close only when all tasks are done

### Tasks as Work Units
- Tasks are checklist items within issue bodies or comments
- Each task is small, independent, and completable in 1-4 hours
- Tasks are clearly marked as `claude-work` or `manual-work`
- Each task gets its own branch, worktree, and PR

### Task Identification
- Format: `#<issue>-<task>` (e.g., `#47-3` for issue 47, task 3)
- Tasks numbered by order of appearance in issue
- Unique across the entire repository

## Workflow

### 1. Issue Creation Phase
```
User creates issue → Claude analyzes complexity → Claude adds task checklist
```

Example issue body:
```markdown
## Overview
Implement user authentication system

## Tasks
### Claude Work
- [ ] Create auth database schema
- [ ] Implement JWT token generation
- [ ] Add login/logout endpoints
- [ ] Create auth middleware

### Manual Work
- [ ] 👤 Choose authentication provider
- [ ] 👤 Set up OAuth credentials
```

### 2. Task Extraction Phase
```
Claude parses issues → Extracts checklist items → Creates task queue
```

Task metadata:
- Task ID: `#1-1`
- Title: "Create auth database schema"
- Type: `claude-work` or `manual-work`
- Status: `pending`, `in-progress`, `completed`
- Dependencies: Other task IDs that must complete first

### 3. Parallel Execution Phase
```
Claude picks task → Creates worktree → Makes changes → Creates PR
```

Branch naming: `task/#1-1-auth-database-schema`
PR title: `Task #1-1: Create auth database schema`
PR body includes: `Updates checklist item 1 in #1`

### 4. PR Merge Phase
```
Human reviews PR → Merges → GitHub Action updates checklist
```

Automation updates the specific checklist item to checked.

## Tool Redesigns

### GitHub Tool (`tools/github`)

New commands:
```bash
# Extract tasks from an issue
github get-tasks <issue-number>
# Output: JSON array of task objects

# Update checklist item
github update-task <issue-number> <task-number> [check|uncheck]

# Get task details
github get-task <issue-number> <task-number>
```

### Task Tool (`tools/task`)

Queue format changes:
```
#1-1|Create auth database schema|claude-work|pending
#1-2|Implement JWT token generation|claude-work|pending|blocked-by:#1-1
#1-3|Choose authentication provider|manual-work|pending
```

New commands:
```bash
# Add task from issue
task add <issue-number> <task-number>

# List tasks by issue
task list-issue <issue-number>

# Update task status
task update <task-id> <status>
```

### Session Tool (`tools/session`)

Changes:
- Branch names: `task/#<issue>-<task>-<slug>`
- Worktree names: `task-<issue>-<task>`
- PR descriptions reference checklist items

## Benefits

1. **Better Organization**: Related tasks stay together in one issue
2. **Less GitHub Noise**: Fewer issues, cleaner issue tracker
3. **Progress Visibility**: See completion status at a glance
4. **Natural Hierarchy**: Issues → Tasks → PRs
5. **Flexible Scope**: Easy to add/remove tasks from issues
6. **Dependency Management**: Tasks can depend on other tasks within or across issues

## Migration Strategy

1. Existing issue-based projects continue to work
2. New projects use task-based approach
3. Provide migration tool to convert sub-issues to tasks
4. Both approaches can coexist during transition

## Implementation Priority

1. **Phase 1**: Core task extraction and queue management
2. **Phase 2**: PR automation for checklist updates
3. **Phase 3**: Enhanced dependency tracking
4. **Phase 4**: Progress visualization and analytics

## Example: Full Workflow

1. **Create Issue**:
```markdown
Title: Add Dark Mode Support

## Tasks
### Claude Work
- [ ] Create theme context provider
- [ ] Update color tokens for dark theme
- [ ] Add theme toggle component
- [ ] Update all components for theme support

### Manual Work
- [ ] 👤 Design dark color palette
- [ ] 👤 Get design approval
```

2. **Setup extracts tasks**:
```
#10-1: Create theme context provider [claude-work]
#10-2: Update color tokens for dark theme [claude-work, blocked-by:#10-5]
#10-3: Add theme toggle component [claude-work]
#10-4: Update all components for theme support [claude-work, blocked-by:#10-2]
#10-5: Design dark color palette [manual-work]
#10-6: Get design approval [manual-work, blocked-by:#10-5]
```

3. **Parallel execution** starts with unblocked tasks (#10-1, #10-3, #10-5)

4. **PRs created**:
- PR #101: "Task #10-1: Create theme context provider"
- PR #102: "Task #10-3: Add theme toggle component"

5. **Progress tracked** in original issue with checklist updates

This architecture provides a cleaner, more scalable approach to parallel development while maintaining full traceability and progress visibility.