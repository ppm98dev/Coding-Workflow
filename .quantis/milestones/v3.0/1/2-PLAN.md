---
phase: 1
plan: 2
wave: 1
---

# Plan 1.2: Bootstrap Skill & Tool Mapping

## Objective
Create the `using-quantis` bootstrap skill (adapted from `using-superpowers`), the `antigravity-tools.md` reference file, and rename the skill directory.

## Context
- quantis-new/.agents/skills/using-superpowers/SKILL.md (source to adapt)
- quantis-new/.agents/skills/using-superpowers/references/gemini-tools.md (pattern to follow)
- .quantis/DECISIONS.md (D-018: auto-triggering, D-023: tool mapping, D-024: naming)

## Tasks

<task type="auto">
  <name>Create antigravity-tools.md reference</name>
  <files>
    quantis-new/.agents/skills/using-quantis/references/antigravity-tools.md (create)
  </files>
  <action>
    Create the tool mapping file following the exact pattern from `gemini-tools.md` but for Antigravity 2.0.

    The file must include:
    1. Core tool mapping table (Superpowers → Antigravity):
       - Read → view_file
       - Write → write_to_file
       - Edit → replace_file_content / multi_replace_file_content
       - Bash → run_command
       - Grep → grep_search
       - Glob → list_dir
       - TodoWrite → (manual tracking via STATE.md)
       - Skill → view_file on SKILL.md (progressive disclosure)
       - Task (subagent) → invoke_subagent
       - WebSearch → search_web
       - WebFetch → read_url_content

    2. Subagent support section:
       - invoke_subagent: spawn isolated coding subagents
       - define_subagent: register named subagent types (implementer, spec-reviewer, code-quality-reviewer)
       - manage_subagents: list/kill active subagents
       - send_message: inter-agent communication
       - Built-in types: research, browser, self

    3. Antigravity-exclusive tools section:
       - browser_subagent: sandboxed web browser
       - generate_image: image generation
       - schedule: timed operations
       - call_mcp_tool: MCP integrations

    4. Prompt filling instructions (same as gemini-tools.md pattern)

    5. File location override note:
       "Quantis uses `.quantis/phases/{N}/` for specs and plans. When skills reference
        `docs/superpowers/specs/` or `docs/superpowers/plans/`, use the Quantis convention instead."
  </action>
  <verify>cat quantis-new/.agents/skills/using-quantis/references/antigravity-tools.md | head -5</verify>
  <done>antigravity-tools.md exists with complete tool mapping table, subagent section, and file location override note</done>
</task>

<task type="auto">
  <name>Create using-quantis bootstrap skill</name>
  <files>
    quantis-new/.agents/skills/using-quantis/SKILL.md (create)
  </files>
  <action>
    Adapt `using-superpowers/SKILL.md` to create `using-quantis/SKILL.md`:

    1. YAML frontmatter:
       - name: using-quantis
       - description: "Use when starting any conversation - establishes how to find and use skills, requiring Skill invocation before ANY response including clarifying questions"

    2. Keep the auto-triggering behavior (D-018):
       - The "1% chance = invoke the skill" rule
       - The Red Flags table
       - Skill Priority section
       - Skill Types (Rigid vs Flexible)

    3. Change "How to Access Skills" section for Antigravity:
       - Skills are auto-discovered from `.agents/skills/*/SKILL.md`
       - Agent reads SKILL.md via `view_file` when task matches description
       - Reference `antigravity-tools.md` for tool mapping

    4. Add Quantis-specific sections:
       - "State Management": Load `.quantis/STATE.md` at session start for context
       - "File Conventions": Specs → `.quantis/phases/{N}/SPEC.md`, Plans → `.quantis/phases/{N}/PLAN.md`
       - "Workflow Commands": Reference that `/pause`, `/resume`, `/progress` etc. are available as slash commands

    5. Replace all "superpowers" references with "quantis"
    6. Remove Claude Code, Gemini CLI, Codex, Copilot CLI references (Antigravity only)
    7. Remove the SUBAGENT-STOP gate (not needed in Antigravity's model)
  </action>
  <verify>grep -c "quantis" quantis-new/.agents/skills/using-quantis/SKILL.md  # Should find multiple references</verify>
  <done>using-quantis/SKILL.md exists with Antigravity-native instructions, auto-triggering behavior, and Quantis state management</done>
</task>

<task type="auto">
  <name>Remove old using-superpowers directory</name>
  <files>
    quantis-new/.agents/skills/using-superpowers/ (delete)
  </files>
  <action>
    Delete the `using-superpowers/` skill directory since it's been replaced by `using-quantis/`.

    Verify no other skills reference `using-superpowers` by name (they should reference
    tool mapping from the references/ directory instead).

    Check: grep -r "using-superpowers" quantis-new/.agents/skills/
    If any references found, update them to "using-quantis".
  </action>
  <verify>test ! -d quantis-new/.agents/skills/using-superpowers && echo "Removed"</verify>
  <done>using-superpowers/ deleted, all references updated to using-quantis</done>
</task>

## Success Criteria
- [ ] quantis-new/.agents/skills/using-quantis/SKILL.md exists with Antigravity-native content
- [ ] quantis-new/.agents/skills/using-quantis/references/antigravity-tools.md exists with full tool mapping
- [ ] using-superpowers/ directory deleted
- [ ] No remaining references to "using-superpowers" in any skill
- [ ] Skills directory count: 18 (14 Superpowers - using-superpowers + using-quantis + 4 Quantis)
