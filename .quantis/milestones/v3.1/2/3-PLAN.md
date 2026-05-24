---
phase: 2
plan: 3
wave: 2
---

# Plan 2.3: State Integration Hooks & Cross-Reference Cleanup

## Objective
Add state-update hooks to the SDD and executing-plans skills so they auto-update STATE.md, JOURNAL.md, and ROADMAP.md during execution. Clean up any stale cross-references across all workflows and skills.

## Context
- .quantis/DECISIONS.md (D-020 — state integration)
- quantis-new/.agents/skills/subagent-driven-development/SKILL.md
- quantis-new/.agents/skills/executing-plans/SKILL.md
- quantis-new/.agent/workflows/ (all 29 workflows)

## Tasks

<task type="auto">
  <name>Add state-update hooks to SDD and executing-plans skills</name>
  <files>
    quantis-new/.agents/skills/subagent-driven-development/SKILL.md (edit)
    quantis-new/.agents/skills/executing-plans/SKILL.md (edit)
  </files>
  <action>
    These two skills handle code execution. Per D-020, they must auto-update Quantis state files.

    **For both skills, add a "State Integration" section** (after the main process section):

    ```markdown
    ## Quantis State Integration

    After completing each task/checkpoint, update Quantis state:

    **STATE.md** — Update current position:
    ```markdown
    - **Phase**: {N}
    - **Task**: {current task name}
    - **Status**: In progress / Complete
    ```

    **JOURNAL.md** — Append session entry after completing all tasks:
    ```markdown
    ## Session: {date}
    ### Accomplished
    - ✅ {task 1 name}
    - ✅ {task 2 name}
    ```

    **ROADMAP.md** — Check off deliverables as they're completed:
    ```markdown
    - [x] {deliverable that was just completed}
    ```
    ```

    **For subagent-driven-development/SKILL.md specifically:**
    - Add state update after each SDD cycle (spec → implement → review → iterate)
    - Add instruction to update STATE.md with the current implementation stage

    **For executing-plans/SKILL.md specifically:**
    - Add state update after each task within a plan
    - Add instruction to update ROADMAP.md deliverables after plan completion

    Keep the skills' existing logic intact. The state hooks are ADDITIONS, not replacements.
  </action>
  <verify>
    grep -c "STATE.md\|JOURNAL.md\|ROADMAP.md" quantis-new/.agents/skills/subagent-driven-development/SKILL.md
    # Should be >= 3 (each file referenced at least once)
    grep -c "STATE.md\|JOURNAL.md\|ROADMAP.md" quantis-new/.agents/skills/executing-plans/SKILL.md
    # Should be >= 3
  </verify>
  <done>Both skills have "Quantis State Integration" section referencing STATE.md, JOURNAL.md, and ROADMAP.md</done>
</task>

<task type="auto">
  <name>Clean stale cross-references across all workflows and skills</name>
  <files>
    quantis-new/.agent/workflows/ (all files — scan and fix)
    quantis-new/.agents/skills/ (all files — scan and fix)
  </files>
  <action>
    Search for and fix stale references across the entire quantis-new directory:

    **1. Old skill names** — Search and replace:
    ```bash
    grep -rn "planner\|executor\|verifier\|empirical-validation\|plan-checker\|context-fetch" quantis-new/.agent/workflows/
    ```
    Replace with the new skill names:
    - "planner" → "writing-plans"
    - "executor" → "executing-plans"
    - "verifier" → "verification-before-completion"
    - "empirical-validation" → "verification-before-completion"
    - "plan-checker" → "writing-plans" (self-review)
    - "debugger" → "systematic-debugging"
    - "context-fetch" → remove (not needed)

    **2. Old file paths** — Search and replace:
    ```bash
    grep -rn "\.agents/skills/planner\|\.agents/skills/executor\|\.agents/skills/verifier\|\.agents/skills/debugger\|\.agents/skills/plan-checker\|\.agents/skills/empirical-validation" quantis-new/
    ```

    **3. GSD/Superpowers remnants** — Search and clean:
    ```bash
    grep -rn "superpowers\|get-shit-done\|gsd-build" quantis-new/ --include="*.md" --include="*.yaml"
    ```
    - Replace "superpowers" → "Quantis" (except in Superpowers credit/attribution lines)
    - Replace GSD URLs → Quantis repo URL (if applicable)
    - Keep attribution: "Based on obra/superpowers" is fine

    **4. Stale workflow cross-references** — In kept workflows, check that:
    - `/plan` references still work (now alias → writing-plans)
    - `/execute` references still work (now alias → executing-plans)
    - No workflows reference deleted skills

    DO NOT modify the meaning of any workflow or skill. Only fix broken references.
  </action>
  <verify>
    # No stale old skill names (excluding legitimate references like "planner role" in prose)
    grep -rn "skills/planner\|skills/executor\|skills/verifier\|skills/debugger\b\|skills/plan-checker\|skills/empirical-validation\|skills/context-fetch" quantis-new/
    # Should return 0 results

    # No superpowers file paths
    grep -rn "superpowers/" quantis-new/ --include="*.md" | grep -v "github.com/obra/superpowers" | grep -v "Based on"
    # Should return 0 results (only attribution lines remain)
  </verify>
  <done>Zero stale skill paths. Zero superpowers file paths (only attribution). All cross-references point to valid v3.0 locations.</done>
</task>

## Success Criteria
- [ ] SDD skill has Quantis State Integration section
- [ ] executing-plans skill has Quantis State Integration section
- [ ] Both reference STATE.md, JOURNAL.md, ROADMAP.md
- [ ] Zero stale old skill paths in quantis-new/
- [ ] Zero non-attribution superpowers references
- [ ] All workflow cross-references point to valid v3.0 files
