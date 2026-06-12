---
name: wf-plan
description: The Strategist — Create executable PLAN.md files for a phase already defined in ROADMAP.md
argument-hint: "[phase] [--research] [--skip-research] [--gaps] [--skip-stress-test]"
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
- `--gaps` — Gap closure mode (reads VERIFICATION.md, skips research and the spec stress-test gate)
- `--skip-stress-test` — Skip the Step 1.5 spec stress-test gate (spec already reviewed elsewhere)

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
grep -q "FINALIZED" ".quantis/SPEC.md" || { echo "❌ STOP: SPEC.md must be FINALIZED before planning."; exit 1; }
test -f ".agents/rules/CONSTITUTION.md" || echo "⚠️ No .agents/rules/CONSTITUTION.md — quality standards not enforced"
```

**If the SPEC check fails: STOP.** Do not continue to Step 1.5. Tell the user to finalize the SPEC first. (⚠️ warnings are non-blocking.)

## 1.5 Spec Stress-Test Gate

**Skip this step if** `--gaps` or `--skip-stress-test` was passed.

```bash
grep -q "Stress-tested:" ".quantis/SPEC.md" && echo "Spec already stress-tested" || echo "Spec NOT stress-tested"
```

**If the spec has NOT been stress-tested:** run `/wf-stress-test .quantis/SPEC.md` (spec mode) before planning. It stamps `Stress-tested: {date}` into the spec on completion.
- **Critical findings → STOP.** Tell the user: "Spec has unresolved critical findings — fix them, or pass `--skip-stress-test` to plan anyway." Do not continue to Step 2.
- No critical findings → continue.

## 2. Parse Arguments
Extract phase number (or auto-detect next unplanned phase from ROADMAP.md) and flags.

**Auto-detect** = the lowest-numbered phase in the current milestone whose ROADMAP Status is ⬜ or 🔄 AND whose `.quantis/phases/{N}.{M}-*/` directory contains no `*-PLAN.md`. Confirm the detected phase with the user before proceeding.

```bash
# ─── Phase Directory Resolution (unified) ───────────────
# $PHASE is set from $ARGUMENTS (e.g., "3.1", "3", "1")

# 1. Reuse existing dir if present (keeps /plan, /execute, /verify consistent)
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

