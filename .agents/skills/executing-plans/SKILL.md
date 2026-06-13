---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load plan, review critically, execute all tasks, report when complete.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

**Note:** If the `invoke_subagent` tool is in your session's tool list (CLI `agy`, Standalone — not the IDE), use subagent-driven-development instead. If `/execute` routed you here, that check already failed — proceed with this skill and do not ask the user about execution modes.

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns: Track progress in STATE.md and proceed

### Step 2: Execute Tasks

**REQUIRED SUB-SKILL:** Read and follow `.agents/skills/test-driven-development/SKILL.md` before writing any code — RED (failing test) → GREEN (make it pass) → REFACTOR. This gives the standalone/separate-session path the same discipline as subagent-driven-development.

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

> **When invoked from `/execute`:** Skip this step. `/execute` owns phase-level completion. Only run finishing-a-development-branch when executing-plans is invoked standalone.

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent

## Integration

**Required workflow skills:**
- **using-git-worktrees** - Ensures isolated workspace (creates one or verifies existing)
- **writing-plans** - Creates the plan this skill executes
- **finishing-a-development-branch** - Complete development after all tasks

## Quantis State Integration

After completing each task, update Quantis state files:

1. **STATE.md** — Update current position in place (edit the fields inside the existing `## Current Position` section; canonical schema in `.quantis/templates/state.md` — never replace the file):
   ```markdown
   - **Phase**: {N}
   - **Task**: {current task name}
   - **Status**: In progress / Complete
   ```

2. **JOURNAL.md** — After completing all tasks, insert ONE session entry at the TOP of JOURNAL.md (newest-first; template: `.quantis/templates/journal.md`):
   ```markdown
   ## Session: {date}
   ### Accomplished
   - ✅ {task 1 name}
   - ✅ {task 2 name}
   ```

3. **ROADMAP.md** — Check off deliverables as they're completed:
   ```markdown
   - [x] {deliverable that was just completed}
   ```

This ensures session persistence across `/pause` and `/resume-session` cycles.
