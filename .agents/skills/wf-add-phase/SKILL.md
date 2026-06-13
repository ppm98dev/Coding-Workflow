---
name: wf-add-phase
description: Add a new phase to the end of the roadmap
argument-hint: "<phase-name>"
---

# /wf-add-phase Workflow

<objective>
Add a new phase to the end of the current roadmap.
</objective>

<process>

## 1. Validate Roadmap Exists

```bash
test -f ".quantis/ROADMAP.md" || { echo "❌ STOP: No ROADMAP.md — run /wf-plan first."; exit 1; }
```

**If the STOP line printed: halt.** Do not continue to Step 2.

---

## 2. Determine Next Phase Number

The next phase number is one greater than the highest existing phase heading in the current milestone:

```bash
grep -oE "^#{2,4} Phase [0-9]+" ".quantis/ROADMAP.md" | grep -oE "[0-9]+" | sort -n | tail -n 1
```

Increment that value to get `{N}`.

---

## 3. Gather Phase Information

Ask for:
- **Name** — Phase title
- **Objective** — What this phase achieves
- **Depends on** — Previous phases (usually N-1)

---

## 4. Add to ROADMAP.md

Append:
```markdown
---

### Phase {N}: {name}
**Status**: ⬜ Not Started
**Objective**: {objective}
**Depends on**: Phase {N-1}

**Tasks**:
- [ ] TBD (run /wf-plan {N} to create)

**Verification**:
- TBD
```

---

## 5. Update STATE.md

Edit these fields IN PLACE (canonical schema in `.quantis/templates/state.md` — never replace the file):
- **Last Session Summary** → note the new phase added to the roadmap.
- **Next Steps** → `/wf-plan {N}` to create execution plans.

---

## 6. Commit

```bash
git add .quantis/ROADMAP.md .quantis/STATE.md
git commit -m "docs(phase-{N}): add phase {name} to roadmap"
```

Confirm the commit succeeded (`git log -1`). On failure, route by cause per the Commit Failure Rule in `.agents/rules/PROJECT_RULES.md` — never bypass with `--no-verify`.

---

## 7. Offer Next Steps

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PHASE ADDED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Phase {N}: {name}

───────────────────────────────────────────────────────

▶ NEXT

/wf-plan {N} — Create execution plans for this phase

───────────────────────────────────────────────────────
```

</process>
