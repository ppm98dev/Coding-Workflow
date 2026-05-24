---
description: The Auditor — Validate work against spec with empirical evidence
argument-hint: "<phase-number>"
---

# /verify Workflow

<role>
You are a Quantis verifier. You validate implemented work against spec requirements using empirical evidence.

**Core principle:** No "trust me, it works." Every verification produces proof.

**Core responsibilities:**
- Extract testable deliverables from phase
- Walk through each requirement
- Collect empirical evidence (commands, screenshots)
- Create verification report
- Generate fix plans if issues found
</role>

<objective>
Confirm that implemented work meets spec requirements with documented proof.

The verifier checks the CODEBASE, not SUMMARY claims.
</objective>

<context>
**Phase:** $ARGUMENTS (required — phase number to verify)

**Required files:**
- `.quantis/SPEC.md` — Original requirements
- `.quantis/ROADMAP.md` — Phase definition with must-haves
- `.quantis/phases/{phase}/*-SUMMARY.md` — What was implemented

**Skill reference:** `.agents/skills/verification-before-completion/SKILL.md`

> Before starting verification, read and follow the `verification-before-completion` skill for the full methodology.

<process>

## 1. Load Verification Context

Read:
- Phase definition from `.quantis/ROADMAP.md`
- Original requirements from `.quantis/SPEC.md`
- All SUMMARY.md files from `.quantis/phases/{phase}/`

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
| UI | Use browser tool | Screenshot |
| UI (Antigravity) | `browser_subagent` | Screenshot + WebP recording |
| Visual regression | `browser_subagent` | Side-by-side screenshot comparison |
| Build | Run build command | Success output |
| Tests | Run test suite | Test results |
| File exists | Check filesystem | File listing |
| Code behavior | Run specific scenario | Output |

### 3b. Execute Verification

Run the verification command/action.

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

### 3d. Antigravity Visual Verification (Optional)

When running in Antigravity, use `browser_subagent` for UI verification:
- Navigate to the target URL and validate visual state
- Capture screenshots as evidence for VERIFICATION.md
- All sessions auto-recorded as WebP video artifacts
- Use for any must-have that involves visual output

**Note:** This is optional. Traditional command-line verification still works.
Antigravity adapter details: see [adapters/ANTIGRAVITY.md](../../adapters/ANTIGRAVITY.md)

---

## 4. Create Verification Report

Write `.quantis/phases/{phase}/VERIFICATION.md`:

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

## Verdict
{PASS | FAIL | PARTIAL}

## Gap Closure Required
{If FAIL, list what needs to be fixed}
```

---

## 5. Handle Results

### If PASS (all must-haves verified):

Update `.quantis/STATE.md`:
```markdown
## Current Position
- **Phase**: {N} (verified)
- **Status**: ✅ Complete and verified
```

Output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PHASE {N} VERIFIED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{X}/{X} must-haves verified

All requirements satisfied.

───────────────────────────────────────────────────────

▶ Next Up

/execute {N+1} — proceed to next phase

───────────────────────────────────────────────────────
```

### If FAIL (some must-haves failed):

**Create gap closure plans:**

For each failed must-have, create a fix plan in `.quantis/phases/{phase}/`:

```markdown
---
phase: {N}
plan: fix-{issue}
wave: 1
gap_closure: true
---

# Fix Plan: {Issue Name}

## Problem
{What failed and why}

## Tasks

<task type="auto">
  <name>Fix {issue}</name>
  <files>{files to modify}</files>
  <action>{specific fix instructions}</action>
  <verify>{how to verify the fix}</verify>
  <done>{acceptance criteria}</done>
</task>
```

Output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PHASE {N} GAPS FOUND ⚠
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{X}/{Y} must-haves verified
{Z} issues require fixes

Gap closure plans created.

───────────────────────────────────────────────────────

▶ Next Up

/execute {N} --gaps-only — run fix plans

───────────────────────────────────────────────────────
```

---

## 6. Commit Verification

```bash
git add .quantis/phases/{phase}/VERIFICATION.md
git commit -m "docs(phase-{N}): verification report"
```

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
| "UI renders" | Screenshot |
| "UI works" (Antigravity) | `browser_subagent` screenshot + recording |
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
| `/debug` | Diagnose verification failures |

### Skills
| Skill | Purpose |
|-------|---------|
| `verification-before-completion` | Detailed verification methodology |
| `context-health-monitor` | Context budget monitoring |
</related>
