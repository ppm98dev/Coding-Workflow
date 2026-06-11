---
description: The Engineer — Execute a specific phase with focused context
argument-hint: "<phase-number> [--gaps-only]"
---

# /execute → executing-plans skill

> **Skill-powered workflow.** Execution methodology is powered by `subagent-driven-development` (CLI-first default) or `executing-plans` (inline fallback). This workflow adds Quantis orchestration (wave management, verification, state tracking).

<role>
You are a Quantis executor orchestrator. You manage wave-based execution of phase plans, then verify against the phase goal.
</role>

<context>
**Phase:** $ARGUMENTS (required — phase number to execute)

**Flags:**
- `--gaps-only` — Execute only gap closure plans (created by `/verify`)

**Required files:**
- `.quantis/ROADMAP.md` — Phase definitions
- `.quantis/STATE.md` — Current position
- `.quantis/phases/{phase}.{subphase}-{slug}/` — Phase directory with PLAN.md files
</context>

<process>

## 1. Validate Environment
```bash
test -f ".quantis/ROADMAP.md" || echo "Error: run /plan first"
test -f ".quantis/STATE.md" || echo "Error: run /plan first"
test -f ".quantis/CONSTITUTION.md" || echo "⚠️ No CONSTITUTION.md — quality standards not enforced"
```
Validate phase exists in ROADMAP.md.

## 2. Discover Plans
```bash
# Dynamically find the phase directory by prefix
PHASE_DIR=$(find .quantis/phases -maxdepth 1 -name "${PHASE}-*" | head -n 1)
if [ -z "$PHASE_DIR" ]; then
    echo "Error: phase directory starting with ${PHASE}- not found"
    exit 1
fi
ls "$PHASE_DIR"/*-PLAN.md 2>/dev/null
ls "$PHASE_DIR"/*-SUMMARY.md 2>/dev/null
```
Build list of **incomplete plans** (PLAN without matching SUMMARY).
If `--gaps-only`: filter to plans with `gap_closure: true` in frontmatter.
If no incomplete plans: phase already complete, skip to step 6.

## 3. Group by Wave
Read `wave` field from each plan's YAML frontmatter. Group plans by wave number. Lower waves first.

Display:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► EXECUTING PHASE {N}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wave 1: {plan-1}, {plan-2}
Wave 2: {plan-3}

{X} plans across {Y} waves
```

## 4. Execute Waves

For each wave in order, for each plan in the wave:

1. Load plan context (PLAN.md + CONSTITUTION.md)
2. **Select execution methodology (automatic — do NOT ask the user):**
   - Check if `invoke_subagent` tool is available in your current environment
   - **If available:** Read and follow `.agents/skills/subagent-driven-development/SKILL.md`. Announce: "I'm using Subagent-Driven Development to execute this plan."
   - **If NOT available:** Read and follow `.agents/skills/executing-plans/SKILL.md`.
   - **This is NOT a choice. Do not present a menu. Do not ask the user.**
3. Follow `<task>` blocks in order, run `<verify>` commands
4. Commit per task: `git commit -m "feat(phase-$PHASE): {task-name}"`
5. After all tasks in plan: create `$PHASE-SUMMARY.md` inside `$PHASE_DIR/` documenting what was done

> **Note:** SDD executes tasks **sequentially** — one subagent per task, one at a time. It is not about parallelism. It is about fresh context per task and two-stage review gates (spec compliance → code quality).

**Verify wave complete** before proceeding to next wave.

## 5. Verify Phase Goal

After all waves:
1. Read phase goal from ROADMAP.md
2. Check must-haves against **actual codebase** (not SUMMARY claims)
3. Run verification commands if specified

**Route by verdict:**
- **PASS** → Step 6
- **FAIL** → Create gap closure plans, offer `/execute {N} --gaps-only`

## 6. Update State

**ROADMAP.md:** Mark phase `✅ Complete`
**STATE.md:** Update position, last session summary, next steps
**REQUIREMENTS.md** (if exists): Cross-reference completed tasks with requirement IDs

```bash
git add .quantis/ROADMAP.md .quantis/STATE.md "$PHASE_DIR/"
git commit -m "docs(phase-$PHASE): complete phase"
```

</process>

<context_hygiene>
**After 3 failed debugging attempts:**
1. Stop current approach
2. Document to `.quantis/STATE.md` what was tried
3. Recommend `/pause` for fresh session
</context_hygiene>

<offer_next>

**Phase complete, more phases:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PHASE {N} COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
▶ /plan {N+1} or /execute {N+1}
```

**All phases complete:**
```
 Quantis ► MILESTONE COMPLETE 🎉
```

**Gaps found:**
```
 Quantis ► PHASE {N} GAPS FOUND ⚠
▶ /execute {N} --gaps-only
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `executing-plans` | Execution methodology (delegated) |
| `subagent-driven-development` | SDD execution with review (CLI-first default) |
| `verification-before-completion` | Must-have verification methodology |
| `context-health-monitor` | 3-strike rule enforcement |
</related>
