---
phase: 2
plan: 2
wave: 1
---

# Plan 2.2: Strip PowerShell from All Workflows

## Objective
Remove all PowerShell code blocks from the 13 workflows that contain them. This is the bulk operation (~774 lines removed across 13 files).

## Context
- .quantis/ROADMAP.md (revised Phase 2 scope)
- .agent/workflows/ (13 affected files)

## Tasks

<task type="auto">
  <name>Strip PowerShell blocks from all 13 workflows</name>
  <files>.agent/workflows/complete-milestone.md, .agent/workflows/debug.md, .agent/workflows/execute.md, .agent/workflows/help.md, .agent/workflows/insert-phase.md, .agent/workflows/install.md, .agent/workflows/map.md, .agent/workflows/new-milestone.md, .agent/workflows/new-project.md, .agent/workflows/plan.md, .agent/workflows/remove-phase.md, .agent/workflows/sprint.md, .agent/workflows/update.md</files>
  <action>
    For each of the 13 workflow files, remove all PowerShell code blocks. The pattern to remove is:

    ```
    **PowerShell:**
    ```powershell
    {any lines of PowerShell code}
    ```
    ```

    Rules:
    - Remove the "**PowerShell:**" label AND the fenced powershell code block
    - Keep ALL Bash code blocks and their "**Bash:**" labels
    - Remove the "**Bash:**" label too if it was only there to distinguish from PowerShell — the code block stands alone now
    - Preserve all other content (descriptions, headers, tables, XML tags, etc.)
    - Clean up any double blank lines left after removal (max 1 blank line between sections)
    - Verify each file still reads naturally after removal

    Process all 13 files. This is mechanical but requires care to not accidentally remove Bash blocks.
  </action>
  <verify>grep -l "PowerShell:" .agent/workflows/*.md 2>/dev/null | wc -l | xargs -I{} echo "Workflows with PS remaining: {}" && echo "Expected: 0"</verify>
  <done>Zero workflows contain PowerShell references. All 13 files cleaned. All Bash blocks preserved.</done>
</task>

<task type="auto">
  <name>Verify all workflows still pass validation</name>
  <files>scripts/validate-workflows.sh</files>
  <action>
    Run the workflow validator to ensure no structural damage:
    ```bash
    bash scripts/validate-workflows.sh
    ```
    All 27 workflows must still pass. If any fail, fix the specific file before proceeding.
  </action>
  <verify>bash scripts/validate-workflows.sh 2>&1 | tail -5</verify>
  <done>validate-workflows.sh reports "All workflows valid!" with 0 errors.</done>
</task>

## Success Criteria
- [ ] Zero PowerShell references in any workflow file
- [ ] All 27 workflows pass validate-workflows.sh
- [ ] All Bash content preserved across all files
- [ ] No double blank lines or formatting artifacts
