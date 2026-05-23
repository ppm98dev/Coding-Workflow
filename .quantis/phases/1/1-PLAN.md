---
phase: 1
plan: 1
wave: 1
---

# Plan 1.1: Clone & Restructure Superpowers into quantis-new/

## Objective
Create the `quantis-new/` directory with Superpowers as the foundation, restructured to Antigravity's native `.agents/skills/` layout. Remove all Superpowers platform-specific files (Claude, Cursor, Codex, Gemini configs, hooks, etc.).

## Context
- .quantis/ROADMAP.md (Phase 1 deliverables)
- .quantis/DECISIONS.md (D-015 through D-019)
- `/tmp/superpowers-audit/` (already cloned Superpowers v5.1.0)

## Tasks

<task type="auto">
  <name>Create quantis-new/ and copy Superpowers skills</name>
  <files>
    quantis-new/.agents/skills/ (create)
  </files>
  <action>
    1. Create `quantis-new/` at the repo root
    2. Create `quantis-new/.agents/skills/` directory
    3. Copy all 14 skill directories from `/tmp/superpowers-audit/skills/` into `quantis-new/.agents/skills/`
    4. Verify all 14 skills copied correctly:
       - brainstorming
       - dispatching-parallel-agents
       - executing-plans
       - finishing-a-development-branch
       - receiving-code-review
       - requesting-code-review
       - subagent-driven-development
       - systematic-debugging
       - test-driven-development
       - using-git-worktrees
       - using-superpowers (will be renamed in Plan 1.2)
       - verification-before-completion
       - writing-plans
       - writing-skills
  </action>
  <verify>ls quantis-new/.agents/skills/ | wc -l  # Should be 14</verify>
  <done>14 skill directories exist in quantis-new/.agents/skills/</done>
</task>

<task type="auto">
  <name>Remove Superpowers platform-specific files</name>
  <files>
    quantis-new/ (cleanup)
  </files>
  <action>
    Remove all files/directories that are specific to Superpowers' multi-platform plugin system. These are NOT needed since we're Antigravity-native:

    DELETE these directories (if they were copied):
    - .claude-plugin/     (Claude Code plugin config)
    - .codex-plugin/      (Codex plugin config)
    - .cursor-plugin/     (Cursor plugin config)
    - .opencode/          (OpenCode config)
    - hooks/              (Claude Code session hooks)
    - assets/             (Superpowers branding)
    - tests/              (Superpowers test suite)
    - scripts/            (Superpowers build scripts)
    - .github/            (Superpowers CI/CD)
    - docs/               (Superpowers docs)

    DELETE these files:
    - CLAUDE.md           (Claude Code project instructions)
    - GEMINI.md           (Gemini CLI instructions)
    - AGENTS.md           (Generic agent instructions)
    - gemini-extension.json
    - package.json
    - .version-bump.json
    - .gitattributes
    - CODE_OF_CONDUCT.md
    - RELEASE-NOTES.md
    - README.md           (will be replaced with Quantis README)
    - LICENSE             (will be replaced with Quantis LICENSE)

    DO NOT delete:
    - .agents/skills/     (the skills we just copied!)
  </action>
  <verify>ls quantis-new/ && ls quantis-new/.agents/skills/ | wc -l  # Should show only .agents/ dir and 14 skills</verify>
  <done>quantis-new/ contains only .agents/skills/ with 14 skill directories, no Superpowers platform files</done>
</task>

<task type="auto">
  <name>Copy Quantis context skills (keep from old system)</name>
  <files>
    quantis-new/.agents/skills/context-compressor/ (create)
    quantis-new/.agents/skills/context-health-monitor/ (create)
    quantis-new/.agents/skills/token-budget/ (create)
    quantis-new/.agents/skills/codebase-mapper/ (create)
  </files>
  <action>
    Copy 4 Quantis-original skills from `.agents/skills/` into `quantis-new/.agents/skills/`:
    - context-compressor
    - context-health-monitor
    - token-budget
    - codebase-mapper

    These provide context management that Superpowers lacks. Do NOT copy the skills being replaced:
    - planner (replaced by writing-plans)
    - executor (replaced by subagent-driven-development)
    - verifier (replaced by verification-before-completion)
    - empirical-validation (replaced by verification-before-completion)
    - debugger (replaced by systematic-debugging)
    - plan-checker (replaced by writing-plans self-review)
    - context-fetch (not needed)
  </action>
  <verify>ls quantis-new/.agents/skills/ | wc -l  # Should be 18 (14 Superpowers + 4 Quantis)</verify>
  <done>18 skill directories in quantis-new/.agents/skills/ — 14 from Superpowers + 4 from Quantis</done>
</task>

## Success Criteria
- [ ] quantis-new/.agents/skills/ contains exactly 18 skill directories
- [ ] No Superpowers platform files remain (no CLAUDE.md, hooks/, etc.)
- [ ] All 14 Superpowers skills have their SKILL.md intact
- [ ] All 4 Quantis context skills preserved
