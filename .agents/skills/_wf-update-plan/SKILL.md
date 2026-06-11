---
name: _wf-update-plan
description: Review and revise plans based on discussion (optional)
argument-hint: "<phase-number>"
---

# /update-plan → writing-plans skill (revision mode)

> **Skill-powered workflow.** Plan revision methodology is powered by `writing-plans`. This workflow adds validation, change tracking, and re-verification.

<context>
**Phase:** $ARGUMENTS (optional — auto-detect current phase if not provided)

**Required files:**
- `.quantis/phases/{N}.{M}-{slug}/*-PLAN.md` — Existing plans to revise
- `.quantis/DECISIONS.md` — New decisions that may affect plans
- `.quantis/ROADMAP.md` — Phase scope for validation
</context>

<process>

## 1. Validate Plans Exist
```bash
# Dynamically find the phase directory by prefix
PHASE_DIR=$(find .quantis/phases -maxdepth 1 -name "${PHASE}-*" | head -n 1)
if [ -z "$PHASE_DIR" ]; then
    echo "Error: phase directory starting with ${PHASE}- not found"
    exit 1
fi
ls "$PHASE_DIR"/*-PLAN.md 2>/dev/null || echo "Error: no plans found"
```

## 2. Display Current Structure
Show existing plans with wave assignments:
```
Current plans for Phase {N}:
• {N}.1: {Name} (wave 1) — {X} tasks
• {N}.2: {Name} (wave 1) — {Y} tasks
• {N}.3: {Name} (wave 2) — {Z} tasks
```

## 3. Revise Plans
**Read and follow `.agents/skills/writing-plans/SKILL.md`** in revision mode.

Apply changes based on:
- Discussion outcomes (from `/discuss-phase`)
- New decisions in DECISIONS.md
- User feedback

## 4. Track Changes
Document what changed and why:
```markdown
## Changes Summary
- Plan {N}.1: {what changed} — Reason: {why}
- Plan {N}.2: No changes
- Plan {N}.3: {what changed} — Reason: {why}
```

## 5. Re-Validate
Run plan checker on revised plans:
- [ ] Files still exist or will be created
- [ ] Actions still specific
- [ ] Verify commands still executable
- [ ] No broken cross-references between plans

## 6. Commit + Next Steps
```bash
git add "$PHASE_DIR/"
git commit -m "docs(phase-$PHASE): revise plans"
```

</process>

<offer_next>
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PLANS UPDATED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
{X}/{Y} plans revised

▶ /execute {N} — run updated plans
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `writing-plans` | Plan methodology (delegated) |
</related>
