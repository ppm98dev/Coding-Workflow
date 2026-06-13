---
name: wf-verify
description: The Auditor — Validate work against spec with empirical evidence
argument-hint: "<phase-number>"
---

# /verify → verification-before-completion skill

> **Skill-powered workflow.** Verification methodology is powered by `verification-before-completion`. This workflow adds Quantis orchestration (state tracking, ROADMAP updates, gap closure routing).

<role>
You are a Quantis verifier. You validate implemented work against spec requirements using empirical evidence.

**Core principle:** No "trust me, it works." Every verification produces proof.

**Core responsibilities:**
- Extract testable deliverables from phase
- Walk through each requirement
- Collect empirical evidence (commands, screenshots)
- Run senior code review on all code changed during the phase
- Create verification report
- Route gap closure to /plan when issues found
</role>

<objective>
Confirm that implemented work meets spec requirements with documented proof.

The verifier checks the CODEBASE, not SUMMARY claims.
</objective>

<context>
**Phase:** $ARGUMENTS (if omitted: read the current phase from `.quantis/STATE.md`; if STATE.md is ambiguous or missing, list the phases that have a `.quantis/phases/` directory and ask the user — do not guess)

**Required files:**
- `.quantis/SPEC.md` — Original requirements
- `.quantis/ROADMAP.md` — Phase definition with must-haves
- `.quantis/phases/{phase}.{subphase}-{slug}/*-SUMMARY.md` — What was implemented

**Skill reference:** `.agents/skills/verification-before-completion/SKILL.md`
</context>

<process>

## 0. Platform Check

**If `invoke_subagent` is available** (CLI `agy`, Standalone): dispatch a **`research`** subagent for the must-have *checking* (read-only analysis — the reliable pattern), then **write VERIFICATION.md yourself, inline**, from its returned evidence (file-writing is generation, kept inline). First do Steps 1–2 yourself (load context, extract the must-haves); then dispatch the `research` subagent with PATHS to read (not pasted content):
1. The extracted must-haves list (from Step 2) with each one's verification method.
2. Instruction to **read `.agents/skills/verification-before-completion/SKILL.md`** and apply its Gate Function (IDENTIFY → RUN → READ → VERIFY → only then claim) to every check.
3. The `$PHASE_DIR` path — read SUMMARY files and inspect the actual CODEBASE (not SUMMARY claims).

**Required return format:** per must-have — empirical evidence (command output / file refs) + PASS/FAIL/PARTIAL. The orchestrator writes VERIFICATION.md (Step 5) from this — **incrementally if the report is large** (output is capped at 16,384 tokens/turn). If the subagent stalls or returns non-empirical claims, verify inline.

When the subagent returns, the orchestrator:
1. Reviews the verification results
2. Checks that evidence is empirical (not claims)
3. Runs the senior code review (Step 4) — never skipped
4. **Continues at Step 5 (Create Verification Report), Step 6 (Handle Results), and Step 7 (Commit) yourself** — the subagent path skips Steps 3–4's per-must-have legwork ONLY; the orchestrator still owns code review, report writing, state update, gap routing, and commit.

**If the dispatch fails or its output is unusable** (tool error, empty report, non-empirical evidence): re-dispatch ONCE with explicit feedback on what was wrong. If it fails again, fall back to inline verification (Step 1 onward) and say so.

**If `invoke_subagent` is NOT available** (IDE): run verification inline (proceed to Step 1).

> Detection is automatic. Never ask the user which mode to use.

**Subagent types:** `research` = lightweight read-only (preferred for analysis); `self` = heavyweight clone — avoid for file-generation or large prompts. See `.agents/skills/using-quantis/references/antigravity-tools.md`.

## 1. Load Verification Context

**Read and follow `.agents/skills/verification-before-completion/SKILL.md` exactly.** Its Gate Function (IDENTIFY → RUN → READ → VERIFY → only then claim) governs every must-have check below.

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

# 3. Validate — /verify requires an existing directory
if [ -z "$PHASE_DIR" ]; then
    echo "❌ STOP: No phase directory found for '${PHASE}'."
    echo "Available: $(ls .quantis/phases/ 2>/dev/null || echo 'none')"
    echo "Pass the full number (e.g., 3.1) or run /plan first."
    exit 1
fi

