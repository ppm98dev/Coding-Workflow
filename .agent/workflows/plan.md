---
description: The Strategist — Decompose requirements into executable phases in ROADMAP.md
argument-hint: "[phase] [--research] [--skip-research] [--gaps]"
---

# /plan → writing-plans skill

> **Skill-powered workflow.** Planning methodology is powered by `writing-plans`. This workflow adds Quantis orchestration (validation, research, state tracking).

<role>
You are a Quantis planner orchestrator. You validate the environment, handle research, then delegate planning methodology to the `writing-plans` skill.
</role>

<context>
**Phase number:** $ARGUMENTS (optional — auto-detects next unplanned phase if not provided)

**Flags:**
- `--research` — Force re-research even if RESEARCH.md exists
- `--skip-research` — Skip research entirely
- `--gaps` — Gap closure mode (reads VERIFICATION.md, skips research)

**Required files:**
- `.quantis/SPEC.md` — Must be FINALIZED (Planning Lock)
- `.quantis/ROADMAP.md` — Must have phases defined
</context>

<philosophy>

## Plans Are Prompts
PLAN.md IS the prompt. It contains objective, context, tasks, and success criteria.

## Quality Degradation Curve
| Context Usage | Quality |
|---------------|---------|
| 0-30% | PEAK — thorough |
| 30-50% | GOOD — solid |
| 50-70% | DEGRADING |
| 70%+ | POOR — rushed |

Plans should complete within ~50% context. More plans, smaller scope.

## Aggressive Atomicity
Each plan: **2-3 tasks max**. No exceptions.

</philosophy>

<process>

## 1. Planning Lock
```bash
grep -q "FINALIZED" ".quantis/SPEC.md" || echo "Error: SPEC.md must be FINALIZED"
test -f ".quantis/CONSTITUTION.md" || echo "⚠️ No CONSTITUTION.md"
```

## 2. Parse Arguments
Extract phase number (or auto-detect next unplanned phase from ROADMAP.md) and flags.

```bash
# Resolve dynamic phase directory slug from ROADMAP.md
PHASE_TITLE=$(grep -i "Phase $PHASE" .quantis/ROADMAP.md | head -n 1 | sed -E 's/.*Phase [0-9.]+:? (.*)/\1/' | tr -d '\r')
PHASE_SLUG=$(echo "$PHASE_TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g')
PHASE_DIR=".quantis/phases/${PHASE}-${PHASE_SLUG}"
```

## 3. Handle Research

**If `--gaps` or `--skip-research`:** Skip to step 4.

**Check existing:** `test -f "$PHASE_DIR/RESEARCH.md"`

**If research needed (new phase or `--research` forced):**
- Assess discovery level:
  - **L0 (skip)** — Pure internal work, established patterns
  - **L1 (quick)** — Single known library, confirming syntax
  - **L1.5 (discovery)** — Quick A-vs-B comparison → DISCOVERY.md
  - **L2 (standard)** — 2-3 options, new integration → RESEARCH.md
  - **L3 (deep dive)** — Architectural decision, novel problem → full RESEARCH.md
- Create RESEARCH.md inside `$PHASE_DIR/`

## 4. Delegate to Skill

**Read and follow `.agents/skills/writing-plans/SKILL.md` exactly.**

Provide the skill with:
- Phase number and objectives from ROADMAP.md
- SPEC.md requirements
- CONSTITUTION.md quality standards
- RESEARCH.md findings (if exists)
- ARCHITECTURE.md (if exists)

Output plans to `.quantis/phases/{N}.{M}-{slug}/` using `{N}.{M}-PLAN.md` naming.

## 5. Plan Checker (max 3 iterations)
For each plan, verify:
- [ ] All referenced files exist or will be created
- [ ] Actions are specific (no vague "implement X")
- [ ] `<verify>` commands are executable
- [ ] `<done>` criteria are measurable
- [ ] Tests verify real behavior (no tautological asserts, no mock-everything)

**If issues found:** Fix and re-verify. Max 3 iterations.

## 6. Update State + Commit
Update `.quantis/STATE.md` with planning complete status.
```bash
git add "$PHASE_DIR/" .quantis/STATE.md
git commit -m "docs(phase-$PHASE): create execution plans"
```

</process>

<task_types>
| Type | Use For |
|------|---------|
| `auto` | Everything the agent can do independently |
| `checkpoint:human-verify` | Visual/functional verification needing user |
| `checkpoint:decision` | Implementation choices needing user input |
</task_types>

<offer_next>
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PHASE {N} PLANNED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{X} plans created across {Y} waves

▶ Next: /execute {N}
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `writing-plans` | Planning methodology (delegated) |
| `brainstorming` | Use for research phase |
</related>
