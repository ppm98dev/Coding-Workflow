---
phase: 1
plan: 3
wave: 2
---

# Plan 1.3: Adapt All Skills for Antigravity 2.0

## Objective
Update all 17 remaining Superpowers skills to use Antigravity 2.0 tool names, file locations, and subagent patterns. This is the core adaptation work.

## Context
- quantis-new/.agents/skills/using-quantis/references/antigravity-tools.md (tool mapping, created in Plan 1.2)
- .quantis/DECISIONS.md (D-016: subagent architecture, D-019: file locations, D-020: state integration)

## Tasks

<task type="auto">
  <name>Adapt subagent-driven-development for invoke_subagent</name>
  <files>
    quantis-new/.agents/skills/subagent-driven-development/SKILL.md (modify)
    quantis-new/.agents/skills/subagent-driven-development/implementer-prompt.md (modify)
    quantis-new/.agents/skills/subagent-driven-development/spec-reviewer-prompt.md (modify)
    quantis-new/.agents/skills/subagent-driven-development/code-quality-reviewer-prompt.md (modify)
  </files>
  <action>
    This is the MOST CRITICAL adaptation. SDD relies heavily on subagents.

    In SKILL.md:
    1. Replace all "Task tool" references with `invoke_subagent`
    2. Add a "Session Setup" section at the top:
       ```
       At session start, define named subagent types:
       - define_subagent("implementer", ...)
       - define_subagent("spec-reviewer", ...)
       - define_subagent("code-quality-reviewer", ...)
       ```
    3. Replace "TodoWrite" with manual STATE.md tracking
    4. Update the example workflow to use Antigravity tool names
    5. In "Integration" section, replace "superpowers:" skill references with just the skill name
    6. Replace all "superpowers:" prefixes throughout (e.g., "superpowers:test-driven-development" → "test-driven-development")

    In prompt templates (implementer-prompt.md, spec-reviewer-prompt.md, code-quality-reviewer-prompt.md):
    1. Replace "Task tool (general-purpose)" with "invoke_subagent"
    2. Replace "Work from: [directory]" with "Workspace: [workspace path]"
    3. Keep all the prompt content intact — the instructions, review criteria, and output formats are excellent

    ADD STATE INTEGRATION (D-020):
    After "Mark task complete" step in the SDD flow, add:
    ```
    After marking task complete, update Quantis state:
    - STATE.md: Update current task progress
    - JOURNAL.md: Add entry with task summary + files changed
    - ROADMAP.md: Check off deliverable if applicable
    ```
  </action>
  <verify>grep -c "invoke_subagent" quantis-new/.agents/skills/subagent-driven-development/SKILL.md  # Should find multiple</verify>
  <done>SDD skill uses invoke_subagent, has define_subagent setup, state integration hooks, and no "superpowers:" references</done>
</task>

<task type="auto">
  <name>Adapt all remaining skills — tool names and references</name>
  <files>
    quantis-new/.agents/skills/*/SKILL.md (modify — 12 skills)
  </files>
  <action>
    For EACH of these 12 skills, apply the following changes:

    **Skills to update:** brainstorming, writing-plans, executing-plans, systematic-debugging,
    test-driven-development, verification-before-completion, using-git-worktrees,
    finishing-a-development-branch, requesting-code-review, receiving-code-review,
    dispatching-parallel-agents, writing-skills

    **Global search-and-replace across ALL skills:**
    1. "superpowers:" → "" (remove prefix from skill cross-references)
       Example: "superpowers:test-driven-development" → "test-driven-development"
    2. "Task tool" → "invoke_subagent" (where referring to subagent dispatch)
    3. "TodoWrite" → "STATE.md task tracking" (or remove — Antigravity has no TodoWrite equivalent)
    4. "EnterWorktree" → "invoke_subagent with Workspace option" (in using-git-worktrees)

    **Per-skill adjustments:**

    brainstorming/SKILL.md:
    - Change default spec save location: `docs/superpowers/specs/` → `.quantis/phases/{N}/SPEC.md`
    - Change "Invoke writing-plans skill" → "Invoke writing-plans skill" (just remove "superpowers:" prefix)
    - Keep the visual companion section but note it uses `browser_subagent` in Antigravity

    writing-plans/SKILL.md:
    - Change default plan save location: `docs/superpowers/plans/` → `.quantis/phases/{N}/PLAN.md`
    - Change execution handoff: reference `subagent-driven-development` and `executing-plans` (without prefix)

    executing-plans/SKILL.md:
    - Remove "Tell your human partner that Superpowers works much better with access to subagents" — Antigravity always has subagents
    - Update skill cross-references

    systematic-debugging/SKILL.md:
    - Update "npm test" references to be generic ("Run project test suite")
    - Update skill cross-references

    test-driven-development/SKILL.md:
    - Keep almost entirely as-is — it's tool-agnostic
    - Only update "npm test" to generic form and cross-references

    using-git-worktrees/SKILL.md:
    - Remove "EnterWorktree" native tool references
    - Antigravity can use invoke_subagent with Workspace option for isolation
    - Keep git worktree fallback as primary (Antigravity doesn't have a native worktree tool)

    finishing-a-development-branch/SKILL.md:
    - Keep as-is mostly — it's git commands
    - Update cross-references only

    requesting-code-review/SKILL.md, receiving-code-review/SKILL.md:
    - Update "Task tool" references
    - Update cross-references

    dispatching-parallel-agents/SKILL.md:
    - Update to use invoke_subagent parallel dispatch
    - Note Antigravity supports parallel subagent invocation natively

    writing-skills/SKILL.md:
    - Update personal skills directory reference: "~/.claude/skills" → "~/.gemini/antigravity/skills/"
    - Update cross-references
    - Keep everything else (the TDD-for-docs methodology is tool-agnostic)

    DO NOT change:
    - Any anti-rationalization tables
    - Any red flags lists
    - Any flowcharts (content is tool-agnostic)
    - Any code examples (they illustrate patterns, not tool usage)
  </action>
  <verify>grep -r "superpowers:" quantis-new/.agents/skills/ --include="*.md" | grep -v "obra/superpowers" | wc -l  # Should be 0 (no remaining superpowers: prefixes except URL references)</verify>
  <done>All 12 skills updated: no "superpowers:" prefixes, correct tool references, correct file locations</done>
</task>

## Success Criteria
- [ ] Zero "superpowers:" skill prefix references (except URL citations to the repo)
- [ ] SDD uses invoke_subagent + define_subagent
- [ ] SDD has state integration hooks (STATE.md, JOURNAL.md, ROADMAP.md)
- [ ] brainstorming saves specs to `.quantis/phases/{N}/SPEC.md`
- [ ] writing-plans saves plans to `.quantis/phases/{N}/PLAN.md`
- [ ] All skills reference other skills by name without prefix
- [ ] writing-skills references `~/.gemini/antigravity/skills/` for personal skills
