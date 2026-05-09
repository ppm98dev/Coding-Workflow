---
description: Adversarial spec review — find ambiguity, contradictions, and gaps
---

# /stress-test Workflow

<role>
You are a skeptical technical reviewer. Your job is to BREAK the spec.

Find every weakness, ambiguity, contradiction, and gap before it becomes a planning or execution bug. You are adversarial — challenge everything. Be specific.
</role>

<objective>
Read SPEC.md and adversarially review it on 7 dimensions. Generate a severity-rated report of issues. Optionally auto-insert `[NEEDS CLARIFICATION]` markers into the spec and update the Unresolved Questions summary section.

**When to run:**
- After creating SPEC.md (suggested by `/new-project`)
- Before `/plan` (catch issues early)
- Anytime the spec is updated
</objective>

<context>
**Required files:**
- `.gsd/SPEC.md` — The spec to stress-test

**Optional files:**
- `.gsd/CONSTITUTION.md` — Check spec against constitutional requirements
</context>

<process>

## 1. Load Context

```bash
# Required
test -f ".gsd/SPEC.md" || { echo "Error: No SPEC.md found" >&2; exit 1; }

# Optional
test -f ".gsd/CONSTITUTION.md" && echo "Constitution loaded — will check compliance"
```

Display banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► STRESS TEST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Adversarial review of SPEC.md
Finding gaps before they become bugs...
```

---

## 2. Adversarial Review (7 Dimensions)

Read the entire SPEC.md and attack it on each dimension:

### 2a. Vague Terms
Find words that lack specific definitions:
- "fast", "scalable", "easy", "good", "proper", "appropriate", "efficient"
- "should", "might", "could" (instead of "must", "will")
- "etc.", "and so on", "similar"
- Undefined quantities: "many", "few", "some", "large"

**For each:** Demand a specific number, definition, or threshold.

### 2b. Missing Failure Modes
For every goal, feature, and interaction described:
- "What happens when this fails?"
- "What if the external service is down?"
- "What if the user provides malformed input?"
- "What if two users do this simultaneously?"
- "What if the database is full / disk is full / memory is exhausted?"

### 2c. Contradictions
Find goals, constraints, or requirements that conflict:
- "Goal A says 'lightweight' but Constraint B requires a heavy ORM"
- "Success Criteria X contradicts Non-Goal Y"
- "Quality Requirement says 'fail-fast' but Goal Z says 'graceful degradation'"

### 2d. Unstated Assumptions
Identify things the spec assumes but doesn't declare:
- User has an account? Has internet? Has specific OS?
- Database exists? Is pre-populated? Has specific schema?
- External services are available? Have specific APIs?
- Authentication is already handled? Permissions are configured?

### 2e. Missing Edge Cases
Probe boundary conditions:
- Zero items, one item, maximum items
- Empty strings, null values, special characters
- Concurrent writes, race conditions
- First-time user vs returning user
- Offline/degraded mode
- Timezone, locale, encoding issues

### 2f. Untestable Criteria
Check each success criterion:
- Can it be measured objectively?
- Does it have a specific threshold?
- Is "done" clearly defined?
- Would two people agree whether it's met?

**Red flags:** "works well", "is intuitive", "performs adequately", "handles errors properly"

### 2g. Constitutional Gaps (if CONSTITUTION.md exists)
Check the spec against each constitutional article:
- Does the spec address error handling strategy? (Article 2)
- Are logging requirements mentioned? (Article 3)
- Is input validation scope defined? (Article 4)
- Are testing expectations set? (Article 5)
- Are security requirements covered? (Article 6)

---

## 3. Generate Report

Rate each issue by severity:

| Severity | Meaning | Action |
|----------|---------|--------|
| 🔴 CRITICAL | Blocks planning — ambiguity that will cause wrong implementation | Must fix |
| 🟡 WARNING | Should fix — gap that could cause problems | Should fix |
| 🟢 SUGGESTION | Nice to have — improvement that would strengthen the spec | Optional |

Present findings:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► STRESS TEST RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ISSUES FOUND: {N}

🔴 CRITICAL ({count})
1. [Dimension: Vague Terms] "{term}" in Goals — no specific definition
   → Suggested marker: [NEEDS CLARIFICATION: what does "{term}" mean specifically?]
2. [Dimension: Missing Failure Modes] Goal 3 has no error scenario
   → Suggested marker: [NEEDS CLARIFICATION: what happens when {X} fails?]

🟡 WARNING ({count})
3. [Dimension: Untestable Criteria] Success Criterion 2 says "works well"
   → Suggestion: Replace with measurable threshold
4. [Dimension: Constitutional Gaps] No logging requirements in spec
   → Suggestion: Add to Quality Requirements section

🟢 SUGGESTION ({count})
5. [Dimension: Edge Cases] No mention of concurrent access
   → Consider adding edge case for race conditions

───────────────────────────────────────────────────────

VERDICT: {PASS | FAIL}
{PASS if 0 critical issues, FAIL if 1+ critical}
```

---

## 4. Offer Auto-Fix

If critical issues found:

```
Would you like me to auto-insert [NEEDS CLARIFICATION] markers?

A) Yes — add markers to SPEC.md for all critical issues
B) No — I'll fix them manually
```

**If "Yes":**
- Insert `[NEEDS CLARIFICATION: specific question]` markers inline at the relevant locations in SPEC.md
- Update the "Unresolved Questions" section at the bottom with a summary of all markers

---

## 5. Update Unresolved Questions Section

Collect all `[NEEDS CLARIFICATION]` markers from SPEC.md (both existing and newly added).

Update the "Unresolved Questions" section:

```markdown
## Unresolved Questions
<!-- Auto-generated by /stress-test -->
1. Line {N}: {question from marker}
2. Line {N}: {question from marker}

**{count} unresolved questions must be addressed before FINALIZED.**
```

---

## 6. Offer Next Steps

```
───────────────────────────────────────────────────────

▶ NEXT

{If FAIL:}
1. Resolve [NEEDS CLARIFICATION] markers in SPEC.md
2. Run /stress-test again to verify

{If PASS:}
/plan {N} — ready to create execution plans

───────────────────────────────────────────────────────
```

</process>

<related>
## Related

### Workflows
| Command | Relationship |
|---------|--------------|
| `/new-project` | Suggests /stress-test after SPEC creation |
| `/plan` | Plan-checker also rejects unresolved markers |

### Skills
| Skill | Purpose |
|-------|---------|
| `plan-checker` | Spec Clarity Gate enforces the same rule at plan time |
</related>
