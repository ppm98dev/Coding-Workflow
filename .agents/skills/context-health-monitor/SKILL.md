---
name: context-health-monitor
description: Monitors context complexity and triggers state dumps before quality degrades
---

# Context Health Monitor

## Purpose

Prevent "Context Rot" — the quality degradation that occurs as the agent processes more information in a single session.

## When This Skill Activates

The agent MUST self-monitor for these warning signs, and MUST take the listed Action the moment a threshold is hit — these are not suggestions:

### Warning Signs

| Signal | Threshold | Action |
|--------|-----------|--------|
| Repeated debugging | 3+ failed attempts | Trigger state dump |
| Going in circles | Same approach tried twice | Stop and reassess |
| Confusion indicators | "I'm not sure", backtracking | Document uncertainty |
| Session length | Extended back-and-forth | Recommend `/pause` |
| Context volume high | 10+ files read in full, 20+ tool calls, or re-reading files you already summarized | Compress first (Rule 4), pause only if that's not enough |

## Behavior Rules

### Rule 1: The 3-Strike Rule

If debugging the same issue fails 3 times:

1. **Auto-save state** — Document in `.quantis/STATE.md`: what was tried, what errors occurred, current hypothesis
2. **Assess the pattern:**
   - If failures suggest an architectural problem (same area, same class of error) → **discuss with user** before attempting more fixes (see systematic-debugging Phase 4 → "question the architecture", step 5)
   - Otherwise → **recommend `/pause`** for a fresh session with fresh context
3. **Do NOT** continue with attempt #4 without either user discussion or fresh session

> **Cross-reference:** systematic-debugging § Phase 4 "question the architecture" (step 5), wf-execute § context_hygiene (/pause recommendation). This protocol supersedes both when they conflict.

### Rule 2: Circular Detection

If the same approach is being tried again:

1. **Acknowledge** the repetition
2. **List** what has already been tried
3. **Propose** a fundamentally different approach
4. **Or** recommend `/pause` for fresh perspective

### Rule 3: Uncertainty Logging

When uncertain about an approach:

1. **State** the uncertainty clearly
2. **Document** in `.quantis/DECISIONS.md` using the canonical `D-{NNN}` format (see `.quantis/templates/decisions.md`; `NNN` = next integer after the highest existing `D-` ID):
   - **Decision:** the uncertain decision
   - **Rationale:** why it's uncertain + alternatives considered
3. **Ask** user for guidance rather than guessing

### Rule 4: Context Volume → Compress Before Pausing

When the "Context volume high" signal fires (or context feels heavy before any hard limit), do this BEFORE recommending `/pause`:

1. **Read and follow `.agents/skills/context-compressor/SKILL.md`** — compress already-understood files to summaries, keeping pointers so they can be re-fetched on demand.
2. **Apply `.agents/skills/token-budget/SKILL.md`** loading discipline — search before load, sections over whole files, never reload material you already summarized.
3. Only if compression is not enough → auto-save state and recommend `/pause` (Rules 1–3 above).

Compression is the in-session response to context pressure; `/pause` is the last resort, not the first.

## State Dump Format

When triggered, edit `.quantis/STATE.md` IN PLACE — update the Phase/Task/Status fields in the existing `## Current Position` section and record the detail under `## Context Dump` (canonical schema in `.quantis/templates/state.md`; never replace the file or add a competing top-level section):

```markdown
## Context Dump → Context Health

**Triggered**: [date/time]
**Reason**: [3 failures / circular / uncertainty]

### What Was Attempted
1. [Approach 1] — Result: [outcome]
2. [Approach 2] — Result: [outcome]
3. [Approach 3] — Result: [outcome]

### Current Hypothesis
[Best guess at root cause]

### Recommended Next Steps
1. [Fresh perspective action]
2. [Alternative approach to try]

### Files Involved
- [file1.ext] — [what state it's in]
- [file2.ext] — [what state it's in]
```

## Auto-Save Protocol

**Critical:** When any warning signal triggers, the agent must save state BEFORE recommending `/pause` to the user. This ensures state persists even if the session hard-terminates.

### Steps

1. **Write** a state snapshot to `.quantis/STATE.md` immediately when a threshold is hit — edit the canonical `## Current Position` fields in place (schema in `.quantis/templates/state.md`); do not overwrite other sections
2. **Include** at minimum: current phase, current task, last action, next step
3. **Then** inform the user of the situation and recommend `/pause`

### Why

Sessions can terminate abruptly (usage limits, context limits, network errors). If the agent waits for the user to type `/pause`, it may never get the chance. By saving first and recommending second, state is always preserved.

## Integration

This skill integrates with:
- `/pause` — Triggers proper session handoff (includes proactive auto-save)
- `/resume-session` — Loads the state dump context
- `context-compressor` — invoked by Rule 4 to compress understood context in-session
- `token-budget` — loading discipline applied (Rule 4) when context volume is high
- `.agents/rules/PROJECT_RULES.md` § Context Management — Context Hygiene rules
