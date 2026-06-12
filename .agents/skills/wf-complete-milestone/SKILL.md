---
name: wf-complete-milestone
description: Mark current milestone as complete and archive
---

# /complete-milestone Workflow

<objective>
Finalize the current milestone, archive documentation, and prepare for next milestone.
</objective>

<process>

## 1. Verify All Phases Complete

```bash
# Scope to the CURRENT milestone only — archived (⏸ CLOSED/SUPERSEDED) sections above contain
# stale "Not Started"/"In Progress" text that would false-positive against the whole file.
INCOMPLETE=$(sed -n '/Current Milestone/,$p' ".quantis/ROADMAP.md" | grep -c -E "Status.*Not Started|Status.*In Progress" || true)
if [ "$INCOMPLETE" -gt 0 ]; then
    echo "❌ STOP: Cannot complete milestone — $INCOMPLETE phases incomplete."
    echo "Run /progress to see status."
    exit 1
fi
```

**If ANY phase is incomplete: STOP.** Do not proceed to verification or archiving.

---

## 2. Run Final Verification

Verify all must-haves from ROADMAP.md:
- Run verification commands
- Capture evidence
- Create VERIFICATION.md if not exists

**GATE:** If any must-have FAILS verification, STOP. Do not generate the summary (Step 3), archive (Step 4 — destructive), reset (Step 5), or tag (Step 6). Report which must-haves failed and route to `/verify {N}` or `/execute {N} --gaps-only`, then re-run /complete-milestone once they pass.

---

## 3. Generate Milestone Summary

Create `.quantis/milestones/{name}-SUMMARY.md`:

```markdown
# Milestone: {name}

## Completed: {date}

## Deliverables
- ✅ {must-have 1}
- ✅ {must-have 2}

## Phases Completed
1. Phase 1: {name} — {date}
2. Phase 2: {name} — {date}
...

## Metrics
- Total commits: {N}
- Files changed: {M}
- Duration: {days}

## Lessons Learned
{Auto-extract from DECISIONS.md and JOURNAL.md}
```

---

## 4. Archive Current State

```bash
# Create milestone archive
mkdir -p ".quantis/milestones/{name}"

# Move phase-specific files
mv .quantis/phases/* ".quantis/milestones/{name}/"

# Archive decisions and journal (prevent monolithic growth across milestones)
[ -f ".quantis/DECISIONS.md" ] && cp ".quantis/DECISIONS.md" ".quantis/milestones/{name}/DECISIONS.md"
[ -f ".quantis/JOURNAL.md" ] && cp ".quantis/JOURNAL.md" ".quantis/milestones/{name}/JOURNAL.md"

# GATE: confirm the archive received the files before any reset
if [ -z "$(ls -A ".quantis/milestones/{name}/" 2>/dev/null)" ] || [ -n "$(ls -A .quantis/phases 2>/dev/null)" ]; then
    echo "❌ STOP: archive incomplete — .quantis/phases still has contents or the milestone dir is empty."
    echo "Do not proceed to Step 5 (reset). Investigate the mv/mkdir before continuing."
    exit 1
fi
```

**If the STOP line printed: halt.** Step 5 resets ROADMAP.md, DECISIONS.md, and JOURNAL.md — never reset until this guard confirms the archive received the files.

---

## 5. Reset for Next Milestone

Clear ROADMAP.md phases section (keep header).
Edit `.quantis/STATE.md` IN PLACE (canonical schema in `.quantis/templates/state.md`) — set:
```markdown
## Current Position
- **Phase**: —
- **Task**: Milestone {name} complete and archived
- **Status**: Milestone complete — ready for /new-milestone
```

**Reset DECISIONS.md** — replace contents with a fresh header referencing the archive:

```markdown
# Decisions

> Previous milestone decisions archived in `.quantis/milestones/{name}/DECISIONS.md`

---
```

**Reset JOURNAL.md** — replace contents with a fresh header:

```markdown
# Journal

> Previous milestone journal archived in `.quantis/milestones/{name}/JOURNAL.md`

---
```

---

## 5c. Refresh Architecture

Update `.quantis/ARCHITECTURE.md` to reflect the current state of the codebase after the milestone:

1. **Scan the project** — identify new components, removed modules, changed dependencies
2. **Update the architecture diagram** — reflect structural changes from this milestone
3. **Update `.quantis/STACK.md`** (if it exists) — refresh technology and dependency information; skip if the project doesn't maintain one
4. **Keep it lean** — remove details about components that no longer exist; summarize, don't accumulate

> This prevents ARCHITECTURE.md from becoming stale or bloated across milestones (addresses the issue where architecture only updates via `/map`).

---

## 5d. Update Requirements

If `.quantis/REQUIREMENTS.md` exists, mark completed requirements:

1. Read each requirement's status
2. Cross-reference with milestone deliverables and verification results
3. Mark satisfied requirements as `Complete`
4. Mark deferred items as `Deferred` with reason
5. Archive the requirements snapshot into `.quantis/milestones/{name}/REQUIREMENTS.md`

---

## 6. Commit and Tag

```bash
git add -A
git commit -m "docs: complete milestone {name}"
git tag -a "{name}" -m "Milestone {name} complete"
```

---

## 7. Display Completion

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► MILESTONE COMPLETE 🎉
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{name}

Phases: {N} completed
Tag: {name}

───────────────────────────────────────────────────────

▶ NEXT

/new-milestone — Start next milestone
/audit-milestone {name} — Review this milestone

───────────────────────────────────────────────────────
```

</process>
