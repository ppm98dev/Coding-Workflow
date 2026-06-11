---
name: _wf-discuss-phase
description: Discuss a phase before planning (clarify scope and approach)
argument-hint: "<phase-number>"
---

# /discuss-phase → brainstorming skill

> **Skill-powered workflow.** Ideation methodology is powered by `brainstorming`. This workflow adds Quantis phase context and decision documentation.

<context>
**Phase:** $ARGUMENTS (optional — defaults to next unplanned phase)

**Required files:**
- `.quantis/ROADMAP.md` — Phase objectives and deliverables
- `.quantis/DECISIONS.md` — Decisions already made
- `.quantis/SPEC.md` — Requirements for reference
</context>

<process>

## 0. Platform Check

**If `invoke_subagent` is available**, dispatch a `research` subagent to:
- Explore the codebase (file structure, recent commits, relevant code)
- Read the phase definition from ROADMAP.md
- Gather context about dependencies and constraints
- Return a structured context brief

Then use the returned brief to inform the brainstorming discussion with the user.

**If `invoke_subagent` is NOT available**, gather context yourself inline (proceed to Step 1).

## 1. Load Phase Context
Read phase definition from ROADMAP.md (or use subagent brief from Step 0). Extract:
- Phase objective
- Deliverables
- Dependencies on prior phases
- Known constraints

## 2. Brainstorm
**Read and follow `.agents/skills/brainstorming/SKILL.md`** in discuss/explore mode.

Present structured discussion points:
- **Scope**: What's in, what's out?
- **Concerns**: What could go wrong?
- **Dependencies**: What must exist before this works?
- **Risks**: What's the biggest unknown?
- **Alternatives**: Is there a simpler way?

## 3. Document Decisions
Record outcomes in `.quantis/DECISIONS.md` using format:
```markdown
### D-{NNN}: {Decision Title}
**Decision:** {what was decided}
**Rationale:** {why}
```

## 4. Update State + Next Steps
Update STATE.md. Suggest `/plan {N}` or `/stress-test`.

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
