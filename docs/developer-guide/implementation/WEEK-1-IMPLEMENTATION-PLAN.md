# Week 1 Implementation Plan: Complete Pueue Migration

## Objective
Remove all file-based queue code and migrate 100% to Pueue by end of week.

## Day 1: Fix Immediate Issues
### Morning
- [ ] Fix `setup-hybrid` script error handling
  - Add proper error checking for queue-pueue init
  - Make Pueue group creation idempotent
  - Test with clean slate

### Afternoon  
- [ ] Debug worker session creation
  - Ensure grid-manager creates session properly
  - Fix pane numbering issues
  - Add session verification

### Testing
```bash
# Clean test
pueue reset -f
tmux kill-server
./tools/setup-hybrid 4
# Should work without errors
```

## Day 2: Complete Queue Migration
### Morning
- [ ] Update `tools/analyze` 
  - Direct Pueue integration
  - Remove queue file writes
  - Add proper error handling

### Afternoon
- [ ] Update `/commands/work.js`
  - Remove file queue references
  - Use Pueue commands directly
  - Maintain simple interface

### Code Changes
```javascript
// Before
await queue.add(priority, parent, subissue);

// After  
await pueue.add({
  group: 'subissues',
  label: `subissue-${id}`,
  priority,
  command: `process_subissue ${id}`
});
```

## Day 3: Worker Improvements
### Morning
- [ ] Enhance `hybrid-worker`
  - Better error recovery
  - Cleaner status updates
  - Progress reporting

### Afternoon
- [ ] Create worker health checks
  - Auto-restart dead workers
  - Log rotation
  - Performance metrics

### Key Features
```bash
# Worker should handle:
- Pueue connection failures
- Claude crashes gracefully  
- Auto-cleanup of worktrees
- Status reporting to monitor
```

## Day 4: Monitoring & UI
### Morning
- [ ] Improve monitoring dashboard
  - Real-time Pueue status
  - Worker health indicators
  - Queue depth graphs

### Afternoon
- [ ] Create status command
  - Unified view of system
  - Quick health check
  - Debugging information

### Dashboard Layout
```
┌─────────────────────────────┐
│ Claude Workers Status       │
├─────────────────────────────┤
│ Queue: 12 pending           │
│ Workers: 4/4 healthy        │
│ Completed: 47 tasks         │
│ Failed: 2 tasks             │
├─────────────────────────────┤
│ Current Activity:           │
│ W1: #201 analyzing...       │
│ W2: #202 coding...          │
│ W3: #203 testing...         │
│ W4: idle                    │
└─────────────────────────────┘
```

## Day 5: Testing & Documentation
### Morning
- [ ] Comprehensive testing
  - Start with 0 tasks → 50 tasks
  - Kill workers randomly
  - Restart Pueue daemon
  - Network interruptions

### Afternoon
- [ ] Update documentation
  - New architecture diagrams
  - Troubleshooting guide
  - FAQ section

### Test Scenarios
1. Happy path: 10 subissues
2. Worker crash during execution
3. Pueue daemon restart
4. 100+ task queue
5. Mixed priorities
6. Failed tasks retry

## Success Criteria

### Technical
- [ ] Zero file queue usage
- [ ] All commands use Pueue
- [ ] Workers resilient to failures
- [ ] Monitoring accurate

### User Experience  
- [ ] `/project:work` still simple
- [ ] Better visibility than before
- [ ] Clear error messages
- [ ] Smooth setup process

### Performance
- [ ] Handle 100+ tasks
- [ ] Worker startup < 2s
- [ ] Monitor refresh < 100ms
- [ ] No memory leaks

## Daily Checklist

### Morning Standup (self)
- What worked yesterday?
- What's blocking today?
- What's the goal today?

### Evening Review
- Did I meet the goal?
- What surprised me?
- What needs adjustment?

### Metrics to Track
- Lines of code removed
- Test coverage %
- Setup success rate
- Task completion rate

## Contingency Plans

### If Pueue Integration Fails
- Keep minimal file queue shim
- Focus on hybrid improvement
- Document limitations

### If Time Runs Short
- Prioritize core migration
- Polish can wait for week 2
- Focus on working > perfect

## End of Week 1 Deliverable

**A working system where:**
1. Users run `/project:work #123`
2. Claude analyzes into subissues
3. Pueue manages the queue
4. Workers visible in tmux
5. Everything "just works"

No more file queues. Pure Pueue. Full visibility.

---

*"Week 1 is about making it work. Week 2 is about making it beautiful."*