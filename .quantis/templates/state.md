# State Template

Template for `.quantis/STATE.md` — project memory across sessions.

---

## File Template

```markdown
## Current Position
- **Phase**: {current phase number and name}
- **Task**: {specific task in progress, if any}
- **Status**: {planning | executing | verifying | blocked | paused at {timestamp}}

## Last Session Summary
{What was accomplished this session}

## In-Progress Work
{Any uncommitted changes or partial work}
- Files modified: {list}
- Tests status: {passing/failing/not run}

## Blockers
{What was preventing progress, if anything — "None" if clear}

## Context Dump
{Critical context that would be lost}:

### Decisions Made
- {Decision 1}: {rationale}  (full records live in DECISIONS.md; reference D-{NNN} IDs here if relevant)

### Approaches Tried
- {Approach 1}: {outcome}

### Current Hypothesis
{Best guess at solution/issue}

### Files of Interest
- `{file1}`: {what's relevant}

## Next Steps
1. {Specific first action for next session}
2. {Second priority}
3. {Third priority}
```

> **Canonical schema.** This is the same schema `/pause` writes and `/resume-session` reads. Every other writer (wf-verify, wf-new-milestone, context-health-monitor, SDD/executing-plans auto-save) edits these fields IN PLACE — never replaces the file or invents a new layout. Decisions are NOT stored here; they live in `.quantis/DECISIONS.md`.

---

## Update Rules

**Update STATE.md after:**
- Every completed task
- Every decision made
- Any blocker identified
- Session end/pause

**What to update (edit these fields in place — never replace the file):**
- Current Position (Phase / Task / Status)
- Last Session Summary
- Next Steps

**Keep it lean:**
- STATE.md is read frequently
- Only current context, not history
- History goes in JOURNAL.md

---

## Resume Protocol

When starting a new session:

1. Read STATE.md first
2. Understand current position
3. Check blockers/concerns
4. Continue from Next Steps

The STATE.md is the "save game" for the project.
