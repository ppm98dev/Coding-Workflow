---
name: wf-new-milestone
description: Create a new milestone with phases
argument-hint: "<milestone-name>"
---

# /new-milestone Workflow

<objective>
Define a new milestone with goal, phases, and success criteria.
</objective>

<process>

## 1. Validate SPEC Exists

```bash
if [ ! -f ".quantis/SPEC.md" ]; then
    echo "❌ STOP: SPEC.md required. Run /new-project first." >&2
    exit 1
fi
```

**If SPEC.md is missing: STOP. Do not gather milestone information.**

---

## 2. Gather Milestone Information

Ask for:
- **Name** — Milestone identifier (e.g., "v1.0", "MVP", "Beta")
- **Goal** — What does this milestone achieve?
- **Must-haves** — Non-negotiable deliverables
- **Nice-to-haves** — Optional if time permits

---

## 3. Generate Phase Breakdown

Based on goal and must-haves, suggest phases:

```markdown
## Suggested Phases

Phase 1: {Foundation/Setup}
Phase 2: {Core Feature A}
Phase 3: {Core Feature B}
Phase 4: {Integration/Polish}
Phase 5: {Verification/Launch}
```

Ask user to confirm or modify.

---

## 4. Append to ROADMAP.md

Do NOT overwrite the file. Update the `> **Current Milestone**:` line at the top, then append the section below as a new milestone — preserve all previous milestone sections.

```markdown
# ROADMAP.md

> **Current Milestone**: {name}
> **Goal**: {goal}

## Must-Haves
- [ ] {must-have 1}
- [ ] {must-have 2}

## Phases

### Phase 1: {name}
**Status**: ⬜ Not Started
**Objective**: {description}

### Phase 2: {name}
**Status**: ⬜ Not Started
**Objective**: {description}

...
```

---

## 5. Update STATE.md

Edit `.quantis/STATE.md` IN PLACE — set the fields inside the existing `## Current Position` section (canonical schema in `.quantis/templates/state.md`); leave all other sections intact:

```markdown
## Current Position
- **Phase**: Not started — milestone {name} planned
- **Task**: —
- **Status**: Milestone planned
```

---

## 5b. Reset Session Files (if starting fresh)

If DECISIONS.md or JOURNAL.md contain entries from a previous milestone, reset them to prevent monolithic growth:

**Before resetting:** Verify the current DECISIONS.md and JOURNAL.md have been archived.
```bash
# Check if archive exists for current milestone
if [ -f ".quantis/DECISIONS.md" ] && [ "$(wc -l < .quantis/DECISIONS.md)" -gt 5 ]; then
    if ! find .quantis/milestones -name "DECISIONS.md" -newer .quantis/DECISIONS.md 2>/dev/null | grep -q .; then
        echo "❌ STOP: DECISIONS.md has unarchived content. Run /complete-milestone first."
        exit 1
    fi
fi
```

```bash
if [ -f ".quantis/DECISIONS.md" ] && [ "$(wc -l < .quantis/DECISIONS.md)" -gt 5 ]; then
    printf '# Decisions

---
' > .quantis/DECISIONS.md
fi
if [ -f ".quantis/JOURNAL.md" ] && [ "$(wc -l < .quantis/JOURNAL.md)" -gt 5 ]; then
    printf '# Journal

---
' > .quantis/JOURNAL.md
fi
```

> **Note:** Only resets if files have grown beyond a header. If running `/complete-milestone` first, files are already archived and reset.

---

## 6. Commit

```bash
git add .quantis/ROADMAP.md .quantis/STATE.md
git commit -m "docs: create milestone {name}"
```

---

## 7. Offer Next Steps

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► MILESTONE CREATED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Milestone: {name}
Phases: {N}

───────────────────────────────────────────────────────

▶ NEXT

/plan 1 — Create Phase 1 execution plans

───────────────────────────────────────────────────────
```

</process>
