---
name: wf-stress-test
description: Adversarial spec review — find ambiguity, contradictions, and gaps
argument-hint: "[target-file]"
---

# /wf-stress-test

> **Self-contained workflow.** The Quantis 7-dimension adversarial framework is the methodology — there is no delegated critique skill. When `invoke_subagent` is available, the 7 dimensions run as parallel read-only subagents.

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

**If `invoke_subagent` is available** (CLI `agy`, Standalone): the 7 dimensions are independent, read-only analyses — dispatch them as parallel **`research`** subagents (the reliable type for analysis). Read `.agents/skills/dispatching-parallel-agents/SKILL.md`, then dispatch **7 parallel `research` subagents — one per dimension from Step 3**, invoked all together. Give each PATHS to read (it reads them into its own clean window — do not paste):
1. The target file path ($ARGUMENTS, default `.quantis/SPEC.md`), plus `.quantis/ROADMAP.md` and relevant `.quantis/DECISIONS.md` — instruct it to read them.
2. The adversarial mandate: "Your job is to BREAK this spec, not validate it. Assume everything is wrong until proven otherwise."
3. That subagent's single dimension copied verbatim from Step 3 (its questions), and the per-finding report format from Step 4.

**Required return format:** the Step 4 finding blocks (`### [SEVERITY] ...` with Dimension/Problem/Impact/Suggestion), severity-tagged.

When all 7 return: **continue at Step 4** — merge their findings (dedupe overlaps), then run Steps 4–6 yourself.

**If a dispatch fails or returns an empty/unusable report:** re-dispatch ONCE with explicit feedback on what was wrong; on a second failure, analyze that dimension inline (Step 1) and say so.

**If `invoke_subagent` is NOT available** (IDE): run all 7 dimensions inline yourself (proceed to Step 1).

> Detection is automatic. Never ask the user which mode to use.

**Subagent types:** `research` = lightweight read-only (preferred for analysis); `self` = heavyweight clone — avoid for file-generation or large prompts. See `.agents/skills/using-quantis/references/antigravity-tools.md`.

## 1. Load Context
Read target file + SPEC.md + ROADMAP.md + DECISIONS.md.

## 1.5 Determine Review Mode
- Target filename matches `*PLAN.md` → **plan mode**
- Anything else (including the default `.quantis/SPEC.md`) → **spec mode**

**In spec mode**, apply the 7 dimensions in Step 3 as written.

**In plan mode**, reinterpret each dimension for the plan (compare it against the spec it implements):
1. **Completeness** — Does every spec requirement map to at least one task? Does every task have a real test and a `Run:`/`Expected:` verification step?
2. **Consistency** — Do types, function/method signatures, and names match across tasks? Does the plan contradict the spec or itself?
3. **Feasibility** — Are the steps actually executable as written? Do referenced files/commands exist or get created earlier in the plan?
4. **Edge Cases** — Are error paths, empty/boundary inputs, and failure handling specified rather than "add error handling"?
5. **Security** — Does the plan introduce unvalidated input, secrets in code, or authorization gaps?
6. **Performance** — Will the planned approach scale, or does it bake in an obvious bottleneck?
7. **Maintainability** — No placeholders (TBD/TODO/"implement later"); each task self-contained; decisions documented.

Flag any dimension violation as a finding in Step 4 using the same severity scale.

## 2. Set Critique Mindset
Your job is to BREAK the spec, not validate it. Assume everything is wrong until proven otherwise. This framework is self-contained — no methodology skill to load.

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

Write the full findings report to disk before continuing — `$PHASE_DIR/STRESS-TEST.md` for a phase target, else `.quantis/STRESS-TEST.md`. **Gate:** `test -f` the report before continuing; findings that exist only in chat are lost at session end.

For each finding:
```markdown
### [SEVERITY] Finding Title
**Dimension:** {which of the 7}
**Problem:** {what's wrong}
**Impact:** {what happens if unfixed}
**Suggestion:** {how to fix}
```

Severity: `🔴 Critical` | `🟠 High` | `🟡 Medium` | `🔵 Low` (canonical Quantis scale for spec/plan findings; code review uses its own Critical/Important/Minor)

## 5. Update Spec (mandatory when findings exist)
Add unresolved questions to SPEC.md's `## Unresolved Questions` section.
Document decisions in `.quantis/DECISIONS.md` using the canonical `D-{NNN}` format (see `.quantis/templates/decisions.md`; `NNN` = next integer after the highest existing `D-` ID).
After recording unresolved questions, stamp `Stress-tested: {date}` on its own line under the spec's status header. If any 🔴 Critical finding is unresolved, STOP — fix it before `/wf-plan`.

## 6. Offer Next Steps
Edit `.quantis/STATE.md` IN PLACE (canonical schema in `.quantis/templates/state.md`) — set:
```markdown
## Current Position
- **Phase**: {N} ({name})
- **Task**: Stress test complete — {X} findings ({critical} critical)
- **Status**: Reviewed, ready to plan

## Next Steps
1. Fix critical findings, then /wf-plan {N}
```

Commit the report alongside state — `git add` the STRESS-TEST.md path (from Step 4) plus `.quantis/STATE.md`, `.quantis/SPEC.md`, and `.quantis/DECISIONS.md`, then commit.

</process>

<offer_next>
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► STRESS TEST COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{X} findings: {critical} 🔴  {high} 🟠  {medium} 🟡  {low} 🔵

▶ Spec mode: fix critical issues, then /wf-plan {N}
▶ Plan mode: fix critical issues in PLAN.md, then /wf-execute {N}
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `dispatching-parallel-agents` | Per-dimension parallel fan-out when `invoke_subagent` is available |
</related>
