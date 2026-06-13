---
name: wf-discuss-phase
description: Discuss a phase before planning (clarify scope and approach)
argument-hint: "<phase-number>"
---

# /discuss-phase → brainstorming skill

> **Skill-powered workflow.** Ideation methodology is powered by `brainstorming`. This workflow adds Quantis phase context and decision documentation.

<context>
**Phase:** $ARGUMENTS (optional — defaults to next unplanned phase; "next unplanned phase" is defined in `wf-plan/SKILL.md` Step 2 — lowest ⬜/🔄 phase in the current milestone with no `*-PLAN.md`. Confirm with the user.)

**Required files:**
- `.quantis/ROADMAP.md` — Phase objectives and deliverables
- `.quantis/DECISIONS.md` — Decisions already made
- `.quantis/SPEC.md` — Requirements for reference
</context>

<process>

## 0. Platform Check

**If `invoke_subagent` is available** (CLI `agy`, Standalone): **you MUST dispatch a `research` subagent for context gathering — do not explore the codebase inline.** The subagent prompt MUST contain, **given as PATHS to read** (the subagent reads each into its own clean context window — do NOT paste file contents; pasting is what overloads a subagent):
1. The phase number and the phase's complete text copied from `.quantis/ROADMAP.md`.
2. Any `.quantis/DECISIONS.md` entries that mention this phase.
3. The task: "Explore the codebase (file structure, recent commits, relevant code) and gather dependencies and constraints for this phase."

**Required return format:** a structured context brief — Relevant files, Recent commits, Dependencies, Constraints, Open questions.

When the subagent returns, **continue at Step 1** using its brief to inform the brainstorming discussion.

**If `invoke_subagent` is NOT available** (IDE): gather context yourself inline (proceed to Step 1).

**If the dispatch fails or returns an unusable brief:** re-dispatch once with feedback; on a second failure, gather context inline and note the fallback.

> Detection is automatic. Never ask the user which mode to use.

**Subagent types** (`.agents/skills/using-quantis/references/antigravity-tools.md`): `research` = read-only codebase navigation/exploration.

## 1. Load Phase Context
Read phase definition from ROADMAP.md (or use subagent brief from Step 0). Extract:
- Phase objective
- Deliverables
- Dependencies on prior phases
- Known constraints

## 2. Brainstorm
**Read and follow `.agents/skills/brainstorming/SKILL.md`, checklist items 1–8 in full** — including writing the spec to the phase directory and the user review gate. **Override:** do NOT execute item 9 (invoking writing-plans); this workflow ends at Step 4 below, suggesting `/plan {N}`.

Present structured discussion points:
- **Scope**: What's in, what's out?
- **Concerns**: What could go wrong?
- **Dependencies**: What must exist before this works?
- **Risks**: What's the biggest unknown?
- **Alternatives**: Is there a simpler way?

## 3. Document Decisions
Record outcomes in `.quantis/DECISIONS.md` using the canonical `D-{NNN}` format (see `.quantis/templates/decisions.md`; `NNN` = next integer after the highest existing `D-` ID):
```markdown
### D-{NNN}: {Decision Title}
**Decision:** {what was decided}
**Rationale:** {why}
```

## 4. Update State + Next Steps
Edit `.quantis/STATE.md` IN PLACE (canonical schema in `.quantis/templates/state.md`) — set:
```markdown
## Current Position
- **Phase**: {N} ({name})
- **Task**: Discussion complete — {X} decisions recorded
- **Status**: Discussed, ready to plan

## Next Steps
1. /plan {N}
```
Then suggest `/plan {N}` or `/stress-test`.

**Gate:** `test -f "$PHASE_DIR/SPEC.md"` — if SPEC.md was not created during brainstorming, the discussion is incomplete. Do not display the completion banner.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► PHASE {N} DISCUSSED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Spec: $PHASE_DIR/SPEC.md ✓
▶ /stress-test {N} — adversarial spec review (recommended)
▶ /plan {N} — create execution plans
```

</process>

<offer_next>
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Quantis ► DISCUSSION COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
{X} decisions documented

▶ /plan {N} — create execution plans
▶ /stress-test — adversarial review (optional)
```
</offer_next>

<related>
### Skills
| Skill | Purpose |
|-------|---------|
| `brainstorming` | Ideation methodology (delegated) |
</related>
