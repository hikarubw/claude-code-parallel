# Manual Task Management

Manage manual tasks within issues with dependency tracking and status updates.

Usage: /project:manual [action] [args]

Arguments: $ARGUMENTS

## Actions

### show (default)
Display enhanced manual task dashboard with:
- 🚨 Tasks blocking automated work (priority)
- 📊 Task status within issues
- ⏰ Task age and context
- 🔗 Task dependencies and blocking

### start TASK-ID
Mark manual task as in-progress:
- Update task status in issue checklist
- Show what automated tasks will be unblocked
- Track start time

### complete TASK-ID  
Mark manual task as completed:
- Check off task in issue checklist
- Identify newly unblocked tasks
- Suggest next automated tasks

### help TASK-ID
Get detailed guidance for manual task:
- Show full task context from issue
- Analyze requirements
- Provide step-by-step help
- Offer to create needed files/configs

### refresh
Re-analyze all manual tasks:
- Parse latest issue checklists
- Update task dependencies
- Refresh priority ordering

## Task ID Format
Tasks use `#issue-task` format (e.g., `#10-5` for issue 10, task 5)

## Example Usage
```
/project:manual show

🚨 HIGH PRIORITY - Blocking automated tasks:
  
Issue #10: Dark Mode Support
  #10-5: 👤 Design dark color palette
         Status: pending | Blocks: #10-2, #10-4
         
Issue #11: Authentication System  
  #11-1: 👤 Choose authentication strategy
         Status: pending | Blocks: #11-3, #11-4, #11-5
         Age: 2 hours

📋 Other manual tasks:

Issue #12: Documentation Update
  #12-6: 👤 Review and approve docs
         Status: in-progress | Started: 10 min ago
         No tasks blocked

/project:manual start #10-5
Starting work on #10-5 (Design dark color palette)...
This will unblock 2 automated tasks when complete:
- #10-2: Update color tokens for dark theme
- #10-4: Update all components for theme

/project:manual complete #10-5  
✓ Completed #10-5!
Updated checklist in issue #10
Unblocked tasks: #10-2, #10-4
Run /project:work to start automated tasks.
```

## Manual Task Workflow

1. **Identify** - Use `show` to see all manual tasks
2. **Prioritize** - Focus on tasks blocking most work
3. **Start** - Mark task as in-progress
4. **Complete** - Check off when done
5. **Continue** - Automated tasks can now proceed

## Integration with Issues

Manual tasks are tracked as checklist items:
```markdown
## Tasks
### Manual Work
- [x] 👤 Choose authentication strategy
- [ ] 👤 Set up OAuth credentials
```

Completing manual tasks updates the checklist automatically.

## Tips
- Complete blocking manual tasks first
- Use `help` for guidance on complex tasks
- Manual tasks often unlock multiple automated tasks
- Check issue comments for additional context