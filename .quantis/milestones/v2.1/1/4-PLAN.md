---
phase: 1
plan: 4
wave: 2
---

# Plan 1.4: /stress-test Workflow

## Objective
Create the `/stress-test` workflow that adversarially reviews SPEC.md to find ambiguity, contradictions, missing failure modes, and gaps. This is the proactive quality gate that catches issues before `/plan`'s mandatory marker rejection.

## Context
- .quantis/DECISIONS.md (D-004, D-011)
- .quantis/references/spec-kit/spec-driven.md (lines 180-204 — forced clarification markers)
- .agent/workflows/new-project.md (needs /stress-test suggestion after SPEC creation)
- .quantis/templates/spec.md (Unresolved Questions section format)

## Tasks

<task type="auto">
  <name>Create /stress-test workflow</name>
  <files>.agent/workflows/stress-test.md</files>
  <action>
    Create a new workflow file `.agent/workflows/stress-test.md` with:

    **Frontmatter:**
    ```yaml
    ---
    description: Adversarial spec review — find ambiguity, contradictions, and gaps
    ---
    ```

    **Structure:**
    - Role: "You are a skeptical technical reviewer. Your job is to BREAK the spec."
    - Objective: Read SPEC.md and find every weakness before it becomes a planning/execution bug.
    - Process:

    1. **Load SPEC.md** — Read the entire spec
    2. **Load CONSTITUTION.md** — If exists, check spec against constitutional requirements
    3. **Adversarial Review** — Attack the spec on 7 dimensions:

       a. **Vague Terms**: Find words like "fast", "scalable", "easy", "good", "proper", "appropriate" — demand specific numbers or definitions
       b. **Missing Failure Modes**: For every goal/feature, ask "What happens when this fails?"
       c. **Contradictions**: Find goals/constraints that conflict with each other
       d. **Unstated Assumptions**: Identify things the spec assumes but doesn't declare
       e. **Missing Edge Cases**: Zero items, max items, concurrent access, empty states, malformed input
       f. **Untestable Criteria**: Success criteria that can't be measured objectively
       g. **Constitutional Gaps**: Quality requirements not addressed (error handling? logging? security?)

    4. **Generate Report** — Present findings as numbered issues:
       ```
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        Quantis ► STRESS TEST RESULTS
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

       ISSUES FOUND: {N}

       🔴 CRITICAL (blocks planning)
       1. {issue} → Suggested marker: [NEEDS CLARIFICATION: ...]
       2. {issue}

       🟡 WARNING (should fix)
       3. {issue}
       4. {issue}

       🟢 SUGGESTION (nice to have)
       5. {issue}
       ```

    5. **Auto-insert markers** — Offer to automatically add `[NEEDS CLARIFICATION]` markers to SPEC.md for critical issues
    6. **Update Unresolved Questions** — Auto-generate the "Unresolved Questions" summary section at the bottom of SPEC.md from all inline markers
    7. **Verdict**: PASS (0 critical) / FAIL (1+ critical issues)

    Offer next steps:
    - If FAIL: "Resolve markers in SPEC.md, then run /stress-test again"
    - If PASS: "/plan {N} — ready to create execution plans"

    Related workflows: /new-project, /plan
    Related skills: plan-checker
  </action>
  <verify>
    test -f .agent/workflows/stress-test.md && \
    grep -q "adversarial\|Adversarial" .agent/workflows/stress-test.md && \
    grep -q "NEEDS CLARIFICATION" .agent/workflows/stress-test.md && \
    grep -q "Unresolved Questions" .agent/workflows/stress-test.md && \
    echo "PASS: /stress-test workflow exists with adversarial review"
  </verify>
  <done>
    - /stress-test workflow file exists
    - Reviews spec on 7 adversarial dimensions
    - Generates severity-rated report (critical/warning/suggestion)
    - Auto-inserts [NEEDS CLARIFICATION] markers
    - Auto-generates Unresolved Questions summary
    - Gives pass/fail verdict
  </done>
</task>

<task type="auto">
  <name>Wire /stress-test into /new-project suggestion</name>
  <files>.agent/workflows/new-project.md</files>
  <action>
    In /new-project, after the SPEC creation phase (Phase 5 after renumbering), add a suggestion step:

    ```markdown
    ## Phase 5b: Stress-Test Suggestion

    After SPEC.md is created, suggest:
    ```
    💡 SPEC REVIEW AVAILABLE

    Your spec is written. Before we plan, consider stress-testing it:

    /stress-test — Adversarial review to find gaps and ambiguity

    This is optional but recommended for complex projects.
    Planning will catch unresolved [NEEDS CLARIFICATION] markers either way.

    A) Run /stress-test now
    B) Skip — proceed to roadmap
    ```

    If user selects A: run /stress-test, then return to /new-project flow.
    If user selects B: continue to roadmap creation.
    ```

    This is the D-011 decision: suggested, not forced.
  </action>
  <verify>
    grep -q "stress-test" .agent/workflows/new-project.md && \
    echo "PASS: /stress-test suggested in /new-project"
  </verify>
  <done>
    - /new-project suggests /stress-test after SPEC creation
    - User can accept or skip
    - Clear messaging about it being optional
  </done>
</task>

## Success Criteria
- [ ] /stress-test workflow exists as .agent/workflows/stress-test.md
- [ ] Reviews specs on 7 adversarial dimensions
- [ ] Auto-inserts [NEEDS CLARIFICATION] markers
- [ ] /new-project suggests /stress-test after SPEC creation
