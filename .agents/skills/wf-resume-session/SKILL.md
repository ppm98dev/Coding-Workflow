---
name: wf-resume-session
description: Restore context from previous session
---

# /wf-resume-session Workflow

<objective>
Start a new session with full context from where we left off.
</objective>

<process>

## 1. Load Saved State

Read `.quantis/STATE.md` completely.

**If STATE.md is missing or a stub (no `## Current Position` section):** do not invent a position. Reconstruct from durable evidence and say you are doing so:
1. `.quantis/ROADMAP.md` — the lowest non-Complete phase is the likely current phase.
2. `git log --oneline -15` — recent `feat(phase-N)`/`docs(phase-N)` commits show what was last worked on.
3. `.quantis/phases/` — a `*-PLAN.md` without a matching `*-SUMMARY.md` indicates an in-progress phase.
Present the reconstructed position to the user for confirmation before continuing. If nothing can be reconstructed, STOP and suggest `/wf-progress` or `/wf-new-project`.

---

## 2. Display Context

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► RESUMING SESSION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

LAST POSITION
─────────────
Phase: {phase from STATE.md}
Task: {task from STATE.md}
Status: {status when paused}

───────────────────────────────────────────────────────

CONTEXT FROM LAST SESSION
─────────────────────────
{Context dump content from STATE.md}

───────────────────────────────────────────────────────

BLOCKERS
────────
{Blockers from STATE.md, or "None"}

───────────────────────────────────────────────────────

NEXT STEPS (from last session)
──────────────────────────────
1. {First priority}
2. {Second priority}
3. {Third priority}

───────────────────────────────────────────────────────
```

---

## 3. Load Recent Journal

Show last entry from `.quantis/JOURNAL.md`:
- What was accomplished
- Handoff notes
- Any issues encountered

---

## 4. Check for Conflicts

```bash
# Check for uncommitted changes
git status --porcelain
```

**If changes found, run this procedure — do not just print a warning and continue:**
1. Compare each dirty file against STATE.md's In-Progress / "Files modified" list.
2. **Files listed in STATE.md** (expected work-in-progress): summarize `git diff` for each, then offer the user a choice — (a) commit as `wip(phase-N): resume checkpoint`, or (b) leave uncommitted and continue the task.
3. **Files NOT listed in STATE.md** (unexpected): show them and ASK the user what they are before doing anything — do not commit or revert on your own.
4. Wait for the user's decision before marking the session active (Step 5).
```
⚠️ UNCOMMITTED CHANGES DETECTED

{list of modified files}

Resolve via the procedure above before continuing.
```

---

## 5. Update State

Mark session as active in `.quantis/STATE.md`:
```markdown
**Status**: Active (resumed {timestamp})
```

---

## 6. Suggest Action

```
───────────────────────────────────────────────────────

▶ READY TO CONTINUE

Suggested action based on state:

{One of:}
• /wf-execute {N} — Continue phase execution
• /wf-verify {N} — Verify completed phase
• /wf-plan {N} — Create plans for phase
• /wf-progress — See full roadmap status

───────────────────────────────────────────────────────

💡 Fresh session = fresh perspective

You have all the context you need.
The previous struggles are documented.
Time to solve this with fresh eyes.

───────────────────────────────────────────────────────
```

</process>

<fresh_context_advantage>
A resumed session has advantages:

1. **No accumulated confusion** — You see the problem clearly
2. **Documented failures** — You know what NOT to try
3. **Hypothesis preserved** — Pick up where logic left off
4. **Full context budget** — 200k tokens of fresh capacity

Often the first thing a fresh context sees is the obvious solution that a tired context missed.
</fresh_context_advantage>
