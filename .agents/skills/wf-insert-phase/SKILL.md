---
name: wf-insert-phase
description: Insert a phase between existing phases (renumbers subsequent)
argument-hint: "<position> <phase-name>"
---

# /wf-insert-phase Workflow

<objective>
Insert a new phase at a specific position, renumbering all subsequent phases.
</objective>

<process>

## 1. Parse Arguments

Extract:
- **Position** — Where to insert (e.g., 2 inserts before current Phase 2)
- **Name** — Phase title

---

## 2. Validate Position

```bash
total_phases=$(grep -cE "^#{2,4} Phase [0-9]" ".quantis/ROADMAP.md")
if [ "$position" -lt 1 ] || [ "$position" -gt $((total_phases + 1)) ]; then
    echo "❌ STOP: Invalid position. Valid: 1-$((total_phases + 1))."; exit 1
fi
```

**If the STOP line printed: halt.** Do not continue to Step 3.

---

## 3. Gather Phase Information

Ask for:
- **Objective** — What this phase achieves
- **Dependencies** — What it needs from earlier phases

---

## 4. Renumber Existing Phases

For phases >= position, increment phase number by 1.

**Also update:**
- Phase directory names (`.quantis/phases/{N}.{M}-{slug}/`)
- References in PLAN.md files
- Dependencies in ROADMAP.md

---

## 5. Insert New Phase

Add at position with correct numbering.

---

## 6. Update STATE.md

Edit these fields IN PLACE (canonical schema in `.quantis/templates/state.md` — never replace the file):
- **Current Position** → if currently in a phase `>= position`, bump its Phase number to reflect the renumbering.
- **Last Session Summary** → note the insertion and renumbering.
- **Next Steps** → next action (e.g., `/wf-plan {N}`).

---

## 7. Commit

```bash
git add -A
git commit -m "docs(phase-{N}): insert phase {name} (renumbered {M} phases)"
```

Confirm the commit succeeded (`git log -1`). On failure, route by cause per the Commit Failure Rule in `.agents/rules/PROJECT_RULES.md` — never bypass with `--no-verify`.

---

## 8. Display Result

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PHASE INSERTED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Inserted: Phase {N}: {name}
Renumbered: Phases {N+1} through {M}

───────────────────────────────────────────────────────

▶ NEXT

/wf-plan {N} — Create plans for new phase
/wf-progress — See updated roadmap

───────────────────────────────────────────────────────
```

</process>

<warning>
Phase insertion can be disruptive. Consider:
- In-progress phases may have commits referencing old numbers
- Existing plans reference phase numbers
- Use sparingly and early in milestone lifecycle
</warning>
