---
phase: 2
plan: 1
wave: 1
---

# Plan 2.1: Delete PowerShell Scripts + Strip PS from Skills

## Objective
Remove all 6 PowerShell script files and strip PowerShell code blocks from 5 skills. This is the smaller batch (11 files) and can run in parallel with Plan 2.2.

## Context
- .quantis/ROADMAP.md (revised Phase 2 scope)
- .quantis/DECISIONS.md (ADR-008: Remove PowerShell)

## Tasks

<task type="auto">
  <name>Delete all .ps1 script files</name>
  <files>scripts/search_repo.ps1, scripts/setup_search.ps1, scripts/validate-all.ps1, scripts/validate-skills.ps1, scripts/validate-templates.ps1, scripts/validate-workflows.ps1</files>
  <action>
    Delete all 6 PowerShell script files:
    ```bash
    rm scripts/search_repo.ps1 scripts/setup_search.ps1 scripts/validate-all.ps1 scripts/validate-skills.ps1 scripts/validate-templates.ps1 scripts/validate-workflows.ps1
    ```
    The Bash equivalents (.sh) remain and are the sole scripts.
  </action>
  <verify>ls scripts/*.ps1 2>/dev/null | wc -l | grep -q "0" && echo "PASS: No .ps1 files remain" || echo "FAIL"</verify>
  <done>Zero .ps1 files exist in scripts/ directory. Only .sh files remain.</done>
</task>

<task type="auto">
  <name>Strip PowerShell blocks from 5 skills</name>
  <files>.agents/skills/codebase-mapper/SKILL.md, .agents/skills/context-fetch/SKILL.md, .agents/skills/empirical-validation/SKILL.md, .agents/skills/executor/SKILL.md, .agents/skills/verifier/SKILL.md</files>
  <action>
    For each of the 5 skills listed, remove all PowerShell code blocks. The pattern to remove is:

    ```
    **PowerShell:**
    ```powershell
    {any content}
    ```
    ```

    Also remove standalone PowerShell references like "**PowerShell:**" headers with no following Bash equivalent.

    Rules:
    - Remove the "**PowerShell:**" label AND the fenced code block
    - Keep ALL Bash code blocks and their labels
    - If a section has both PowerShell and Bash, remove only PowerShell, keep Bash
    - Remove the "**Bash:**" label too if it was only there to distinguish from PowerShell (the code block stands alone now)
    - Keep all non-code content (descriptions, tables, etc.)
    - Verify each file still reads naturally after removal
  </action>
  <verify>grep -l "PowerShell:\|powershell" .agents/skills/*/SKILL.md 2>/dev/null | wc -l | xargs -I{} echo "Skills with PS remaining: {}" && echo "Expected: 0"</verify>
  <done>Zero skills contain PowerShell references. All Bash blocks preserved. Files read naturally.</done>
</task>

## Success Criteria
- [ ] Zero .ps1 files in scripts/ directory
- [ ] Zero PowerShell references in any skill SKILL.md
- [ ] All Bash content preserved
- [ ] All skill files still valid (pass validate-skills.sh)
