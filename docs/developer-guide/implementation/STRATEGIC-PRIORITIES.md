# Strategic Priorities & Key Decisions

## The Ultrathinking Synthesis

After deep analysis, here are the strategic priorities in order:

## Priority 1: Make Current Architecture Rock Solid (Week 1)
**Why First**: Can't extract what doesn't work perfectly

### Critical Path
1. Fix setup-hybrid → Enable users
2. Complete Pueue migration → Remove complexity  
3. Stabilize workers → Reliable execution
4. Polish monitoring → User confidence

### Success = 
Users can run `/project:work` and it ALWAYS works

## Priority 2: Extract Pueue-TUI Clean (Weeks 2-3)
**Why Second**: Need stable base before extraction

### Key Decisions
- **Name**: "Pueue-TUI" (Tmux + Queue) is perfect
- **Scope**: Start minimal - just visualization
- **Language**: Bash first, TypeScript later
- **License**: MIT for maximum adoption

### MVP Features Only
1. Start workers in tmux
2. Poll Pueue for tasks
3. Basic monitoring
4. Auto-response system

**NOT in v0.1**: Recording, AI, distributed, web UI

## Priority 3: Community Building (Weeks 4-6)
**Why Third**: Tool must work before promotion

### Launch Strategy
1. **Soft Launch**: Pueue community first
2. **Blog Post**: "Making Pueue Visible"
3. **Show HN**: With live demo
4. **Video**: 5-minute walkthrough

### Community Priorities
- Respond to EVERY issue in < 24h
- Accept good PRs quickly
- Weekly releases initially
- Clear roadmap communication

## Priority 4: Claude Tools Simplification (Weeks 7-8)
**Why Fourth**: Pueue-TUI must be proven first

### Migration Strategy
- Keep backward compatibility
- Gradual internal migration
- User commands unchanged
- Document the journey

### End State
```
Before: 50+ files, complex queue logic
After: 10 files, delegates to Pueue-TUI
```

## Key Strategic Decisions

### 1. Open Source Everything
**Decision**: Both Claude Code Parallel and Pueue-TUI fully open
**Why**: 
- Builds trust
- Enables contributions
- Faster improvement
- No secrets in dev tools

### 2. Terminal-First, Web Later
**Decision**: No web UI in v1
**Why**:
- Faster to market
- Core users want terminal
- Web can be added later
- Focus on doing one thing well

### 3. Pueue Integration, Not Fork
**Decision**: Work with Pueue, not replace it
**Why**:
- Pueue is excellent at queuing
- We add visualization layer
- Mutual benefit
- Easier adoption

### 4. AI Features in Phase 2
**Decision**: No AI features in Pueue-TUI v1
**Why**:
- Core value is visualization
- AI adds complexity
- Let community drive AI needs
- Can add later

### 5. Free Forever Core
**Decision**: Core Pueue-TUI always free
**Why**:
- Developer tools should be accessible
- Builds largest community
- Can monetize enterprise features later
- Trust > Revenue initially

## What We're NOT Doing

### Not Building
- ❌ Web dashboard (v1)
- ❌ Cloud service (v1)
- ❌ IDE plugins (v1)
- ❌ Mobile app
- ❌ Pueue replacement

### Not Prioritizing  
- ❌ Enterprise features
- ❌ Perfect code
- ❌ 100% coverage
- ❌ Complex features
- ❌ Monetization

## Success Metrics That Matter

### Week 1
- Setup works: Yes/No
- Workers stable: Yes/No
- Users happy: Yes/No

### Month 1  
- Pueue-TUI stars: 100+
- NPM downloads: 1000+
- Community PRs: 5+

### Month 3
- Production users: 10+
- Weekly downloads: 10K+
- Contributors: 20+

### Month 6
- Pueue recommends Pueue-TUI
- Conference talk accepted
- Enterprise inquiry

## The North Star Question

For every decision ask:
> "Does this make task execution more visible?"

If NO → Don't do it
If MAYBE → Defer it
If YES → Do it now

## Risk-Ordered Priorities

### High Risk, High Priority
1. Pueue API stability
2. Tmux compatibility
3. Cross-platform support

### Medium Risk, Medium Priority
1. Performance at scale
2. Documentation quality
3. Community adoption

### Low Risk, Low Priority
1. Perfect architecture
2. Feature completeness
3. Code beauty

## The Minimum Viable Success

By end of Week 8:
1. **Claude Code Parallel**: Works flawlessly with Pueue
2. **Pueue-TUI**: Adopted by 100+ developers
3. **Community**: Active and growing

Everything else is bonus.

## The One Decision That Matters

**Build for the developers debugging AI agents at 3am.**

They need:
- To see what happened
- To understand why
- To fix it quickly

Everything else follows from this.

---

*"Ultrathinking reveals: Simplicity and visibility trump features and complexity."*