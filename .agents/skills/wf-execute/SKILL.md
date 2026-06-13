---
name: wf-execute
description: The Engineer — Execute a specific phase with focused context
argument-hint: "<phase-number> [--gaps-only]"
---

# /wf-execute → subagent-driven-development skill

> **Skill-powered workflow.** Execution methodology is powered by `subagent-driven-development`, which self-selects real subagents (when `invoke_subagent` is available) or inline mode (when it is not) — no separate fallback skill, no menu. This workflow adds Quantis orchestration (wave management, verification, state tracking).

<role>
You are a Quantis executor orchestrator. You manage wave-based execution of phase plans, then verify against the phase goal.
</role>

<context>
**Phase:** $ARGUMENTS (if omitted: read the current phase from `.quantis/STATE.md`; if STATE.md is ambiguous or missing, list the phases that have a `.quantis/phases/` directory and ask the user — do not guess)

**Flags:**
- `--gaps-only` — Execute only gap closure plans (created by `/wf-verify`)

**Required files:**
- `.quantis/ROADMAP.md` — Phase definitions
- `.quantis/STATE.md` — Current position
- `.quantis/phases/{phase}.{subphase}-{slug}/` — Phase directory with PLAN.md files
</context>

<process>

## 1. Validate Environment
```bash
test -f ".quantis/ROADMAP.md" || { echo "❌ STOP: No ROADMAP.md — run /wf-plan first."; exit 1; }
test -f ".quantis/STATE.md"   || { echo "❌ STOP: No STATE.md — run /wf-plan first."; exit 1; }
test -f ".agents/rules/CONSTITUTION.md" || echo "⚠️ No .agents/rules/CONSTITUTION.md — quality standards not enforced"
grep -q "\[FILL" .agents/rules/CONSTITUTION.md 2>/dev/null && echo "⚠️ CONSTITUTION.md has unfilled [FILL:] placeholders — treating the FIRST listed option as the default for each (see CONSTITUTION Governance)"
if [ -z "$PHASE" ]; then echo "❌ STOP: no phase number — read current phase from STATE.md, or run /wf-progress"; exit 1; fi
```
**If a STOP line printed: halt. Do not continue to Step 2.** (The ⚠️ CONSTITUTION / [FILL] lines are non-blocking warnings.)

> **Note:** the `⚠️` warnings intentionally stay as `|| echo` / bare `echo` — they are non-blocking. Only the blocking checks convert to `|| { …; exit 1; }`.

Validate phase exists in ROADMAP.md.

## 1.5 Branch Check
The delegated methodologies forbid implementing on main/master without explicit consent.
```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then echo "⚠️ On $BRANCH — do not implement here without consent"; fi
```
**If on main/master: STOP.** Either get explicit user consent to commit on $BRANCH, or create a phase branch first: `git checkout -b phase-$PHASE`. Do not continue to Step 2 until on a non-default branch or consent is given.

## 2. Discover Plans
```bash
# ─── Phase Directory Resolution (unified) ───────────────
# $PHASE is set from $ARGUMENTS

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

# 3. Validate — /wf-execute requires an existing directory
if [ -z "$PHASE_DIR" ]; then
    echo "❌ STOP: No phase directory found for '${PHASE}'."
    echo "Available: $(ls .quantis/phases/ 2>/dev/null || echo 'none')"
    echo "Pass the full number (e.g., 3.1) or run /wf-plan first."
    exit 1
fi
ls "$PHASE_DIR"/*-PLAN.md 2>/dev/null
ls "$PHASE_DIR"/*-SUMMARY.md 2>/dev/null
```
**If NO `*-PLAN.md` files exist: STOP.** "No plans found for phase {N}. Run `/wf-plan {N}` first." Do not touch ROADMAP.md or STATE.md.

Build list of **incomplete plans** — a plan is incomplete if `X-PLAN.md` has no matching `X-SUMMARY.md` (same filename prefix before `-PLAN.md` → before `-SUMMARY.md`).

If `--gaps-only`: filter to plans with `gap_closure: true` in YAML frontmatter.
If every PLAN has a matching SUMMARY: skip to Step 5 (Verify Phase Goal) — **never** straight to Step 6.

## 3. Group by Wave
Read `wave` field from each plan's YAML frontmatter. If a plan has no `wave` field, treat it as wave 1 — do not error, do not skip. Group plans by wave number. Lower waves first.

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

