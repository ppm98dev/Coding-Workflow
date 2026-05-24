# Quantis State

## Current Position
- **Milestone**: v3.2 — Custom Skill & MCP Dynamic Integration (COMPLETE ✅)
- **Phase**: None — Milestone complete and archived; Codebase audited and cleaned
- **Status**: Paused at 2026-05-24T16:50:00+02:00

## Last Session Summary
Conducted a thorough audit, repair, and cleanup session of the Quantis repository following the `d38bb5e` promotion commit (which promoted `quantis-new/` and inadvertently caused regressions/deletions). Accomplished the following:

- **Workflow & Version Alignment**: Fixed `/install`, `/update`, and `/upgrade` workflows to copy the restored `scripts/` directory, bumped the framework `VERSION` from `3.0.0` to `3.2.0`, updated `MANIFEST.md` header to `v3.2`, and corrected the scripts count in `ARCHITECTURE.md`.
- **Ecosystem Discovery & Docs**: Updated `README.md` to document the new dynamic ecosystem discovery (v3.2 feature), the restored `scripts/` directory, and added a complete 30-command listing of all workflows categorized clearly.
- **Subagent Adapter Alignment**: Replaced deprecated/incorrect Claude `Task()` references with Antigravity 2.0 `invoke_subagent` across 8 prompt templates and skills. Added full documentation of Antigravity's real subagent APIs (`invoke_subagent`, `define_subagent`, `manage_subagents`, `send_message`) and the missing evidence pattern inside `adapters/ANTIGRAVITY.md`.
- **Platform Agnosticism**: Replaced Claude-specific terminology with agent/platform-agnostic terms across core skills (`writing-skills`, `brainstorming`, `systematic-debugging`) while intentionally keeping the official upstream files (`anthropic-best-practices.md`, `CLAUDE_MD_TESTING.md`, `testing-skills-with-subagents.md`) intact as reference.
- **History & Structure Restoration**: Restored 132 lines of v1.0→v2.0 changelog history in `CHANGELOG.md` that were lost during promotion, added entries for v3.1 & v3.2, and added `scripts/` back to the repository file structure in `PROJECT_RULES.md`.

## In-Progress Work
- Files modified: None (working tree is clean)
- Tests status: Not run (all documentation and configuration-level fixes, verified manually)

## Blockers
None.

## Context Dump

### Decisions Made
- **Subagent API Maintenance**: Retained the subagent APIs (`invoke_subagent`, `define_subagent`, etc.) in `adapters/ANTIGRAVITY.md` and restored them as they are real and supported in Antigravity 2.0.
- **Upstream Docs Untouched**: Intentionally left `anthropic-best-practices.md`, `CLAUDE_MD_TESTING.md`, and `testing-skills-with-subagents.md` as they are, to keep them as useful upstream reference material rather than sanitizing them artificially.
- **Full README Command List**: Replaced the truncated command table in the `README.md` with a clean, fully-mapped 30-command list divided by category for clarity.

### Approaches Tried
- **Manual Manifest Audit**: Scanned all files in the repo and verified them against `MANIFEST.md` line by line to ensure absolute synchronization.
- **Commit History Diffing**: Inspected recent commit histories to locate deleted assets, ensuring no experimental files from the promotion commit left trailing stale references.

### Current Hypothesis
The repository is currently at a 100% clean, verified, and complete state, with all stale references from the migration resolved.

### Files of Interest
- `adapters/ANTIGRAVITY.md`: Documents the current Antigravity 2.0 subagent integration capability.
- `CHANGELOG.md`: Fully restored and up-to-date with v3.2 details.
- `README.md`: Updated ecosystem and workflow guide.
- `MANIFEST.md`: Serves as the installation blueprint.

## Next Steps
1. **Delete Stale Branch**: Remove the local/remote `dogfood/promote-quantis-new` branch, which has been fully merged and is no longer needed.
2. **Move/Recreate Tag**: Optionally recreate/move the `v3.2.0` tag to point to the latest main HEAD commit to include all the audit/cleanup fixes.
3. **Initiate Milestone v3.3**: Run `/new-milestone` to define and start the next set of features (e.g., multi-user support, SPEC.md scaling, etc.).
