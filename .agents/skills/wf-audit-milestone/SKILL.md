---
name: wf-audit-milestone
description: Audit a milestone for quality and completeness
argument-hint: "[milestone-name]"
---

# /wf-audit-milestone Workflow

<objective>
Review a completed (or in-progress) milestone for quality, completeness, and lessons learned.
</objective>

<process>

## 0. Platform Check

**If `invoke_subagent` is available** (CLI `agy`, Standalone): **you MUST dispatch** — do not do this work inline. Dispatch a `research` subagent (read-only: it loads the milestone archive, every phase's VERIFICATION.md, TODO.md, and DECISIONS.md, and re-checks must-have evidence — a large read volume that should not pollute the orchestrator). The subagent prompt MUST contain, **given as PATHS to read** (the subagent reads each into its own clean context window — do NOT paste file contents; pasting is what overloads a subagent):
- The milestone name (or "current milestone from ROADMAP.md" if none given).
- The exact files to read and analyze: the milestone archive directory under `.quantis/milestones/{name}/` (or `.quantis/ROADMAP.md` for the current milestone), each phase's `VERIFICATION.md`, `.quantis/TODO.md`, and `.quantis/DECISIONS.md`.
- The four analysis tasks from Steps 2-4 below: re-check each must-have's empirical evidence (still valid? regressions?), review deferred/technical-debt items, and analyze per-phase quality (gap closures, recurring issues).
- The audit-report markdown structure from Step 5 (paste it as the required output template).
**Required return format:** a completed audit report following the Step 5 markdown structure, with empirical evidence references per must-have.
When the subagent returns, **continue at Step 5** (review its report for evidence quality, then run Step 6 yourself).

**If `invoke_subagent` is NOT available** (IDE): proceed inline from Step 1.

**If a dispatch fails or returns unusable output** (missing report, empty sections, non-empirical evidence): re-dispatch once with explicit feedback on what was wrong; on a second failure, fall back to the inline procedure and say so.

> Detection is automatic. Never ask the user which mode to use.

**Subagent types** (`.agents/skills/using-quantis/references/antigravity-tools.md`): `research` = read-only codebase navigation/exploration.

---

## 1. Load Milestone Context

If milestone name provided, load from archive:
If no name, audit current milestone from ROADMAP.md.

---

## 2. Check Must-Haves Verification

For each must-have in the milestone:
- Was it verified with empirical evidence?
- Is the evidence still valid?
- Any regressions since completion?

---

## 3. Review Technical Debt

Check TODO.md and DECISIONS.md for:
- Deferred items during this milestone
- Technical debt acknowledged
- Items that should be addressed

---

## 4. Analyze Phase Quality

For each phase:
- Review VERIFICATION.md
- Check for gap closures (were there many?)
- Note recurring issues

---

## 5. Generate Audit Report

```markdown
# Milestone Audit: {name}

**Audited:** {date}

## Summary
| Metric | Value |
|--------|-------|
| Phases | {N} |
| Gap closures | {M} |
| Technical debt items | {K} |

## Must-Haves Status
| Requirement | Verified | Evidence |
|-------------|----------|----------|
| {req 1} | ✅ | {link} |
| {req 2} | ✅ | {link} |

## Concerns
- {concern 1}
- {concern 2}

## Recommendations
1. {recommendation 1}
2. {recommendation 2}

## Technical Debt to Address
- [ ] {item 1}
- [ ] {item 2}
```

---

## 6. Offer Actions

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► AUDIT COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Milestone: {name}
Health: {GOOD | CONCERNS | NEEDS ATTENTION}

───────────────────────────────────────────────────────

▶ ACTIONS

/wf-plan-milestone-gaps — Create plans to address gaps
/wf-add-todo — Capture debt items for later

───────────────────────────────────────────────────────
```

</process>
