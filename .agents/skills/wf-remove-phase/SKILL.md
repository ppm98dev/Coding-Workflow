---
name: wf-remove-phase
description: Remove a phase from the roadmap (with safety checks)
argument-hint: "<phase-number>"
---

# /remove-phase Workflow

<objective>
Remove a phase from the roadmap, with safety checks for in-progress or completed work.
</objective>

<process>

## 1. Validate Phase Exists

```bash
grep -qE "^#{2,4} Phase ${N}:" ".quantis/ROADMAP.md" || { echo "❌ STOP: Phase $N not found in ROADMAP.md."; exit 1; }
```

**If the STOP line printed: halt.** Do not continue to Step 2.

---

## 2. Check Phase Status

```bash
status=$(grep -A1 "Phase $N:" ".quantis/ROADMAP.md" | grep "Status:" | cut -d: -f2)
```

**Safety checks:**

| Status | Action |
|--------|--------|
| ⬜ Not Started | Safe to remove |
| 🔄 In Progress | Warn and confirm |
| ✅ Complete | Error — archive instead |

---

## 3. Check for Dependencies

Are other phases depending on this one?

```bash
grep "Depends on.*Phase $N" ".quantis/ROADMAP.md"
```

**If dependencies exist:**
```
⚠️ Phase {M} depends on Phase {N}

Cannot remove. Consider:
1. Update dependent phases first
2. Use /insert-phase to restructure
```

---

## 4. Confirm Removal

```
⚠️ CONFIRM REMOVAL

Phase {N}: {name}
Status: {status}

This will:
- Remove phase from ROADMAP.md
- Delete matched folder in `.quantis/phases/` named `{N}.{M}-{slug}` if it exists
- Renumber subsequent phases

Type "REMOVE" to confirm:
```

---

## 5. Remove Phase

1. Delete from ROADMAP.md
2. Find and remove matching subphase directory (use the unified phase-directory resolution — phase dirs are named `{N}.{M}-{slug}`, so a bare `${N}-*` prefix will NOT match `3.1-...`):
   ```bash
   # ─── Phase Directory Resolution (unified) ───────────────
   # $N is the phase number being removed (e.g., "3.1", "3")
   PHASE_DIR=$(find .quantis/phases -maxdepth 1 -type d -name "${N}-*" 2>/dev/null | sort | head -n 1)
   if [ -z "$PHASE_DIR" ] && echo "$N" | grep -qE '^[0-9]+$'; then
       MATCHES=$(find .quantis/phases -maxdepth 1 -type d -name "${N}.*-*" 2>/dev/null | sort)
       COUNT=$(printf '%s\n' "$MATCHES" | grep -c . || true)
       if [ "$COUNT" -eq 1 ]; then
           PHASE_DIR="$MATCHES"
       elif [ "$COUNT" -gt 1 ]; then
           echo "❌ STOP: Multiple subphases found for phase $N:"; echo "$MATCHES"
           echo "Specify the full number (e.g., ${N}.1)."; exit 1
       fi
   fi
   if [ -n "$PHASE_DIR" ]; then
       rm -rf "$PHASE_DIR"
   fi
   ```
3. Renumber subsequent phases (N+1 becomes N, etc.)
4. Update dependencies

---

## 6. Update STATE.md

Edit these fields IN PLACE (canonical schema in `.quantis/templates/state.md` — never replace the file):
- **Current Position** → if the removed phase was current, set Phase to the previous phase (or `Planning`) and Status accordingly.
- **Last Session Summary** → note the phase removal and renumbering.
- **Next Steps** → next action after removal.

---

## 7. Commit

```bash
git add -A
git commit -m "docs(phase-{N}): remove phase {name} (renumbered {M} phases)"
```

Confirm the commit succeeded (`git log -1`). On failure, route by cause per the Commit Failure Rule in `.agents/rules/PROJECT_RULES.md` — never bypass with `--no-verify`.

---

## 8. Display Result

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PHASE REMOVED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Removed: Phase {N}: {name}
Renumbered: {M} phases

───────────────────────────────────────────────────────

/progress — See updated roadmap

───────────────────────────────────────────────────────
```

</process>
