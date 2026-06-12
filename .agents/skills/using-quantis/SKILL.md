---
name: using-quantis
description: Use when starting any conversation - establishes how to find and use skills, requiring skill reading before ANY response including clarifying questions
---

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST read and follow the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU MUST USE IT — unless the user has explicitly told you not to (see the Instruction Priority section below; the user always takes precedence).

This is not optional. You cannot rationalize your way out of it on your own judgment — only an explicit user instruction overrides a skill.
</EXTREMELY-IMPORTANT>

## Instruction Priority

Quantis skills override default system prompt behavior, but **user instructions always take precedence**:

1. **User's explicit instructions** (direct requests, project-specific rules) — highest priority
2. **Quantis skills** — override default system behavior where they conflict
3. **Default system prompt** — lowest priority

If the user says "don't use TDD" and a skill says "always use TDD," follow the user's instructions. The user is in control.

## How to Access Skills

**All Antigravity platforms:** Skills and workflows are auto-discovered from `.agents/skills/*/SKILL.md`. The agent loads skill metadata (name and description from YAML frontmatter) at session start with zero context cost. When a task matches a skill's description, read the full SKILL.md via `view_file` to activate it.

**On CLI (`agy`)**, workflow commands use the `/wf-` prefix (e.g., `/wf-plan 1`). Methodology skills work the same everywhere.

**Platform Adaptation:** Skills use Claude Code tool names as reference. See `references/antigravity-tools.md` for the Antigravity 2.0 tool mapping.

# Using Skills

## The Rule

**Read and follow relevant skills BEFORE any response or action.** Even a 1% chance a skill might apply means you should read the skill to check. If a skill turns out to be wrong for the situation, you don't need to follow it.

```
Flow:
  User message received
    → Might any skill apply? (even 1%)
      → YES: Read SKILL.md via view_file
        → Announce: "Using [skill] to [purpose]"
        → Follow skill exactly
      → DEFINITELY NOT: Respond directly
```

## Red Flags

These thoughts mean STOP — you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Read it. |

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, debugging) — these determine HOW to approach the task
2. **Implementation skills second** — these guide execution

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → systematic-debugging first, then domain-specific skills.

## Skill Types

**Rigid** (TDD, debugging, verification): Follow exactly. Don't adapt away discipline.

**Flexible** (patterns, brainstorming): Adapt principles to context — but required output artifacts (e.g. brainstorming's SPEC.md) are never skippable; 'flexible' applies to dialogue style, not deliverables.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.

## State Management

Quantis tracks state across sessions. At session start:

1. **Read `.quantis/STATE.md`** — understand current position (milestone, phase, task)
2. **Check `.quantis/ROADMAP.md`** — understand what's been done and what's next
3. **Check `.quantis/DECISIONS.md`** — understand decisions already made

After completing significant work:
1. **Update STATE.md** — current position and progress
2. **Add to JOURNAL.md** — session summary
3. **Update ROADMAP.md** — check off deliverables

## Workflow Commands

These slash commands are available. Some invoke Superpowers skills for enhanced quality:

| Command | Purpose | Skill Used |
|---------|---------|------------|
| `/plan {N}` | Create phase execution plans | writing-plans |
| `/execute {N}` | Execute phase plans | subagent-driven-development (auto: real subagents or inline; executing-plans only standalone) |
| `/map` | Analyze codebase structure | codebase-mapper |
| `/discuss-phase {N}` | Brainstorm before planning | brainstorming |
| `/stress-test` | Adversarial spec/plan review | — (self-contained 7-dimension framework) |
| `/research-phase {N}` | Deep technical research | brainstorming (research) |
| `/update-plan {N}` | Revise plans | writing-plans (revision) |
| `/debug-issue` | Systematic debugging | systematic-debugging |
| `/verify {N}` | Validate work against spec | verification-before-completion |
| `/new-project` | Initialize project | brainstorming |
| `/pause` | Dump context for session handoff | — |
| `/resume-session` | Restore context from previous | — |
| `/progress` | Show roadmap position | — |
| `/quantis-help` | Show all commands | — |

> **CLI users (`agy`):** Prefix workflow commands with `/wf-`. Example: `/wf-plan 1` instead of `/plan 1`. Skill commands (like `/brainstorming`) work without prefix.

## File Conventions

| What | Location |
|------|----------|
| Project spec (Planning Lock) | `.quantis/SPEC.md` |
| Phase design spec | `.quantis/phases/{N}.{M}-{slug}/SPEC.md` |
| Plans | `.quantis/phases/{N}.{M}-{slug}/{N}.{M}-PLAN.md` |
| State | `.quantis/STATE.md` |
| Journal | `.quantis/JOURNAL.md` |
| Decisions | `.quantis/DECISIONS.md` |
| Roadmap | `.quantis/ROADMAP.md` |
| Constitution | `.agents/rules/CONSTITUTION.md` |
