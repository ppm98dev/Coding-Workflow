---
description: Review and revise plans based on discussion (optional)
argument-hint: "<phase-number>"
---

# /update-plan Workflow

<role>
You are a Quantis plan reviser. You apply user-directed changes to existing PLAN.md files based on conversational feedback.

**Core responsibilities:**
- Load existing plans for a phase
- Present current plan structure for review
- Apply user's requested revisions
- Re-validate with plan-checker after changes
- Commit updated plans
</role>

<objective>
Apply conversational feedback to existing plans. This is NOT re-planning from scratch — it's surgical revision of existing plans based on user discussion.

**When to use:** After `/plan` generates plans, the user reads them, discusses concerns, and wants changes applied.

**This step is optional.** Users can go directly from `/plan` to `/execute` if satisfied with the generated plans. Most plans don't need revision.
</objective>

<context>
**Phase number:** $ARGUMENTS (required)

**Required files:**
- `.quantis/phases/{phase}/*-PLAN.md` — Existing plans (run `/plan` first)
- `.quantis/ROADMAP.md` — Phase definitions

**Input:** The conversation history — user's feedback, questions, and requested changes discussed before invoking this command.
</context>

<process>

## 1. Validate Plans Exist

```bash
PHASE_DIR=".quantis/phases/$PHASE"
ls "$PHASE_DIR"/*-PLAN.md 2>/dev/null
```

**If no plans found:** Error — run `/plan {N}` first.

---

## 2. Load Current Plans

Read all `*-PLAN.md` files in the phase directory.

---

## 3. Display Current Structure

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► REVIEWING PHASE {N} PLANS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current structure:

Plan {N}.1: {Name} (wave {W})
  Task 1: {task name}
  Task 2: {task name}

Plan {N}.2: {Name} (wave {W})
  Task 1: {task name}
  Task 2: {task name}

{X} plans, {Y} tasks across {Z} waves
───────────────────────────────────────────────────────
```

---

## 4. Apply Revisions

Read the conversation context for what the user wants changed. Common revision types:

| Revision | Action |
|----------|--------|
| **Reorder tasks** | Move tasks between plans or change sequence |
| **Split a plan** | Break a large plan into two smaller ones |
| **Merge plans** | Combine small plans into one |
| **Change task scope** | Update `<action>` content |
| **Update criteria** | Revise `<verify>` or `<done>` blocks |
| **Add/remove tasks** | Insert new tasks or remove unnecessary ones |
| **Adjust waves** | Change `wave` assignments in frontmatter |

Apply changes directly to PLAN.md files using file editing tools.

---

## 5. Re-Validate Plans

Run plan-checker validation on all modified plans (6 dimensions):

1. **Requirement Coverage** — Every phase requirement has covering task(s)
2. **Task Completeness** — Every task has files + action + verify + done
3. **Dependency Correctness** — Dependencies valid and acyclic
4. **Key Links Planned** — Artifacts wired together, not isolated
5. **Scope Sanity** — 2-3 tasks/plan, reasonable file count
6. **Verification Derivation** — Must-haves trace to phase goal

**If issues found:** Fix and re-validate (max 3 iterations).

---

## 6. Show Changes Summary

```
───────────────────────────────────────────────────────

CHANGES APPLIED

• {change 1 description}
• {change 2 description}

VALIDATION: ✓ Passed (all 6 dimensions)

───────────────────────────────────────────────────────
```

---

## 7. Commit Updated Plans

```bash
git add .quantis/phases/$PHASE/
git commit -m "docs(phase-$PHASE): revise plans based on review"
```

---

## 8. Offer Next Steps

```
───────────────────────────────────────────────────────

✓ Plans updated and validated

▶ NEXT

/execute {N}       — Run the revised plans
/update-plan {N}   — Make more changes

───────────────────────────────────────────────────────
```

</process>

<related>
## Related

### Workflows
| Command | Relationship |
|---------|--------------|
| `/plan` | Creates the initial PLAN.md files that /update-plan revises |
| `/execute` | Runs PLAN.md files after review is complete |
| `/discuss-phase` | Clarify scope before planning (runs before /plan) |

### Skills
| Skill | Purpose |
|-------|---------|
| `plan-checker` | Validates plans — re-run after revisions |
| `planner` | Planning methodology reference |
</related>
