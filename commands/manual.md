# Manual Work Management

Manage manual work queue with blocking detection and status tracking.

Usage: /user:manual [action] [args]

Arguments: $ARGUMENTS

## Actions

### show (default)
Display enhanced manual work dashboard with:
- 🚨 Tasks blocking automated work (priority)
- 📊 Status tracking (pending/in-progress/completed)
- ⏰ Task age and assignments
- 🔗 Blocking relationships

### start ISSUE
Mark manual task as in-progress:
- Update status tracking
- Show what automated work will be unblocked
- Track start time

### complete ISSUE  
Mark manual task as completed:
- Update status to completed
- Check what automated work is now unblocked
- Suggest next actions

### help ISSUE
Get detailed guidance for manual task:
- Fetch full issue details
- Analyze requirements
- Provide step-by-step help
- Offer to create needed files

### refresh
Regenerate manual work analysis:
- Re-analyze all manual tasks
- Update blocking relationships
- Refresh priority ordering

## Example Usage
```
/user:manual show

🚨 HIGH PRIORITY - Blocking automated work:
  #45: 👤 Setup OAuth credentials (blocks 3 tasks)
      Status: pending | Age: 2 hours | Blocks: #46, #47, #48

📋 Other manual tasks:
  #52: 👤 Deploy to staging
      Status: in-progress | Started: 10 min ago

/user:manual start 45
Starting work on #45...
This will unblock 3 automated tasks when complete.

/user:manual complete 45  
Completed #45! 
Unblocked: #46, #47, #48
Run /user:execute to work on unblocked tasks.
```

## Tools Used
- `github issues` - Fetch manual tasks
- `blocking blocks` - Check dependencies
- `queue` - Manage work queue
- `approve` - Track completion status