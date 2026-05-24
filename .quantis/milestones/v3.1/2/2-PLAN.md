---
phase: 2
plan: 2
wave: 2
---

# Plan 2.2: Rewire Kept Workflows & Update Bootstrap

## Objective
Update the 22 kept workflows to reference new skills where relevant, update /help with accurate command listing, and update the using-quantis bootstrap skill's workflow commands table.

## Context
- .quantis/DECISIONS.md (D-026, D-027, D-028)
- quantis-new/.agent/workflows/ (all 29 workflows from Plan 2.1)
- quantis-new/.agents/skills/using-quantis/SKILL.md (bootstrap to update)
- quantis-new/.agents/skills/ (18 skills for reference)

## Tasks

<task type="auto">
  <name>Rewire /debug, /verify, /new-project workflows</name>
  <files>
    quantis-new/.agent/workflows/debug.md (edit)
    quantis-new/.agent/workflows/verify.md (edit)
    quantis-new/.agent/workflows/new-project.md (edit)
  </files>
  <action>
    These 3 workflows are NOT aliases — they keep their own process logic but need to invoke skills at key points:

    **debug.md:**
    - Find the section where debugging methodology is defined
    - Add instruction: "Before starting debugging, read `.agents/skills/systematic-debugging/SKILL.md` and follow its methodology"
    - Keep the workflow's own state-dump and fresh-context-restart logic
    - Keep the Quantis banner and state update conventions

    **verify.md:**
    - Find the section where verification steps are defined
    - Add instruction: "Before starting verification, read `.agents/skills/verification-before-completion/SKILL.md` and follow its methodology"
    - Keep the workflow's VERIFICATION.md output and must-have checking logic
    - Keep the Quantis banner and state update conventions

    **new-project.md:**
    - Find the design/brainstorming phase section
    - Add instruction: "For the design thinking phase, read `.agents/skills/brainstorming/SKILL.md` and follow its structured ideation process"
    - Keep the workflow's own project initialization logic (creating .quantis/, SPEC.md, etc.)

    DO NOT convert these to thin aliases. They have unique Quantis process logic that skills don't replace. The skills enhance the methodology at specific points within the workflow.
  </action>
  <verify>
    grep -l "systematic-debugging/SKILL.md" quantis-new/.agent/workflows/debug.md
    grep -l "verification-before-completion/SKILL.md" quantis-new/.agent/workflows/verify.md
    grep -l "brainstorming/SKILL.md" quantis-new/.agent/workflows/new-project.md
    # All 3 should match
  </verify>
  <done>debug.md references systematic-debugging skill, verify.md references verification-before-completion skill, new-project.md references brainstorming skill</done>
</task>

<task type="auto">
  <name>Update /help workflow with accurate v3.0 command listing</name>
  <files>
    quantis-new/.agent/workflows/help.md (edit)
  </files>
  <action>
    Rewrite the command listing in help.md to reflect v3.0:

    **Skill-Powered Commands (aliases → skills):**
    | Command | Skill Invoked | Purpose |
    |---------|--------------|---------|
    | /plan {N} | writing-plans | Create execution plans for a phase |
    | /execute {N} | executing-plans | Execute plans for a phase |
    | /discuss-phase {N} | brainstorming | Discuss a phase before planning |
    | /stress-test | brainstorming (critique) | Adversarial spec/plan review |
    | /research-phase {N} | brainstorming (research) | Deep technical research |
    | /update-plan {N} | writing-plans (revision) | Revise plans based on feedback |
    | /map | codebase-mapper | Analyze codebase structure |

    **Skill-Enhanced Commands (workflow + skill):**
    | Command | Skill Used | Purpose |
    |---------|-----------|---------|
    | /debug | systematic-debugging | Systematic debugging with state |
    | /verify {N} | verification-before-completion | Validate work against spec |
    | /new-project | brainstorming | Initialize project with design phase |

    **Process Commands (workflow only — no skill):**
    | Command | Purpose |
    |---------|---------|
    | /pause | Dump context for session handoff |
    | /resume | Restore context from previous session |
    | /progress | Show roadmap position and next steps |
    | /new-milestone | Create a new milestone with phases |
    | /complete-milestone | Mark milestone complete and archive |
    | /audit-milestone | Audit milestone for quality |
    | /plan-milestone-gaps | Plan to address audit gaps |
    | /add-phase | Add phase to end of roadmap |
    | /insert-phase | Insert phase between existing phases |
    | /remove-phase | Remove a phase (with safety checks) |
    | /list-phase-assumptions | List assumptions from planning |
    | /add-todo | Capture a todo item |
    | /check-todos | List pending todos |
    | /sprint | Time-boxed focused work session |
    | /web-search | Search web for information |
    | /whats-new | Show recent Quantis changes |
    | /install | Install Quantis into a project |
    | /update | Update Quantis to latest version |
    | /help | Show this command listing |

    Keep the workflow's banner formatting and structure.
  </action>
  <verify>
    grep -c "writing-plans\|executing-plans\|brainstorming\|codebase-mapper\|systematic-debugging\|verification-before-completion" quantis-new/.agent/workflows/help.md
    # Should be >= 10 (skills mentioned in the help listing)
  </verify>
  <done>help.md lists all commands in 3 categories (skill-powered, skill-enhanced, process-only) with skill names</done>
</task>

<task type="auto">
  <name>Update using-quantis bootstrap skill workflow commands table</name>
  <files>
    quantis-new/.agents/skills/using-quantis/SKILL.md (edit)
  </files>
  <action>
    Update the "Workflow Commands" table (around line 102-112) in using-quantis/SKILL.md:

    Replace the current table with a comprehensive v3.0 version:

    ```markdown
    ## Workflow Commands

    These slash commands are available. Some invoke Superpowers skills for enhanced quality:

    | Command | Purpose | Skill Used |
    |---------|---------|------------|
    | `/plan {N}` | Create phase execution plans | writing-plans |
    | `/execute {N}` | Execute phase plans | executing-plans |
    | `/map` | Analyze codebase structure | codebase-mapper |
    | `/discuss-phase {N}` | Brainstorm before planning | brainstorming |
    | `/debug` | Systematic debugging | systematic-debugging |
    | `/verify {N}` | Validate work against spec | verification-before-completion |
    | `/pause` | Dump context for session handoff | — |
    | `/resume` | Restore context from previous | — |
    | `/progress` | Show roadmap position | — |
    | `/help` | Show all commands | — |
    ```

    Also update any references to old skill names (planner, executor, verifier, etc.) if any remain.
  </action>
  <verify>
    grep "writing-plans\|executing-plans\|codebase-mapper\|brainstorming\|systematic-debugging\|verification-before-completion" quantis-new/.agents/skills/using-quantis/SKILL.md | wc -l
    # Should be >= 6 (each skill mentioned at least once)
  </verify>
  <done>using-quantis/SKILL.md has updated workflow commands table with skill references, no stale skill names</done>
</task>

## Success Criteria
- [ ] /debug references systematic-debugging skill
- [ ] /verify references verification-before-completion skill
- [ ] /new-project references brainstorming skill
- [ ] /help lists all commands in 3 categories with skill names
- [ ] using-quantis/SKILL.md has accurate v3.0 workflow commands table
- [ ] No references to old skill names (planner, executor, verifier, debugger, plan-checker, empirical-validation)
