# SPEC.md — Project Specification

> **Status**: `FINALIZED`

## Vision
Transform Quantis' phase directory layout from a simple, numeric folder structure (e.g. `.quantis/phases/3/`) into a highly descriptive, isolated hierarchical subphase structure (e.g. `.quantis/phases/3.1-skill-migration/`). Update all Quantis core skills and workflows to support this clean, self-documenting format.

## Goals
1. **Hierarchical Phase Folders** — Transition from `.quantis/phases/{N}/` to `.quantis/phases/{N}.{M}-{slug}/` for all phases.
2. **Automatic Directory Resolution** — Update workflows and skills to dynamically find the correct phase directory by checking for a prefix matching the phase number (e.g., matching `4.1` to `4.1-description`).
3. **Plan and Document Standard** — Update plan filenames and header definitions to use the new hierarchical number and descriptive title (e.g., `# Phase 4.1: [Description] - Implementation Plan`).
4. **Tool and Workflow Compatibility** — Ensure `/plan`, `/execute`, `/verify`, `/debug`, `/research-phase`, `/remove-phase`, `/insert-phase`, `/add-phase`, `/complete-milestone`, `/upgrade`, and `/update` all work flawlessly with the new folder structures.

## Non-Goals (Out of Scope)
- Migrating existing/historical `.quantis/phases/` folders from completed milestones (e.g. v2.0, v3.0) — these will remain in their archive format in `milestones/`.

## Success Criteria
- [ ] Running `/plan 1.1` successfully creates `.quantis/phases/1.1-hierarchical-folders/1.1-PLAN.md` with numbered H1 headers.
- [ ] `/execute 1.1` and `/verify 1.1` successfully resolve `1.1-hierarchical-folders` and read/write plan and verification results to it.
- [ ] All 10 workflow files that touch phase directories are updated to use dynamic glob-based resolution of phase paths.
- [ ] All 5 core skills (`using-quantis`, `writing-plans`, `brainstorming`, `subagent-driven-development`, `requesting-code-review`) are updated.
- [ ] The entire codebase is free of hardcoded `.quantis/phases/{N}/` assumptions for active work.
