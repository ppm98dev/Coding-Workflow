---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
---

# Requesting Code Review

Dispatch a code reviewer subagent to catch issues before they cascade. The reviewer gets precisely crafted context for evaluation — never your session's history. This keeps the reviewer focused on the work product, not your thought process, and preserves your own context for continued work.

**Core principle:** Review early, review often.

## When to Request Review

**Mandatory:**
- After each task in subagent-driven development
- After completing major feature
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing complex bug

## How to Request

**1. Get git SHAs:**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

**2. Run the review:**

**If `invoke_subagent` is available** (CLI `agy`, Standalone): dispatch a `self` code reviewer subagent with the prompt template at `code-reviewer.md`, filled. The subagent does NOT inherit your context — paste the diff (or the BASE_SHA..HEAD_SHA range with instruction to run `git diff` itself) and the filled placeholders into the prompt.

**If `invoke_subagent` is NOT available** (IDE): the review is still Mandatory — do NOT skip it. Read `code-reviewer.md` yourself and apply its criteria to the diff file-by-file, producing the same findings format (Strengths / Critical / Important / Minor / Assessment). Note that it was a self-review.

**Subagent types** (`.agents/skills/using-quantis/references/antigravity-tools.md`): `self` = clone of the calling agent with the same capabilities.

**Placeholders:**
- `{DESCRIPTION}` - Brief summary of what you built
- `{PLAN_OR_REQUIREMENTS}` - What it should do
- `{BASE_SHA}` - Starting commit
- `{HEAD_SHA}` - Ending commit

**3. Act on feedback:**
- Fix Critical issues immediately
- Fix Important issues before proceeding
- After fixing Critical/Important issues, re-dispatch the reviewer on the new HEAD_SHA. Repeat until no Critical/Important issues remain — do not merge in between.
- Note Minor issues for later
- Push back if reviewer is wrong (with reasoning)

## Example

```
[Just completed Task 2: Add verification function]

You: Let me request code review before proceeding.

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)
# Guard: if BASE_SHA is empty or does not resolve, do NOT dispatch.
# Fall back to `git merge-base HEAD origin/main` or the plan's first commit
# recorded in STATE.md, and confirm both with `git cat-file -t $SHA`.

[Dispatch code reviewer subagent]
  DESCRIPTION: Added verifyIndex() and repairIndex() with 4 issue types
  PLAN_OR_REQUIREMENTS: Task 2 from .quantis/phases/{N}.{M}-{slug}/{N}.{M}-PLAN.md
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661

[Subagent returns]:
  Strengths: Clean architecture, real tests
  Issues:
    Important: Missing progress indicators
    Minor: Magic number (100) for reporting interval
  Assessment: Ready to proceed

You: [Fix progress indicators]
[Continue to Task 3]
```

## Integration with Workflows

**Subagent-Driven Development:**
- Review after EACH task
- Catch issues before they compound
- Fix before moving to next task

**Executing Plans:**
- Review after each task or at natural checkpoints
- Get feedback, apply, continue

**Ad-Hoc Development:**
- Review before merge
- Review when stuck

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical issues
- Proceed with unfixed Important issues
- Argue with valid technical feedback

**If reviewer wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
- Request clarification

See template at: requesting-code-review/code-reviewer.md
