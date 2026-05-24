# Quantis State

## Current Position
- **Milestone**: v3.2 — Custom Skill & MCP Dynamic Integration (COMPLETE ✅)
- **Phase**: Remote Bootstrap Upgrade & Installer Cleanup (COMPLETE ✅)
- **Status**: Completed and paused at 2026-05-24T20:32:00+02:00

## Last Session Summary
Designed, implemented, validated, and deployed a remote-bootstrap upgrading mechanism alongside strict target-workspace hygiene rules to prevent framework-specific file clutter:

- **Remote Upgrade Bootstrap**: Created `scripts/upgrade.sh` allowing users to upgrade any old GSD v2.x repository to Quantis remotely via `curl -fsSL https://raw.githubusercontent.com/ppm98dev/Coding-Workflow/main/scripts/upgrade.sh | bash`. The script automatically handles `.gsd` to `.quantis` renaming, clean-up of the 7 old GSD core skills, re-routing of path references, and copying of standard files without overwriting user files.
- **Client Workspace Hygiene**: Solved critical workspace pollution bugs in both installers (`install.sh`, `upgrade.sh`) and all three related agent workflows (`/install`, `/update`, `/upgrade`). Excluded internal framework files (`README.md`, `CHANGELOG.md`, `MANIFEST.md`, OpenCode integration guides, and Windows polyglot scripts) from being copied into client repos.
- **Client-Facing Asset Preservation**: Preserved the copy operations of the required `adapters/` directory. Implemented selective copying for `docs/` and `scripts/` (copying only core playbooks and validation/search utility scripts) to perfectly mirror GSD's exact file layout while preventing any directory clutter.
- **Validation**: Executed the master validation suite, passing all 30 workflows, 18 skills, and 25 templates with zero errors, and successfully pushed all changes to `ppm98dev/Coding-Workflow` on GitHub.

## In-Progress Work
- Files modified: None (working tree is clean and fully pushed)
- Tests status: All validators passed cleanly (0 errors)

## Blockers
None.

## Context Dump

### Decisions Made
- **Zero README Copying**: Decided to completely exclude the framework's main `README.md` from being copied or updated, ensuring client-specific README files are never polluted or deleted.
- **Selective docs/scripts Copying**: Copied only necessary, user-facing documentation guides and local validation/search scripts, preventing internal developer documents from bloating client workspaces.
- **Immediate Push**: Pushed the changes directly to GitHub so that the curl one-liner is instantly functional for the user.

### Next Steps
1. **Remove Old Temp Folders in VM**: Clean up VM workspace by deleting any left-over `.quantis-install-temp` folders.
2. **Upgrade GSD Repos**: Run the newly published remote upgrade command on GSD v2.x projects.
