# Phase 1.1: Hierarchical Subphase Folder Architecture - SPEC.md

> **Status**: `FINALIZED`

## Goal
Implement the hierarchical subphase folder naming convention `.quantis/phases/{N}.{M}-{slug}/` (e.g., `.quantis/phases/1.1-hierarchical-folders/`) and integrate it across all Quantis skills and workflows.

## Deliverables
1. **Core Skills Migration:**
   - Update `writing-plans/SKILL.md` to:
     - Target `.quantis/phases/{N}.{M}-{slug}/{N}.{M}-PLAN.md`
     - Enforce the numbered H1 plan header convention: `# Phase {N}.{M}: {Description} - Implementation Plan`
   - Update `brainstorming/SKILL.md` to:
     - Target `.quantis/phases/{N}.{M}-{slug}/SPEC.md`
   - Update `using-quantis/SKILL.md` and reference guides (such as `antigravity-tools.md`) to reflect the new paths.
   - Update `subagent-driven-development/SKILL.md` and `requesting-code-review/SKILL.md` to dynamically resolve/reference active plan files inside the new layout.

2. **Workflow Files Migration:**
   - Update `.agent/workflows/plan.md` to:
     - Parse `{N}.{M}` as phase numbers
     - Resolve the descriptive slug from `ROADMAP.md`
     - Dynamically construct `.quantis/phases/{N}.{M}-{slug}/` directories
     - Output plan files under the new format
   - Update `.agent/workflows/execute.md` and `verify.md` to:
     - Resolve active directories by looking up glob prefixes `*` under `.quantis/phases/` (e.g. `$PHASE-*` or similar, such as matching `1.1` to `.quantis/phases/1.1-hierarchical-folders`)
     - Read plans from and write verification logs (`VERIFICATION.md` and `SUMMARY.md` files) to this resolved folder.
   - Update `/debug.md`, `/research-phase.md`, `/remove-phase.md`, `/insert-phase.md`, `/complete-milestone.md`, `/update-plan.md` to support dynamic prefix-based directory resolution instead of hardcoded `{N}` directory assumptions.

3. **Verification and Dogfooding:**
   - End-to-end dry-run of `/plan`, `/execute`, and `/verify` workflows to ensure they interact flawlessly with our new folder-level structure.

## Success Criteria
- [ ] Spec, plans, and verification logs for Phase 1.1 successfully exist and are managed inside `.quantis/phases/1.1-hierarchical-folders/`.
- [ ] Zero files in the repository contain hardcoded `.quantis/phases/{N}/` assumptions for active workflows.
- [ ] Prefix lookup logic handles missing trailing slashes, partial matches, and dynamic resolution correctly.
