---
name: wf-sprint
description: Create and manage a time-boxed sprint for quick focused work
argument-hint: "[new|status|close] [sprint-name]"
---

# /wf-sprint Workflow

<objective>
Manage time-boxed sprints for quick, focused work outside the full milestone/phase cycle.
Sprints are ideal for bug fixes, small features, or exploratory work that doesn't warrant a full planning cycle.
</objective>

<process>

## 1. Parse Arguments

Extract from $ARGUMENTS:
- **Action**: `new` (default), `status`, or `close`
- **Sprint name**: identifier for the sprint

**If no arguments:** Default to `new` and ask for sprint details.

---

## 2a. Action: New Sprint

### Gather Sprint Information

Ask for:
- **Name** — Sprint identifier (e.g., "bugfix-auth", "spike-caching")
- **Goal** — One sentence describing the sprint goal
- **Duration** — Timeframe (e.g., "2 days", "1 week")
- **Scope** — Tasks included and explicitly excluded

### Create Sprint File

Create `.quantis/SPRINT.md` using the template from `.quantis/templates/sprint.md`:

```markdown
# Sprint {N} — {Sprint Name}

> **Duration**: {start-date} to {end-date}
> **Status**: In Progress

## Goal
{One sentence goal}

## Scope

### Included
- {Task 1}
- {Task 2}

### Explicitly Excluded
- {Out of scope item}

## Tasks

| Task | Assignee | Status | Est. Hours |
|------|----------|--------|------------|
| {Task 1} | Claude | ⬜ Todo | — |
| {Task 2} | Claude | ⬜ Todo | — |

## Daily Log

### {today's date}
- Sprint created
```

### Update STATE.md

**Edit the canonical `## Current Position` fields in place — do NOT replace the file.** Set `Status`, add the sprint marker, and preserve the existing `Phase`/`Task` lines (and every other section `/wf-resume-session` reads) so the paused milestone position is recoverable:
```markdown
## Current Position
- **Phase**: {existing phase} (paused for sprint)
- **Task**: {existing task, preserved}
- **Status**: sprint in progress — {name}
```

### Commit

```bash
git add .quantis/SPRINT.md .quantis/STATE.md
git commit -m "docs: create sprint {name}"
```

---

## 2b. Action: Status

Read `.quantis/SPRINT.md` and display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► SPRINT STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sprint: {name}
Duration: {start} to {end}
Tasks: {done}/{total} complete

{task table}

───────────────────────────────────────────────────────
```

---

## 2c. Action: Close

### Verify Sprint Complete

Check all tasks are done or explicitly deferred.

### Generate Retrospective

Append to `.quantis/SPRINT.md`:

```markdown
## Retrospective ({date})

### What Went Well
- {auto-extract from daily log}

### What Could Improve
- {identify blockers or friction}

### Action Items
- [ ] {carry-forward items}
```

### Archive Sprint

```bash
mkdir -p .quantis/sprints
mv .quantis/SPRINT.md ".quantis/sprints/{name}-SPRINT.md"
```

### Update STATE.md

Restore previous milestone position or mark as idle.

### Commit

```bash
git add .quantis/sprints/ .quantis/STATE.md
git commit -m "docs: close sprint {name}"
```

### Display Result

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► SPRINT CLOSED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sprint: {name}
Tasks completed: {N}/{total}

───────────────────────────────────────────────────────

▶ NEXT

/wf-resume-session — Return to milestone work
/wf-sprint new — Start another sprint

───────────────────────────────────────────────────────
```

</process>

<related>
## Related

### Workflows
| Command | Relationship |
|---------|--------------|
| `/wf-plan` | Full planning cycle (use for milestone work) |
| `/wf-execute` | Full execution cycle (use for milestone work) |
| `/wf-pause` | Pause current work for handoff |

### Templates
| Template | Purpose |
|----------|---------|
| `sprint.md` | Sprint document structure |
</related>
