---
phase: 1
plan: 3
wave: 2
depends_on: [1]
---

# Plan 1.3: Patch Workflows with Antigravity Tool References

## Objective
Modify `execute.md` and `verify.md` workflows to natively reference Antigravity tools (per ADR-004: deep adapter + workflow patches). This makes GSD feel Antigravity-native rather than requiring users to manually cross-reference the adapter.

## Context
- .gsd/SPEC.md
- .gsd/DECISIONS.md (ADR-004: workflow patches, ADR-005: GSD replaces planning mode)
- adapters/ANTIGRAVITY.md (created in Plan 1.1 — must exist before this plan)
- .agent/workflows/execute.md (current file)
- .agent/workflows/verify.md (current file)

## Tasks

<task type="auto">
  <name>Patch verify.md with browser_subagent guidance</name>
  <files>.agent/workflows/verify.md</files>
  <action>
    Add Antigravity-specific verification methods to verify.md. This is the highest-impact patch because browser_subagent is the most powerful verification tool available.

    Changes:
    1. In section "3a. Determine Verification Method" (the evidence types table around line 66-73), ADD new rows:
       | UI (Antigravity) | browser_subagent | Screenshot + WebP recording |
       | Visual regression | browser_subagent | Side-by-side screenshot comparison |

    2. AFTER section "3b. Execute Verification" (around line 83), ADD a new subsection:
       ```markdown
       ### 3b-alt. Antigravity Visual Verification

       When running in Antigravity, use `browser_subagent` for UI verification:
       - Navigate to the target URL
       - Capture screenshots as evidence
       - All sessions auto-recorded as WebP video artifacts
       - Use for any must-have that involves visual output

       **Note:** This is optional. Traditional command-line verification still works.
       Antigravity adapter details: see adapters/ANTIGRAVITY.md
       ```

    3. In the "Required Evidence" table (around line 238-244), ADD:
       | "UI works" (Antigravity) | browser_subagent screenshot + recording |

    Do NOT remove any existing content. Only ADD new Antigravity-specific options alongside existing ones.
  </action>
  <verify>grep -c "browser_subagent\|Antigravity" .agent/workflows/verify.md</verify>
  <done>verify.md mentions browser_subagent at least 3 times and references adapters/ANTIGRAVITY.md. All existing content preserved.</done>
</task>

<task type="auto">
  <name>Patch execute.md with Antigravity tool references</name>
  <files>.agent/workflows/execute.md</files>
  <action>
    Add Antigravity-specific execution guidance to execute.md.

    Changes:
    1. Find the section about file operations / task execution. ADD a note after the first code block in the execution section:
       ```markdown
       > **Antigravity:** Use native tools (`write_to_file`, `replace_file_content`, `multi_replace_file_content`) instead of shell `echo >` or `cat >` for file creation and editing. Use `run_command` with `RunPersistent` for stateful operations. See adapters/ANTIGRAVITY.md for details.
       ```

    2. Find the commit section. ADD after it:
       ```markdown
       > **Antigravity:** Use `run_command` with `SafeToAutoRun: false` for git commits to ensure user approval on each atomic commit.
       ```

    3. At the bottom, in the Related section, ADD to the workflows table:
       | `adapters/ANTIGRAVITY.md` | Antigravity-specific tool guidance |

    Keep changes minimal and additive. Do NOT restructure or rewrite existing content.
  </action>
  <verify>grep -c "Antigravity" .agent/workflows/execute.md</verify>
  <done>execute.md mentions Antigravity at least 3 times and references the adapter. All existing content preserved.</done>
</task>

## Success Criteria
- [ ] verify.md has browser_subagent guidance in verification methods
- [ ] execute.md has Antigravity tool references for file ops and commits
- [ ] Both files reference adapters/ANTIGRAVITY.md
- [ ] No existing content removed — all changes are additive
