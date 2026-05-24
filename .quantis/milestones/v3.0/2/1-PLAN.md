---
phase: 2
plan: 1
wave: 1
---

# Plan 2.1: Workflows, Aliases & Bootstrap Files

## Objective
Copy all 29 workflows into `quantis-new/.agent/workflows/`, rewrite the 7 superseded ones as thin aliases that invoke skills, and add all bootstrap/root-level files (.gemini/, adapters/, PROJECT_RULES.md, etc.).

## Context
- .quantis/ROADMAP.md (Phase 2 deliverables)
- .quantis/DECISIONS.md (D-025 through D-030)
- .agent/workflows/ (all 29 current workflows)
- adapters/ (4 adapter files)
- .gemini/GEMINI.md (current bootstrap)
- PROJECT_RULES.md, QUANTIS-STYLE.md, model_capabilities.yaml

## Tasks

<task type="auto">
  <name>Copy all 29 workflows into quantis-new</name>
  <files>
    quantis-new/.agent/workflows/ (create)
  </files>
  <action>
    1. Create `quantis-new/.agent/workflows/` directory
    2. Copy ALL 29 workflow files from `.agent/workflows/` to `quantis-new/.agent/workflows/`
    3. Verify all 29 files copied:
       add-phase.md, add-todo.md, audit-milestone.md, check-todos.md,
       complete-milestone.md, debug.md, discuss-phase.md, execute.md,
       help.md, insert-phase.md, install.md, list-phase-assumptions.md,
       map.md, new-milestone.md, new-project.md, pause.md,
       plan-milestone-gaps.md, plan.md, progress.md, remove-phase.md,
       research-phase.md, resume.md, sprint.md, stress-test.md,
       update-plan.md, update.md, verify.md, web-search.md, whats-new.md
  </action>
  <verify>ls quantis-new/.agent/workflows/ | wc -l  # Should be 29</verify>
  <done>29 workflow files exist in quantis-new/.agent/workflows/</done>
</task>

<task type="auto">
  <name>Rewrite 7 superseded workflows as thin skill aliases</name>
  <files>
    quantis-new/.agent/workflows/plan.md (rewrite)
    quantis-new/.agent/workflows/execute.md (rewrite)
    quantis-new/.agent/workflows/discuss-phase.md (rewrite)
    quantis-new/.agent/workflows/stress-test.md (rewrite)
    quantis-new/.agent/workflows/research-phase.md (rewrite)
    quantis-new/.agent/workflows/update-plan.md (rewrite)
    quantis-new/.agent/workflows/map.md (rewrite)
  </files>
  <action>
    Replace each of the 7 superseded workflow files with a thin alias (~15-20 lines) that:
    1. Keeps the YAML frontmatter with the same description (for discoverability)
    2. States this is a skill alias
    3. Instructs the agent to read and follow the corresponding skill SKILL.md
    4. Passes through $ARGUMENTS to the skill

    Mapping:
    - plan.md → "Read and follow `.agents/skills/writing-plans/SKILL.md`. Pass phase number from $ARGUMENTS. Output plans to `.quantis/phases/{N}/`."
    - execute.md → "Read and follow `.agents/skills/executing-plans/SKILL.md`. Pass phase number from $ARGUMENTS. Read plans from `.quantis/phases/{N}/`."
    - discuss-phase.md → "Read and follow `.agents/skills/brainstorming/SKILL.md`. Use 'discuss' mode. Pass phase number from $ARGUMENTS."
    - stress-test.md → "Read and follow `.agents/skills/brainstorming/SKILL.md`. Use 'adversarial critique' mode. Focus on finding ambiguity, contradictions, and gaps in the spec/plan."
    - research-phase.md → "Read and follow `.agents/skills/brainstorming/SKILL.md`. Use 'research/explore' mode. Pass phase number from $ARGUMENTS."
    - update-plan.md → "Read and follow `.agents/skills/writing-plans/SKILL.md`. Use 'revision' mode. Read existing plans from `.quantis/phases/{N}/` and revise based on user feedback."
    - map.md → "Read and follow `.agents/skills/codebase-mapper/SKILL.md`. Output ARCHITECTURE.md and STACK.md to `.quantis/`."

    Each alias MUST:
    - Be self-contained (no dependency on the old workflow logic)
    - Mention the Quantis state update convention (update STATE.md after completion)
    - Keep the original workflow description in frontmatter for slash command discoverability
  </action>
  <verify>
    # Each alias should be under 30 lines
    for f in plan.md execute.md discuss-phase.md stress-test.md research-phase.md update-plan.md map.md; do
      echo "$f: $(wc -l < quantis-new/.agent/workflows/$f) lines"
    done
  </verify>
  <done>7 alias files exist, each under 30 lines, each referencing the correct skill SKILL.md path</done>
