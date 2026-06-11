---
description: Adversarial spec review — find ambiguity, contradictions, and gaps
argument-hint: "[target-file]"
---

# /stress-test → brainstorming skill (critique mode)

> **Skill-powered workflow.** Critique methodology is powered by `brainstorming`. This workflow adds the Quantis 7-dimension adversarial framework.

<role>
You are a Quantis adversarial reviewer. You systematically attack a spec/plan across 7 dimensions to surface problems before they become bugs.
</role>

<context>
**Target:** $ARGUMENTS (optional — defaults to `.quantis/SPEC.md`)

**Required files:**
- `.quantis/SPEC.md` — Primary review target
- `.quantis/ROADMAP.md` — Phase scope for context
- `.quantis/DECISIONS.md` — Decisions to validate
</context>

<process>

## 0. Platform Check

**If `invoke_subagent` is available**, dispatch a `self` subagent with:
- The SPEC.md and/or PLAN.md content
- The brainstorming skill in adversarial critique mode
- Instructions to attack across all 7 dimensions below

The subagent produces a findings report. The orchestrator then:
1. Reviews the findings
2. Filters for severity (critical vs nice-to-have)
3. Presents findings to the user with recommended actions

**If `invoke_subagent` is NOT available**, run the adversarial critique inline (proceed to Step 1).

## 1. Load Context
Read target file + SPEC.md + ROADMAP.md + DECISIONS.md.

## 2. Set Critique Mindset
**Read `.agents/skills/brainstorming/SKILL.md`** and adopt adversarial critique mode.

Your job is to BREAK the spec, not validate it. Assume everything is wrong until proven otherwise.

## 3. Apply 7-Dimension Adversarial Review

For each dimension, actively seek problems:

### Dimension 1: Completeness
- Are all user stories covered?
- Are error states defined?
- What happens when things go wrong?

### Dimension 2: Consistency
- Do requirements contradict each other?
- Are terms used consistently?
- Do constraints conflict with goals?

### Dimension 3: Feasibility
- Can this actually be built with the stated constraints?
- Are timeline estimates realistic?
- Are there hidden dependencies?

### Dimension 4: Edge Cases
- What happens at boundaries (empty input, max values, concurrent access)?
- What about the first user? The millionth?
- Timezone, locale, encoding issues?

### Dimension 5: Security
- What attack vectors exist?
- Where is user input trusted without validation?
- Are there authorization gaps?

### Dimension 6: Performance
- Will this scale to expected load?
- Where are the bottlenecks?
- What happens under stress (10x, 100x expected)?

### Dimension 7: Maintainability
- Can this be maintained long-term?
- Are there hidden coupling points?
- Will future developers understand the decisions?

## 4. Generate Report

For each finding:
```markdown
### [SEVERITY] Finding Title
**Dimension:** {which of the 7}
**Problem:** {what's wrong}
**Impact:** {what happens if unfixed}
**Suggestion:** {how to fix}
```

Severity: `🔴 Critical` | `🟠 High` | `🟡 Medium` | `🔵 Low`

## 5. Update Spec (if applicable)
Add unresolved questions to SPEC.md's `## Unresolved Questions` section.
Document decisions in DECISIONS.md.

## 6. Offer Next Steps
Update STATE.md.

</process>

<offer_next>
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► STRESS TEST COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{X} findings: {critical} 🔴  {high} 🟠  {medium} 🟡  {low} 🔵

▶ Fix critical issues, then /plan {N}
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `brainstorming` | Critique methodology (delegated) |
</related>
