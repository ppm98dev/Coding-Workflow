---
name: wf-update-plan
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

## 0. Platform Check

**If `invoke_subagent` is available** (CLI `agy`, Standalone): **you MUST dispatch** — do not revise plans inline. First do Step 1 (validate plans exist) and Step 2 (display structure) yourself. Then dispatch a `self` subagent whose prompt MUST contain, **pasted in full** (subagents do NOT inherit your context — paste CONTENTS, never paths):
- The existing PLAN.md file(s) from `$PHASE_DIR` and the naming convention `{N}.{M}-{plan-slug}-PLAN.md`.
- The full contents of `.agents/skills/writing-plans/SKILL.md`.
- The `.quantis/DECISIONS.md` entries and discussion outcomes driving the revision, plus the relevant ROADMAP phase scope.
- `.agents/rules/CONSTITUTION.md` quality standards.
**Required return format:** the revised PLAN.md file(s) written to `$PHASE_DIR/` (checkbox task format — `### Task N` with `- [ ]` steps and `Run:`/`Expected:` verification) plus the Changes Summary from Step 4.
When the subagent returns, **continue at Step 5** (Re-Validate), then commit yourself.

**If `invoke_subagent` is NOT available** (IDE): proceed inline from Step 1.

**If a dispatch fails or returns unusable output** (missing file, empty result): re-dispatch once with explicit feedback on what was wrong; on a second failure, fall back to the inline procedure and say so.

> Detection is automatic. Never ask the user which mode to use.

**Subagent types** (`.agents/skills/using-quantis/references/antigravity-tools.md`): `self` = clone of the calling agent with the same capabilities.

## 1. Validate Plans Exist
```bash
# ─── Phase Directory Resolution (unified) ───────────────
# $PHASE is set from $ARGUMENTS

if [ -z "$PHASE" ]; then
    echo "❌ STOP: no phase number — read current phase from STATE.md, or run /progress"
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

# 3. Validate — /update-plan requires an existing directory
if [ -z "$PHASE_DIR" ]; then
    echo "❌ STOP: No phase directory found for '${PHASE}'."
    echo "Available: $(ls .quantis/phases/ 2>/dev/null || echo 'none')"
    echo "Pass the full number (e.g., 3.1) or run /plan first."
    exit 1
fi
ls "$PHASE_DIR"/*-PLAN.md 2>/dev/null || { echo "❌ STOP: No *-PLAN.md files in $PHASE_DIR — run /plan $PHASE first."; exit 1; }
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
