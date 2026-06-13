---
name: wf-update-plan
description: Review and revise plans based on discussion (optional)
argument-hint: "<phase-number>"
---

# /wf-update-plan → writing-plans skill (revision mode)

> **Skill-powered workflow.** Plan revision methodology is powered by `writing-plans`. This workflow adds validation, change tracking, and re-verification.

<context>
**Phase:** $ARGUMENTS (optional — auto-detect current phase if not provided)

**Required files:**
- `.quantis/phases/{N}.{M}-{slug}/*-PLAN.md` — Existing plans to revise
- `.quantis/DECISIONS.md` — New decisions that may affect plans
- `.quantis/ROADMAP.md` — Phase scope for validation
</context>

<process>

## 0. Platform Check

**Revise the plans via a LEAN subagent (keep the orchestrator thin) — NOT a `self` clone** (it inherits the full config and stalls; see DECISIONS D-009). Do Step 1 (validate plans exist) and Step 2 (display structure). If a minimal/templated `define_subagent` is available, dispatch it with PATHS to read (the existing PLAN.md file(s), `.agents/skills/writing-plans/SKILL.md`, relevant `.quantis/DECISIONS.md`, `.agents/rules/CONSTITUTION.md`) and have it **rewrite the PLAN.md file(s) INCREMENTALLY** (output is capped at **16,384 tokens/turn**), checkbox format (`### Task N` with `- [ ]` steps, `Run:`/`Expected:`). If unavailable or it stalls, fall back to revising inline — still incrementally. Then continue at Step 5 (Re-Validate) and commit.

> **Optional offload:** only via a **minimal `define_subagent`** (stripped prompt, never a raw `self`), giving it file PATHS to read. When unsure, write inline.

> Detection is automatic. Never ask the user which mode to use.

## 1. Validate Plans Exist
```bash
# ─── Phase Directory Resolution (unified) ───────────────
# $PHASE is set from $ARGUMENTS

if [ -z "$PHASE" ]; then
    echo "❌ STOP: no phase number — read current phase from STATE.md, or run /wf-progress"
    exit 1
fi

# 1. Find directory by exact prefix match
PHASE_DIR=$(find .quantis/phases -maxdepth 1 -type d -name "${PHASE}-*" 2>/dev/null | sort | head -n 1)

# 2. If no match and PHASE is integer, try N.* subphase pattern
if [ -z "$PHASE_DIR" ] && echo "$PHASE" | grep -qE '^[0-9]+$'; then
    MATCHES=$(find .quantis/phases -maxdepth 1 -type d -name "${PHASE}.*-*" 2>/dev/null | sort)
    COUNT=$(printf '%s\n' "$MATCHES" | grep -c . || true)
    if [ "$COUNT" -eq 1 ]; then
        PHASE_DIR="$MATCHES"
    elif [ "$COUNT" -gt 1 ]; then
        echo "Multiple subphases found for phase $PHASE:"
        echo "$MATCHES"
        echo "Please specify the full number (e.g., ${PHASE}.1)"
        exit 1
    fi
fi

# 3. Validate — /wf-update-plan requires an existing directory
if [ -z "$PHASE_DIR" ]; then
    echo "❌ STOP: No phase directory found for '${PHASE}'."
    echo "Available: $(ls .quantis/phases/ 2>/dev/null || echo 'none')"
    echo "Pass the full number (e.g., 3.1) or run /wf-plan first."
    exit 1
fi
ls "$PHASE_DIR"/*-PLAN.md 2>/dev/null || { echo "❌ STOP: No *-PLAN.md files in $PHASE_DIR — run /wf-plan $PHASE first."; exit 1; }
```
**If a STOP line printed: halt.** Do not continue to Step 2 — there are no plans to revise.

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
- Discussion outcomes (from `/wf-discuss-phase`)
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

▶ /wf-execute {N} — run updated plans
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `writing-plans` | Plan methodology (delegated) |
</related>