# 4. Never-executed guard: plans exist but nothing was built
SUMMARIES=$(ls "$PHASE_DIR"/*-SUMMARY.md 2>/dev/null)
if [ -z "$SUMMARIES" ] && ls "$PHASE_DIR"/*-PLAN.md >/dev/null 2>&1; then
    echo "Phase $PHASE not yet executed (plans exist, no SUMMARYs) — run /execute $PHASE"
    exit 1
fi
```

**If no SUMMARY.md files exist but PLAN.md files do: STOP** — report "Phase {N} not yet executed — run /execute {N}". Do NOT extract must-haves, verify, or route gap closure for unexecuted work.

Read:
- Phase definition from `.quantis/ROADMAP.md`
- Original requirements from `.quantis/SPEC.md`
- All SUMMARY.md files from `"$PHASE_DIR/"`

---

## 2. Extract Must-Haves

From the phase definition, identify **must-haves** — requirements that MUST be true for the phase to be complete.

```markdown
### Must-Haves for Phase {N}
1. {Requirement 1} — How to verify
2. {Requirement 2} — How to verify
3. {Requirement 3} — How to verify
```

---

## 3. Verify Each Must-Have

For each must-have:

### 3a. Determine Verification Method

| Type | Method | Evidence |
|------|--------|----------|
| API/Backend | Run curl or test command | Command output |
| UI (with `browser_subagent`) | `browser_subagent` | Screenshot + WebP recording |
| UI (without `browser_subagent`) | CLI verification: curl, test output, or user confirmation | Command output |
| Visual regression (with `browser_subagent`) | `browser_subagent` | Side-by-side screenshot comparison |
| Build | Run build command | Success output |
| Tests | Run test suite | Test results |
| File exists | Check filesystem | File listing |
| Code behavior | Run specific scenario | Output |

### 3b. Execute Verification

Run the verification command/action.

<!-- `// turbo` marks a command the Antigravity IDE may auto-run without confirmation; ignore on other platforms. -->
// turbo
```bash
# Example: Run tests
npm test
```

### 3c. Record Evidence

For each must-have, record:
- **Status:** PASS / FAIL
- **Evidence:** Command output, screenshot path, etc.
- **Notes:** Any observations

### 3d. Browser-Based Visual Verification (capability-dependent)

**If `browser_subagent` tool is available** in your current environment, use it for UI verification:
- Navigate to the target URL and validate visual state
- Capture screenshots as evidence for VERIFICATION.md
- All sessions auto-recorded as WebP video artifacts
- Use for any must-have that involves visual output

**If `browser_subagent` is NOT available** (e.g., CLI), do BOTH:

1. **Run CLI-based evidence** where possible:
   - `curl` responses for web endpoints
   - Test runner output for UI component tests

2. **Generate a browser verification handoff** for any must-have requiring visual proof:

   Write `"$PHASE_DIR/BROWSER-VERIFY.md"` with the following format:

   ```markdown
   # Browser Verification — Phase {N}

   > Generated by CLI. Open the Antigravity IDE and paste this file
   > to run browser-based verification with `browser_subagent`.

   ## Must-Haves Requiring Browser Verification

   ### 1. {Must-have description}
   - **Navigate to:** {URL}
   - **Expected:** {what should be visible}
   - **Actions:** {clicks, form fills, etc.}
   - **Recording name:** `{descriptive_name}`

   ### 2. {Must-have description}
   - **Navigate to:** {URL}
   - **Expected:** {what should be visible}
   - **Recording name:** `{descriptive_name}`

   ## After Running
   Save screenshots and recordings as evidence in this directory.
   Update VERIFICATION.md with browser evidence.
   ```

   Then display:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Quantis ► BROWSER VERIFICATION NEEDED
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   {X} must-haves require browser verification.
   Prompt saved to: {PHASE_DIR}/BROWSER-VERIFY.md

   ───────────────────────────────────────────────────────

   ▶ Open IDE and run:

   "Run the browser verification in
    .quantis/phases/{N}-{slug}/BROWSER-VERIFY.md"

   ───────────────────────────────────────────────────────
   ```

---

## 4. Senior Code Review

Must-haves prove the phase does what the spec asked. This step proves the code is well-built: no bugs, dead code, or unhandled edge cases. It is never skipped. Review findings are evidence-backed (file:line references), not impressions — this does not conflict with the forbidden-phrases rule, which bans unverified success claims.

### 4a. Determine Review Scope

Review the code changed during this phase — never the full codebase. Derive the diff range from git:

```bash
# First and last commits scoped to this phase (commits are tagged feat/docs(phase-$PHASE))
FIRST_SHA=$(git log --reverse --grep="(phase-$PHASE)" --format=%H | head -n 1)
HEAD_SHA=$(git log --grep="(phase-$PHASE)" --format=%H | head -n 1)
if [ -z "$FIRST_SHA" ] || [ -z "$HEAD_SHA" ]; then
    echo "⚠️ No (phase-$PHASE) commits found — falling back to SUMMARY 'files changed'"
else
    BASE_SHA=$(git rev-parse "$FIRST_SHA^")
    echo "Review range: $BASE_SHA..$HEAD_SHA"
    git diff --stat "$BASE_SHA".."$HEAD_SHA"
fi
```

**Fallback:** if no `(phase-$PHASE)` commits exist, take the changed-files list from the SUMMARY.md files' "Files Changed" sections and review those files' current contents. Never expand scope to the whole repository.

### 4b. Run the Review

**If `invoke_subagent` is available**, dispatch a senior code reviewer subagent using the template at `.agents/skills/requesting-code-review/code-reviewer.md`. Fill its placeholders:
- `{DESCRIPTION}` — what the phase implemented (from SUMMARY.md / spec)
- `{PLAN_OR_REQUIREMENTS}` — the phase SPEC.md must-haves
- `{BASE_SHA}` / `{HEAD_SHA}` — the range from Step 4a

Paste the template text and the diff into the subagent prompt (subagents do not inherit your context). If the diff is large, batch the changed files across multiple reviewer dispatches and merge their findings. Do not ask the user — dispatch automatically.

**If `invoke_subagent` is NOT available** (IDE), review inline, file-by-file, against the same `code-reviewer.md` checklist (plan alignment, code quality, architecture, testing, production readiness). Read each changed file's actual diff/contents before recording any finding.

This review is a phase-scoped backstop, complementary to SDD's task-scoped `code-quality-reviewer` — run it even when SDD reviews already ran during /execute.

### 4c. Record Findings

Classify every finding as **Critical**, **Important**, or **Minor**, each with a `file:line` reference. These feed the `## Code Review` section of the report (Step 5) and the verdict: PASS additionally requires zero unresolved Critical/Important findings. Unresolved Critical/Important findings are routed to gap closure (Step 6).

---

## 5. Create Verification Report

Write `"$PHASE_DIR/VERIFICATION.md"`:

```markdown
---
phase: {N}
verified_at: {timestamp}
verdict: PASS | FAIL | PARTIAL
---

# Phase {N} Verification Report

## Summary
{X}/{Y} must-haves verified

## Must-Haves

### ✅ {Must-have 1}
**Status:** PASS
**Evidence:** 
```
{command output or description}
```

### ❌ {Must-have 2}
**Status:** FAIL
**Reason:** {why it failed}
**Expected:** {what should happen}
**Actual:** {what happened}

## Code Review
**Scope:** {N} files changed, {BASE_SHA}..{HEAD_SHA}
**Mode:** {subagent | inline}

### Critical
{findings with file:line, or "None"}

### Important
{findings with file:line, or "None"}

### Minor
{findings with file:line, or "None"}

## Verdict
{PASS | FAIL | PARTIAL}

PASS requires every must-have verified AND no unresolved Critical/Important review findings.

## Gap Closure Required
{If FAIL, list what needs to be fixed}
```

---

## 6. Handle Results

### If PASS (all must-haves verified, no unresolved Critical/Important review findings):

**Update `.quantis/STATE.md` — edit in place, do NOT replace the whole file.** Edit only the **Phase** and **Status** fields inside the existing `## Current Position` section and refresh `## Next Steps`; preserve every other section (`Last Session Summary`, `Blockers`, `Context Dump`) that `/resume-session` reads.
```markdown
## Current Position
- **Phase**: {N} (verified)
- **Status**: ✅ Complete and verified
```

**Update `.quantis/ROADMAP.md` — REQUIRED:** Set the phase's status line to `✅ Complete ({date})` and check off its deliverables. Idempotent: if `/execute` already marked it, leave it.

Output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PHASE {N} VERIFIED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{X}/{X} must-haves verified

All requirements satisfied.

───────────────────────────────────────────────────────

▶ Next Up

/plan {N+1} — plan the next phase

───────────────────────────────────────────────────────
```

### If FAIL (some must-haves failed):

**Update `.quantis/STATE.md`** (edit in place — preserve other sections):
```
- **Status**: ⚠ Verification failed — {Z} gaps
- **Next**: /plan {N} --gaps
```

**Update `.quantis/ROADMAP.md`:** Set phase status to `🔄 Gap closure`.

**Route to gap planning — do NOT author fix plans here.**

Recommend `/plan {N} --gaps`. That command reads this VERIFICATION.md and creates one gap-closure plan per FAILed must-have (checkbox format, `gap_closure: true` / `wave: 1` frontmatter, `-PLAN.md` suffix), so `/execute {N} --gaps-only` can discover and run them. /verify owns the verdict and the routing; /plan owns the plans.

**Gap-closure loop cap (audit H8):** If the same must-have fails verification after **2** gap-closure rounds (check VERIFICATION.md history / prior gap plans for the phase), do NOT recommend a third fix round. Treat it as an architectural or spec problem: record the failure history in STATE.md, point the user to `systematic-debugging` Phase 4 ("question the architecture", step 5), and ask whether to revise the spec or the approach. This prevents an unbounded verify → gaps → execute → verify loop.

Output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PHASE {N} GAPS FOUND ⚠
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{X}/{Y} must-haves verified
{Z} issues require fixes

Gaps recorded in VERIFICATION.md.

───────────────────────────────────────────────────────

▶ Next Up

/plan {N} --gaps — generate fix plans from VERIFICATION.md (then /execute {N} --gaps-only)

───────────────────────────────────────────────────────
```

### If PARTIAL (browser-pending or mixed results)

Some must-haves verified, some pending browser confirmation or mixed results.

Update `.quantis/STATE.md` (edit in place — preserve other sections):
```
## Current Position
- **Phase**: {N} (partially verified)
- **Status**: ⏳ PARTIAL — {X} verified, {Y} pending browser, {Z} failed
- **Next**: Re-run `/verify {N}` after browser evidence lands
```

Update `.quantis/ROADMAP.md`: set phase status to `🔄 Verification pending`.

**Do NOT claim the phase is complete.** Do NOT write "verified" in STATE.md. Stage BROWSER-VERIFY.md in the commit if it exists.

Any pending browser must-haves → verdict is PARTIAL, never PASS.

---

## 7. Commit Verification

```bash
git add "$PHASE_DIR/VERIFICATION.md" .quantis/ROADMAP.md .quantis/STATE.md
# Include BROWSER-VERIFY.md if it exists
test -f "$PHASE_DIR/BROWSER-VERIFY.md" && git add "$PHASE_DIR/BROWSER-VERIFY.md"
git commit -m "docs(phase-$PHASE): verification report"
```

**Self-check:** If verdict was PASS, run `git show --stat HEAD` and verify ROADMAP.md is listed. If not, the Step 6 update was skipped — go back, update ROADMAP, then `git commit --amend`.

</process>

<evidence_requirements>

## Forbidden Phrases

Never accept these as verification:
- "This should work"
- "The code looks correct"
- "I've made similar changes before"
- "Based on my understanding"
- "It follows the pattern"

## Required Evidence

| Claim | Required Proof |
|-------|----------------|
| "Tests pass" | Actual test output |
| "API works" | Curl command + response |
| "UI renders" | Screenshot (via `browser_subagent` if available, else BROWSER-VERIFY.md handoff) |
| "UI works" (with `browser_subagent`) | `browser_subagent` screenshot + recording |
| "UI works" (without `browser_subagent`) | curl + test output, then BROWSER-VERIFY.md for visual proof |
| "Build succeeds" | Build output |
| "File created" | `ls` or `dir` output |

</evidence_requirements>

<related>
## Related

### Workflows
| Command | Relationship |
|---------|--------------|
| `/execute` | Run before /verify to implement work |
| `/execute --gaps-only` | Fix issues found by /verify |
| `/debug-issue` | Diagnose verification failures |

### Skills
| Skill | Purpose |
|-------|---------|
| `verification-before-completion` | Detailed verification methodology |
| `requesting-code-review` | Senior code review template (Step 4) |
| `context-health-monitor` | Context budget monitoring |
</related>