</task>

<task type="auto">
  <name>Add bootstrap and root-level files to quantis-new</name>
  <files>
    quantis-new/.gemini/GEMINI.md (create)
    quantis-new/adapters/ANTIGRAVITY.md (create)
    quantis-new/adapters/GEMINI.md (create)
    quantis-new/adapters/CLAUDE.md (create)
    quantis-new/adapters/GPT_OSS.md (create)
    quantis-new/PROJECT_RULES.md (copy)
    quantis-new/QUANTIS-STYLE.md (copy)
    quantis-new/model_capabilities.yaml (copy)
    quantis-new/CONSTITUTION.md (copy from template)
    quantis-new/.quantis/templates/ (copy directory)
  </files>
  <action>
    **1. Create thin .gemini/GEMINI.md** (~25 lines):
    - State that this project uses Quantis methodology
    - Point to using-quantis skill as the primary reference
    - Quick 5-line summary of core principles
    - Link to adapters/ for model-specific tips
    - Link to PROJECT_RULES.md for canonical rules
    - Do NOT duplicate tool mapping (that's in skills now)

    **2. Create slimmed adapters/** — Copy from existing adapters/ but:
    - ANTIGRAVITY.md: Remove the "Tool Mapping" table (now in antigravity-tools.md skill reference). Keep: browser_subagent guide, file operations tips, context optimization, planning mode note, commit workflow, anti-patterns. Update all cross-references to point to quantis-new file locations.
    - GEMINI.md: Keep as-is (model-specific tips only, no overlap with skills)
    - CLAUDE.md: Keep as-is (model-specific tips only)
    - GPT_OSS.md: Keep as-is (model-specific tips only)

    **3. Copy root-level files:**
    - `cp PROJECT_RULES.md quantis-new/PROJECT_RULES.md`
    - `cp QUANTIS-STYLE.md quantis-new/QUANTIS-STYLE.md`
    - `cp model_capabilities.yaml quantis-new/model_capabilities.yaml`
    - `cp .quantis/templates/constitution.md quantis-new/CONSTITUTION.md` (the blank template — users customize via /new-project)

    **4. Copy .quantis/templates/ directory:**
    - `cp -r .quantis/templates/ quantis-new/.quantis/templates/`
    - These templates are used by /new-project to create SPEC.md, CONSTITUTION.md, etc.
    - All 25 template files must be copied
  </action>
  <verify>
    ls quantis-new/.gemini/GEMINI.md quantis-new/adapters/ quantis-new/PROJECT_RULES.md quantis-new/QUANTIS-STYLE.md quantis-new/model_capabilities.yaml quantis-new/CONSTITUTION.md
    ls quantis-new/.quantis/templates/ | wc -l  # Should be 25
    # All should exist
    wc -l quantis-new/.gemini/GEMINI.md  # Should be ~25 lines (thin bootstrap)
    grep -c "Tool Mapping" quantis-new/adapters/ANTIGRAVITY.md  # Should be 0 (removed)
  </verify>
  <done>.gemini/GEMINI.md exists as thin bootstrap (~25 lines), 4 adapter files exist, 4 root-level files copied, CONSTITUTION.md template included, 25 templates copied. ANTIGRAVITY.md has no duplicate tool mapping table.</done>
</task>

## Success Criteria
- [ ] 29 workflow files in quantis-new/.agent/workflows/
- [ ] 7 alias workflows under 30 lines each, referencing correct skills
- [ ] .gemini/GEMINI.md is a thin bootstrap pointing to using-quantis skill
- [ ] adapters/ has 4 files with no duplicate tool mapping
- [ ] PROJECT_RULES.md, QUANTIS-STYLE.md, model_capabilities.yaml, CONSTITUTION.md copied
- [ ] .quantis/templates/ directory with 25 templates copied
