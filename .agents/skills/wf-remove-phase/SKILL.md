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
if ! grep -q "### Phase $N:" ".quantis/ROADMAP.md"; then
    echo "Error: Phase $N not found in ROADMAP.md" >&2
fi
```

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
- Delete matched folder in `.quantis/phases/` starting with prefix `{N}-` if exists
- Renumber subsequent phases

Type "REMOVE" to confirm:
```

---

## 5. Remove Phase

1. Delete from ROADMAP.md
2. Find and remove matching subphase directory:
   ```bash
   PHASE_DIR=$(find .quantis/phases -maxdepth 1 -name "${N}-*" | head -n 1)
   if [ -n "$PHASE_DIR" ]; then
       rm -rf "$PHASE_DIR"
   fi
   ```
3. Renumber subsequent phases (N+1 becomes N, etc.)
4. Update dependencies

---

## 6. Update STATE.md

If currently in removed phase, set to previous phase or "Planning".

---

## 7. Commit

```bash
git add -A
git commit -m "docs: remove phase {N} - {name}"
```

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
