---
name: wf-plan-milestone-gaps
description: Create plans to address gaps found in milestone audit
---

# /wf-plan-milestone-gaps Workflow

<objective>
Create targeted plans to address gaps, technical debt, and issues identified during milestone audit.
</objective>

<process>

## 1. Load Gap Information

Read from:
- Latest AUDIT.md or VERIFICATION.md
- TODO.md for deferred items
- DECISIONS.md for acknowledged debt

---

## 2. Categorize Gaps

| Category | Priority | Action |
|----------|----------|--------|
| Must-have failures | 🔴 High | Create fix phase |
| Technical debt | 🟡 Medium | Add to roadmap |
| Nice-to-have misses | 🟢 Low | Add to backlog |

---

## 3. Create Gap Closure Phase

Add new phase to ROADMAP.md:

```markdown
### Phase {N}: Gap Closure
**Status**: ⬜ Not Started
**Objective**: Address gaps from milestone audit

**Gaps to Close:**
- [ ] {gap 1}
- [ ] {gap 2}
```

---

## 4. Create PLAN.md for Each Gap

Resolve the gap-closure phase directory (`.quantis/phases/{N}-gap-closure/`, `mkdir -p` if absent). Write one plan per gap inside it, named `{N}-gap-{issue-slug}-PLAN.md` — the `-PLAN.md` suffix is REQUIRED (`/wf-execute {N} --gaps-only` discovers gap plans by it). Each plan uses the **checkbox** task format from `writing-plans` (`### Task N` with `- [ ]` steps and `Run:`/`Expected:` verification — never XML):

```markdown
---
phase: {N}
plan: gap-{issue-slug}
wave: 1
gap_closure: true
---

# Fix: {Gap Description}

## Problem
{What the audit found}

## Root Cause
{Why it exists}

### Task 1: Fix {issue}
- [ ] {specific fix step in `{files}`}
- [ ] Run: `{original verification command that failed}`
      Expected: `{passing output}`
```

`gap_closure: true` is REQUIRED (the `--gaps-only` filter keys on it); `wave: 1` so all gap plans run together.

---

## 5. Update STATE.md

**Edit the existing canonical fields in place — do NOT replace the file or add a new section.** Update `## Current Position` and refresh `## Next Steps`; preserve every other section (`Last Session Summary`, `Blockers`, `Context Dump`) that `/wf-resume-session` reads.
```markdown
## Current Position
- **Phase**: {N} (gap closure)
- **Status**: planning — addressing {N} gaps from milestone audit
```

---

## 6. Commit Plans

```bash
git add .quantis/phases/{N}-gap-closure/ .quantis/ROADMAP.md .quantis/STATE.md
git commit -m "docs(phase-{N}): create gap closure plans"
```
After committing, confirm success (`git log -1` shows the new commit). On failure, follow the Commit Failure Rule in `.agents/rules/PROJECT_RULES.md` — never bypass with `--no-verify`.

---

## 7. Offer Execution

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► GAP CLOSURE PLANS CREATED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Gaps identified: {N}
Plans created: {M}

───────────────────────────────────────────────────────

▶ NEXT

/wf-execute {N} --gaps-only — Execute gap closure plans

───────────────────────────────────────────────────────
```

</process>