**Set phase status:** Update `.quantis/ROADMAP.md` — set this phase's status to `🔄 In Progress` (if not already set). This ensures `/wf-progress` reflects active work.

**Select execution methodology once, before the first wave (automatic — do NOT ask the user):**
- **Read and follow `.agents/skills/subagent-driven-development/SKILL.md`** — it handles platform detection internally. SDD auto-selects: `invoke_subagent` available → dispatch real subagents; not available → inline SDD mode (self-execute with two-stage review gates).
- **This is NOT a choice. Do not present a menu. Do not ask the user.** Apply the selected methodology to every plan below — do not re-check or re-read per plan.
- **When dispatched by `/wf-execute`, skip SDD's "When to Use" decision tree** — the workflow already chose.
- **If subagent dispatch fails or returns unusable output** (tool error, timeout, empty/garbage result, non-empirical evidence): re-dispatch ONCE with explicit feedback on what was wrong. If it fails a second time, fall back to inline SDD mode and say so in your output — do not abandon the task.

For each wave in order, for each plan in the wave:

1. Load plan context (PLAN.md + .agents/rules/CONSTITUTION.md)
2. Execute the plan's `### Task N` sections in order. For each task:
   - Run each step's `Run:` command and check output against `Expected:`.
   - (Legacy `<task>` XML plans from gap closure: run `<verify>` per block.)
   - **GATE:** Each task's verification must RUN and PASS (read the output) before that task is committed.
   - On failure → apply systematic-debugging. After 3 failed attempts on the same task → record BLOCKED in STATE.md, continue with other plans, do not mark the wave complete.
3. Commit per task (ONLY after verification passes): `git commit -m "feat(phase-$PHASE): {task-name}"`
4. After all tasks in plan: create per-plan summary — `X-PLAN.md` → `X-SUMMARY.md` (same prefix) inside `$PHASE_DIR/` documenting what was done.

> **Scope note:** The methodology skill (`subagent-driven-development`, which self-selects real subagents or inline mode by platform) executes ONE plan. Skip its terminal steps (final whole-implementation review, finishing-a-development-branch) — Steps 5–6 below own phase-level verification and completion.

> **Note:** SDD executes tasks **sequentially** — one subagent per task, one at a time. It is not about parallelism. It is about fresh context per task and two-stage review gates (spec compliance → code quality).

**Verify wave complete** before proceeding to next wave (every plan has its SUMMARY and all task verifications passed).

## 5. Verify Phase Goal

After all waves:
1. Read phase goal from ROADMAP.md
2. Check must-haves against **actual codebase** (not SUMMARY claims)
3. Run verification commands if specified

**Route by verdict:**
- **PASS** → Step 6
- **FAIL** → Recommend `/wf-plan {N} --gaps` (it authors the fix plans from VERIFICATION.md), then `/wf-execute {N} --gaps-only`

## 6. Update State

**ROADMAP.md:** Mark phase `✅ Complete`
**STATE.md:** Update position, last session summary, next steps
**REQUIREMENTS.md** (if exists): Cross-reference completed tasks with requirement IDs

```bash
test -f .quantis/REQUIREMENTS.md && git add .quantis/REQUIREMENTS.md
git add .quantis/ROADMAP.md .quantis/STATE.md "$PHASE_DIR/"
git commit -m "docs(phase-$PHASE): complete phase"
```

</process>

<context_hygiene>
**After 3 failed debugging attempts:**
1. Stop current approach
2. Document to `.quantis/STATE.md` what was tried
3. Recommend `/wf-pause` for fresh session

> **Cross-reference:** See context-health-monitor Rule 1 for the unified 3-strike protocol.
</context_hygiene>

<offer_next>

**Phase complete, more phases:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PHASE {N} EXECUTION COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
▶ /wf-verify {N} — independent verification (recommended)
▶ /wf-plan {N+1} — plan the next phase
```

**All phases complete:**
```
 Quantis ► MILESTONE COMPLETE 🎉
```

**Gaps found:**
```
 Quantis ► PHASE {N} GAPS FOUND ⚠
▶ /wf-execute {N} --gaps-only
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `executing-plans` | Standalone inline execution (only when invoked outside `/wf-execute`) |
| `subagent-driven-development` | SDD execution with review (CLI-first default) |
| `verification-before-completion` | Must-have verification methodology |
| `context-health-monitor` | 3-strike rule enforcement |
</related>