# 3. If still no match, derive from ROADMAP (current milestone only, LAST match)
if [ -z "$PHASE_DIR" ]; then
    # Scope grep to current (non-CLOSED) milestone section
    PHASE_TITLE=$(grep -E "^#{2,4} Phase ${PHASE}:" .quantis/ROADMAP.md | tail -n 1 | sed -E 's/.*Phase [0-9.]+:? (.*)/\1/' | sed 's/ *[✅⬜🔄⏸].*//' | tr -d '\r')
    if [ -z "$PHASE_TITLE" ]; then
        echo "❌ STOP: Phase $PHASE not found in ROADMAP.md."
        echo "Pass the full number (e.g., 3.1) or check /progress."
        exit 1
    fi
    PHASE_SLUG=$(echo "$PHASE_TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g')
    PHASE_DIR=".quantis/phases/${PHASE}-${PHASE_SLUG}"
    mkdir -p "$PHASE_DIR"
fi

echo "Phase directory: $PHASE_DIR"
```

## 3. Handle Research

**If `--gaps`:** Go to Step 3b (Gaps Mode) — skip research and ecosystem discovery.
**If `--skip-research`:** Skip to step 4.

**Check existing:** `test -f "$PHASE_DIR/RESEARCH.md"`

**If research needed (new phase or `--research` forced):**
- Assess discovery level:
  - **L0 (skip)** — Pure internal work, established patterns
  - **L1 (quick)** — Single known library, confirming syntax
  - **L1.5 (discovery)** — Quick A-vs-B comparison → DISCOVERY.md
  - **L2 (standard)** — 2-3 options, new integration → RESEARCH.md
  - **L3 (deep dive)** — Architectural decision, novel problem → full RESEARCH.md
- Create RESEARCH.md inside `$PHASE_DIR/`

## 3.5 Discover Ecosystem Assets

```bash
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Quantis ► ECOSYSTEM DISCOVERY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Discover custom skills installed by the user (excluding built-in manifest skills)
echo "💡 DISCOVERED CUSTOM SKILLS (from skills.sh):"
CUSTOM_SKILLS_FOUND=0
if [ ! -f MANIFEST.md ]; then
    echo "  - MANIFEST.md not found — cannot distinguish core vs custom skills; skipping detection"
else
    for skill_dir in $(ls .agents/skills/ 2>/dev/null); do
        # Cross-reference with MANIFEST.md to exclude core skills
        if ! grep -q "^- $skill_dir$" MANIFEST.md; then
            # Found a custom skill! Read the description from its SKILL.md frontmatter
            SKILL_FILE=".agents/skills/$skill_dir/SKILL.md"
            if [ -f "$SKILL_FILE" ]; then
                DESC=$(grep -A5 "^description:" "$SKILL_FILE" 2>/dev/null | head -n 1 | sed -E 's/description:? (.*)/\1/' | tr -d '"' | tr -d "'")
                echo "  - $skill_dir: ${DESC:-No description provided}"
                CUSTOM_SKILLS_FOUND=$((CUSTOM_SKILLS_FOUND + 1))
            fi
        fi
    done
    if [ "$CUSTOM_SKILLS_FOUND" -eq 0 ]; then
        echo "  - None installed (visit https://www.skills.sh to install custom skills)"
    fi
fi

echo ""

# Discover connected MCP servers
echo "🔌 CONNECTED MCP SERVERS:"
# IDE stores MCP schemas on disk; CLI (agy) / Standalone expose MCP tools directly in the session tool list.
MCP_FOUND=0
for MCP_DIR in "$HOME/.gemini/antigravity-ide/mcp" "$HOME/.gemini/mcp" "$HOME/.config/agy/mcp"; do
    [ -d "$MCP_DIR" ] || continue
    for server in $(ls "$MCP_DIR" 2>/dev/null); do
        if [ -d "$MCP_DIR/$server" ]; then
            # List tools by parsing the .json schemas
            TOOLS=$(ls "$MCP_DIR/$server" 2>/dev/null | grep "\.json$" | sed 's/\.json//g' | tr '
' ' ' | sed 's/ $//')
            echo "  - $server: tools -> [ $TOOLS ]"
            MCP_FOUND=$((MCP_FOUND + 1))
        fi
    done
done
if [ "$MCP_FOUND" -eq 0 ]; then
    echo "  - No on-disk MCP schemas found. On CLI/Standalone this is normal — inspect your own tool list for any mcp__* tools and treat those as connected MCP servers. Do not report 'None' without checking your tool list."
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 INSTRUCTION FOR PLANNING: Review the discovered"
echo "skills and MCP tools above. Leverage them inside your"
echo "tasks instead of writing custom code from scratch."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

## 3b. Gaps Mode (`--gaps`)

Entered only when `--gaps` was passed (routed from Step 3). Skips research and ecosystem discovery.

```bash
test -f "$PHASE_DIR/VERIFICATION.md" || { echo "❌ STOP: No VERIFICATION.md for phase $PHASE — run /verify {N} first."; exit 1; }
```

**If the STOP line printed: halt.** Do not author plans without a verification report.

Read `$PHASE_DIR/VERIFICATION.md`. For **each must-have with `Status: FAIL`**, create one fix plan in `$PHASE_DIR/` named `{N}-gap-{issue-slug}-PLAN.md` (the `-PLAN.md` suffix is REQUIRED — `/execute {N} --gaps-only` discovers gap plans by it). Each plan uses the **checkbox** task format from `writing-plans` (`### Task N` with `- [ ]` steps and `Run:`/`Expected:` verification — never XML), with this frontmatter:

```markdown
---
phase: {N}
plan: gap-{issue-slug}
wave: 1
gap_closure: true
---
```

`gap_closure: true` is REQUIRED (the `--gaps-only` filter keys on it); `wave: 1` so all gap plans run together. Skip Step 3 (research) and Step 3.5 (ecosystem) entirely, then go to Step 5 (Plan Checker).

## 4. Delegate to Skill

### Subagent Planning (when available)

**If `invoke_subagent` is available** (CLI `agy`, Standalone): **you MUST dispatch a `self` subagent to write the plans — do not write them inline.** The subagent prompt MUST contain, **pasted in full** (subagents do NOT inherit your context — paste CONTENTS, not paths, except where noted):
- The SPEC.md content.
- The full contents of `.agents/skills/writing-plans/SKILL.md`.
- The `$PHASE_DIR` path and the naming convention `{N}.{M}-{plan-slug}-PLAN.md`.
- The `.agents/rules/CONSTITUTION.md` quality standards.
- RESEARCH.md findings and ARCHITECTURE.md (if they exist).
- Any custom skills / MCP context discovered in Step 3.5.

**Required return format:** PLAN.md file(s) written to `$PHASE_DIR/` following writing-plans' header and task structure.

When the subagent returns, **continue at Step 5** (Plan Checker): review the output for task specificity, executable verify commands, and wave structure, then present key decisions to the user.

**If the dispatch fails or returns unusable plans** (tool error, empty/missing file, unusable output): re-dispatch ONCE with explicit feedback on what was wrong. On a second failure, fall back to the inline procedure below and say so.

**Subagent types** (`.agents/skills/using-quantis/references/antigravity-tools.md`): `self` = clone of the calling agent with the same capabilities.

**If `invoke_subagent` is NOT available**, follow the writing-plans skill inline:

**Read and follow `.agents/skills/writing-plans/SKILL.md` exactly.**

Provide the skill with:
- Phase number and objectives from ROADMAP.md
- SPEC.md requirements
- .agents/rules/CONSTITUTION.md quality standards
- RESEARCH.md findings (if exists)
- ARCHITECTURE.md (if exists)

Output plans to `.quantis/phases/{N}.{M}-{slug}/` using `{N}.{M}-{plan-slug}-PLAN.md` naming.

## 5. Adversarial Plan Review (max 3 iterations)
The plan's author must not be its only reviewer.

**If `invoke_subagent` is available:** dispatch a fresh `self` subagent that has NOT seen this planning conversation. Paste in full (subagents do not inherit context): the PLAN.md file(s), `.quantis/SPEC.md`, and `.agents/skills/wf-stress-test/SKILL.md`, with the instruction "Run this skill in PLAN MODE against these plans and return the findings report."

**If `invoke_subagent` is NOT available:** dispatch the plan review inline using the template at `.agents/skills/writing-plans/plan-document-reviewer-prompt.md` — fill in the PLAN and SPEC paths and run its checklist with fresh eyes.

Either way, the reviewer checks:
- [ ] Every spec requirement maps to at least one task
- [ ] All referenced files exist or will be created
- [ ] Actions are specific (no vague "implement X")
- [ ] Every task has `Run:` commands with `Expected:` output
- [ ] Every task's final step has measurable acceptance criteria
- [ ] No placeholders (TBD/TODO); types, names, and signatures are consistent across tasks
- [ ] Tests verify real behavior (no tautological asserts, no mock-everything)
- [ ] Plan has YAML frontmatter with `phase`, `plan`, `wave`, `gap_closure` fields
- [ ] Filename ends in `-PLAN.md`

**If issues found:** fix and re-review. **After 3 iterations with unresolved findings: STOP and ask the user** how to proceed — do not silently commit a plan that still fails review.

## 5.5 External-Model Review (optional)
The findings report from Step 5 is the interchange format. If the user wants a second-opinion review from an external model, hand it that findings file plus the plan. Triage the returned feedback with `.agents/skills/receiving-code-review/SKILL.md` (verify before implementing; push back on findings that don't apply) before editing any plan.

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
| `wf-stress-test` | Spec gate (Step 1.5) and adversarial plan review (Step 5) |
| `receiving-code-review` | Triage external model feedback (Step 5.5) |
</related>
