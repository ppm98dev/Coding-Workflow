---
name: wf-pause
description: Context hygiene — dump state for clean session handoff
---

# /pause Workflow

<objective>
Safely pause work with complete state preservation for session handoff.
</objective>

<when_to_use>
- Ending a work session
- Context getting heavy (many failed attempts)
- Switching to a different task
- Before taking a break
- After 3+ debugging failures (Context Hygiene rule)
</when_to_use>

<process>

## 1. Capture Current State

Update `.quantis/STATE.md`:

```markdown
## Current Position
- **Phase**: {current phase number and name}
- **Task**: {specific task in progress, if any}
- **Status**: Paused at {timestamp}

## Last Session Summary
{What was accomplished this session}

## In-Progress Work
{Any uncommitted changes or partial work}
- Files modified: {list}
- Tests status: {passing/failing/not run}

## Blockers
{What was preventing progress, if anything}

## Context Dump
{Critical context that would be lost}:

### Decisions Made
- {Decision 1}: {rationale}
- {Decision 2}: {rationale}

### Approaches Tried
- {Approach 1}: {outcome}
- {Approach 2}: {outcome}

### Current Hypothesis
{Best guess at solution/issue}

### Files of Interest
- `{file1}`: {what's relevant}
- `{file2}`: {what's relevant}

## Next Steps
1. {Specific first action for next session}
2. {Second priority}
3. {Third priority}
```

---

## 2. Add Journal Entry

Create entry in `.quantis/JOURNAL.md`:

```markdown
## Session: {YYYY-MM-DD HH:MM}

### Objective
{What this session was trying to accomplish}

### Accomplished
- {Item 1}
- {Item 2}

### Verification
- [x] {What was verified}
- [ ] {What still needs verification}

### Paused Because
{Reason for pausing}

### Handoff Notes
{Critical info for resuming}
```

---

## 2.5. Reconcile ROADMAP.md

Check for phase-state drift between STATE.md/phase directories and ROADMAP.md:

For each non-Complete phase that has a directory in `.quantis/phases/`:
- If `VERIFICATION.md` exists and contains `verdict: PASS` → mark `✅ Complete` in ROADMAP (idempotent)
- If all `*-PLAN.md` files have matching `*-SUMMARY.md` but no `VERIFICATION.md` → leave status, set Next Steps to `/verify {N}`
- Otherwise → leave as-is

**Never** mark a phase Complete based on SUMMARYs alone — require a verdict-based VERIFICATION.md.

---

## 3. Commit State

```bash
git add .quantis/STATE.md .quantis/JOURNAL.md .quantis/ROADMAP.md
git commit -m "docs: pause session - {brief reason}"
```

---

## 4. Display Handoff

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► SESSION PAUSED ⏸
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

State saved to:
• .quantis/STATE.md
• .quantis/JOURNAL.md
• .quantis/ROADMAP.md (if reconciled in Step 2.5)

───────────────────────────────────────────────────────

To resume later:

/resume-session

───────────────────────────────────────────────────────

💡 Fresh context = fresh perspective
   The struggles end here. Next session starts clean.

───────────────────────────────────────────────────────
```

</process>

<context_hygiene>
If pausing due to debugging failures:

1. Be explicit about what failed
2. Document exact error messages
3. List files that were touched
4. State your hypothesis clearly
5. Suggest what to try next (different approach)

A fresh context often immediately sees solutions that a polluted context missed.
</context_hygiene>

<proactive_state_save>
## Proactive Auto-Save (Session Limit Protection)

**Problem:** If a session hard-terminates (usage/context limit), `/pause` becomes unreachable.

**Solution:** The agent MUST auto-save state BEFORE limits are hit. When any trigger in the table fires, writing the snapshot to `.quantis/STATE.md` is mandatory and comes BEFORE any message to the user.

### When to Auto-Save

| Trigger | Action |
|---------|--------|
| Observable proxies — any of: 20+ tool calls this session, 10+ files read in full, the platform reports a context warning, or you notice yourself re-reading files you already summarized | Write lightweight state snapshot to `.quantis/STATE.md` |
| 3-strike debugging rule fires | Save state dump BEFORE recommending `/pause` |
| Extended session detected | Periodic state checkpoints to `.quantis/STATE.md` |

### Auto-Save Protocol

1. **Detect** context health warning signals (see context-health-monitor skill)
2. **Write** current state to `.quantis/STATE.md` immediately
3. **Then** inform the user and recommend `/pause`
4. If session terminates unexpectedly, state is already saved

### Minimum Auto-Save Content

```markdown
## Auto-Save: {timestamp}
- **Phase**: {current phase}
- **Task**: {current task or "between tasks"}
- **Last Action**: {what was just completed}
- **Next Step**: {what should happen next}
```

**Key principle:** Save first, recommend second. Never rely on the user being able to issue `/pause`.
</proactive_state_save>
