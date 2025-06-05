# Add Issues to Work Queue

Add more GitHub issues to the active work queue.

Usage: /project:add ISSUES [OPTIONS]

Arguments: $ARGUMENTS

## What I'll Do

1. **Parse Issue Numbers**
   - Extract issue numbers from your input
   - Support formats: 123, #123, 123,124,125

2. **Analyze Issues**
   - Use Claude intelligence to break down each issue
   - Create 2-5 logical subissues per parent
   - Estimate complexity and dependencies

3. **Queue Subissues**
   - Add all subissues to the work queue
   - Assign priorities based on issue type
   - Maintain FIFO order within priority levels

## Options
- `--priority=LEVEL` - Override priority (critical|high|normal|low)
- `--analyze-only` - Show analysis without queuing

## Examples
```bash
# Add single issue
/project:add 150

# Add multiple issues  
/project:add 151,152,153

# Add with high priority
/project:add 154 --priority=high
```