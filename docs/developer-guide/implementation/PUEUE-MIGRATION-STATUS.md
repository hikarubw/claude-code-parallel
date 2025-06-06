# Pueue Migration Status

## Overview
This document tracks the migration from file-based queue to pure Pueue backend as per issue #16.

## Completed ✅

### 1. Created `pueue-wrapper` Tool
- Location: `/tools/pueue-wrapper`
- Provides unified interface for all Pueue operations
- Replaces file-based queue with pure Pueue backend
- Features:
  - Add tasks with priority and metadata
  - Get next task
  - Update task status
  - Show queue status
  - Retry failed tasks
  - Clean old tasks
  - Monitor queue
  - Export queue data

### 2. Updated `analyze` Tool
- Modified to use `pueue-wrapper` instead of file-based queue
- Function `queue_subissues()` now calls `pueue-wrapper add`

### 3. Updated `hybrid-worker` Tool
- Modified to extract parent issue from Pueue metadata
- Uses `pueue-wrapper` for status updates
- Removed dependency on file-based queue

### 4. Updated `setup-hybrid` Tool
- Uses `pueue-wrapper` instead of `queue-pueue`
- Removed migration logic (no longer needed)
- Updated all references to use correct paths

### 5. Updated `demo-hybrid` Tool
- Uses `pueue-wrapper` for all queue operations
- Demonstrates pure Pueue backend capabilities

### 6. Created `process_subissue` Helper
- Placeholder script called by Pueue tasks
- Allows hybrid-worker to identify and process tasks

### 7. Fixed `pueue-wrapper` Implementation
- Proper status formatting for Pueue's JSON structure
- Correct path resolution for process_subissue
- Tested basic operations (add, status, clean)

## Remaining Tasks 🚧

### 1. Update `worker` Tool
- Currently still uses file-based queue (`tools/queue`)
- Needs to be updated to use `pueue-wrapper`
- Or mark as deprecated in favor of `hybrid-worker`

### 2. Update Command Documentation
- `/commands/work.md` - Update queue management examples
- `/commands/status.md` - Update to show Pueue status
- `/commands/add.md` - Update to use `pueue-wrapper`

### 3. Remove/Archive Old Queue Tools
- `tools/queue` - File-based queue (to be archived)
- `tools/queue-pueue` - Hybrid adapter (no longer needed)

### 4. Update Project Documentation
- Update CLAUDE.md to reflect pure Pueue backend
- Update architecture documentation
- Update user guides

### 5. Testing
- Test complete workflow with pure Pueue backend
- Verify priority handling (Pueue uses inverted priority)
- Test worker pool with multiple workers
- Verify auto-approval still works

## Priority Handling Note
Pueue uses inverted priority where higher numbers = higher priority.
Our wrapper handles this conversion:
- User priority 1 (highest) → Pueue priority 9
- User priority 2 → Pueue priority 8
- User priority 3 → Pueue priority 7
- User priority 4 (lowest) → Pueue priority 6

## Migration Benefits
1. **Single Source of Truth**: Pueue is the only queue system
2. **Better Persistence**: Pueue handles crashes gracefully
3. **Advanced Features**: Dependencies, scheduling, groups
4. **Cleaner Architecture**: No file locking or sync issues
5. **Better Monitoring**: Built-in Pueue tools

## Implementation Details

### Pueue Task Structure
Each task in Pueue has:
- **Label**: `subissue-{ID}` for identification
- **Group**: `subissues` for isolation
- **Priority**: Inverted (10 - user_priority)
- **Command**: Calls `process_subissue` with subissue and parent IDs

### Worker Flow
1. `hybrid-worker` polls Pueue for queued tasks
2. Extracts task info from Pueue JSON
3. Starts the task in Pueue (marks as running)
4. Runs Claude in visible tmux pane
5. Updates task status based on PR creation

### Key Changes from File-Based Queue
- No file locking needed
- No manual queue synchronization
- Automatic persistence and recovery
- Built-in task dependencies and scheduling
- Native status monitoring

## Next Steps
1. Complete remaining tool updates
2. Test end-to-end workflow
3. Update all documentation
4. Archive old queue-related code
5. Create user migration guide

## Testing Commands
```bash
# Initialize Pueue
./tools/pueue-wrapper init

# Add test task
./tools/pueue-wrapper add 1 "123" "999"

# Check status
./tools/pueue-wrapper status

# Monitor live
./tools/pueue-wrapper monitor

# Clean up
pueue clean --group subissues
```