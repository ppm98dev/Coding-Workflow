# Decisions

> Previous milestone decisions archived in `.quantis/milestones/v2.1/DECISIONS.md`

---




## v3.0 Strategic Decisions (Superpowers Migration)

**Date:** 2026-05-23
**Context:** Deep audit of [obra/superpowers](https://github.com/obra/superpowers) v5.1.0. Decision to fork Superpowers' code quality skills into Quantis and adapt for Antigravity 2.0. Closes v2.1 (phases 3-6 superseded by Superpowers adoption).

### D-015: Adopt Superpowers as Skill Foundation
**Decision:** Fork Superpowers' 13 skills into Quantis, replacing existing planner/executor/verifier/debugger skills. Keep Quantis workflow layer (pause/resume, roadmaps, milestones, state) on top.
**Rationale:** Superpowers' TDD, subagent-driven development, and two-stage code review are significantly better than Quantis equivalents. Building from scratch would take months; integrating takes days.

### D-016: Subagent Architecture — Antigravity 2.0 Native
**Decision:** Use Antigravity 2.0's `invoke_subagent` + `define_subagent` tools for SDD. Pre-define implementer, spec-reviewer, and code-quality-reviewer as named subagent types.
**Rationale:** Antigravity 2.0 shipped full subagent support with context isolation, parallel execution, and workspace isolation — exact match for Superpowers' SDD model.

### D-017: Skill Directory — Antigravity Native (.agents/skills/)
**Decision:** Convert all Superpowers skills to `.agents/skills/` directory structure (Antigravity's native skill loading system).
**Rationale:** Antigravity uses progressive disclosure (metadata scan → activation → execution). Native directory means zero-config discovery.

### D-018: Auto-Triggering — Superpowers Model
**Decision:** Keep auto-triggering behavior from Superpowers. Skills fire automatically when task matches description, with 1% threshold.
**Rationale:** Quality enforcement skills (TDD, verification, debugging) should fire without explicit invocation. Users still have slash commands for process workflows.

### D-019: File Locations — Quantis Phase Convention
**Decision:** Override Superpowers defaults. Specs → `.quantis/phases/{N}/SPEC.md`, plans → `.quantis/phases/{N}/PLAN.md`.
**Rationale:** User prefers phase-based organization. Superpowers explicitly supports custom locations ("User preferences override this default").

### D-020: State Integration — Auto-Update During Execution
**Decision:** SDD and executing-plans skills auto-update STATE.md (progress), JOURNAL.md (entries), and ROADMAP.md (task completion) after each task.
**Rationale:** Quantis' value is persistent state across sessions. Execution without state updates defeats the purpose.

### D-021: Quantis Workflows — Keep Process Management
**Decision:** Keep 18 workflows: pause, resume, progress, new-milestone, complete-milestone, audit-milestone, new-project, debug (wrapper), verify (wrapper), add/insert/remove-phase, add-todo, check-todos, help, whats-new, install, update.
**Rationale:** These provide project management capabilities Superpowers completely lacks.

### D-022: Replace Workflows — Superpowers Skills Take Over
**Decision:** Replace 6 workflows with Superpowers skills: /discuss-phase → brainstorming, /plan → writing-plans, /update-plan → writing-plans self-review, /execute → subagent-driven-development, /stress-test → brainstorming spec self-review, /research-phase → brainstorming explore step.
**Rationale:** Superpowers versions are more structured, have hard gates, anti-rationalization tables, and better quality output.

### D-023: Tool Mapping — Reference File
**Decision:** Create `antigravity-tools.md` reference file mapping Claude Code tool names to Antigravity equivalents. Skills keep original references; mapping file translates at runtime.
**Rationale:** Same pattern Superpowers uses for Gemini CLI. Maintains skill readability while supporting the platform.

### D-024: Naming — Keep Quantis Brand
**Decision:** Framework stays "Quantis". Bootstrap skill named `using-quantis`. State in `.quantis/`. README credits Superpowers.
**Rationale:** Quantis is the user-facing brand. Superpowers is the skill engine underneath.

---

## Phase 2 Decisions (Workflow Reconciliation)

**Date:** 2026-05-23
**Context:** Pre-planning discussion for Phase 2. Clarified scope around `.gemini/`, `adapters/`, and superseded workflow handling.

### D-025: Include .gemini/ + adapters/ in quantis-new as Thin Shims
**Decision:** Include `.gemini/GEMINI.md` and `adapters/` directory in quantis-new. Rewrite `.gemini/GEMINI.md` as a minimal bootstrap (~20 lines) pointing to the `using-quantis` skill. Slim down adapters to model-specific tips only (remove duplicate tool mapping — now in skills).
**Rationale:** `.gemini/GEMINI.md` is auto-loaded by Antigravity at session start (mandatory). Adapters keep model-specific guidance (Flash vs Pro, effort levels) that skills don't cover. No content duplication — skills own methodology, adapters own model quirks.

### D-026: Superseded Workflows → Thin Aliases (Not Deleted)
**Decision:** Keep `/plan`, `/execute`, `/discuss-phase`, `/stress-test`, `/research-phase`, `/update-plan` as 10-line alias workflows. Each reads and invokes the corresponding Superpowers skill (writing-plans, executing-plans, brainstorming). Slash commands still work AND natural language skill auto-trigger also works.
**Rationale:** Users have muscle memory for `/plan`, `/execute` etc. Deleting would break habit; aliases give best of both worlds. Tiny file size, no maintenance burden.

### D-027: Update using-quantis Bootstrap in Phase 2
**Decision:** Update `using-quantis/SKILL.md` workflow commands table during Phase 2 (not deferred to Phase 3).
**Rationale:** The bootstrap skill has a workflow commands table that users reference. It must stay accurate — showing stale commands undermines trust in the skill system.

### D-028: /map → Thin Alias for codebase-mapper Skill
**Decision:** Convert `/map` workflow to a thin alias that invokes the `codebase-mapper` skill (same pattern as D-026). 7 total alias workflows.
**Rationale:** The codebase-mapper skill already covers the same analysis work. `/map` adds the ARCHITECTURE.md + STACK.md output convention, which can be folded into the alias instructions.

### D-029: Include Root-Level Files in quantis-new
**Decision:** Include `PROJECT_RULES.md`, `CONSTITUTION.md`, `QUANTIS-STYLE.md`, and `model_capabilities.yaml` in the quantis-new distributable package. These are part of Phase 2 deliverables.
**Rationale:** These files define the methodology and are referenced by `.gemini/GEMINI.md`, adapters, and skills. Without them, an install is incomplete.

### D-030: Defer install.md + update.md to Phase 3
**Decision:** Do not update `install.md` and `update.md` workflows for v3.0 structure in Phase 2. Defer to Phase 3 (Integration Testing & Polish).
**Rationale:** Install/update workflows need end-to-end testing against the final package structure. Phase 3 is the right place for that validation.

### D-031: In-place upgrade via MANIFEST.md
**Decision:** Create a `MANIFEST.md` listing all core Quantis skills and workflows. The `/upgrade` workflow uses this to know what to replace vs keep during GSD→v3.0 migration.
**Rationale:** Users have projects with GSD + user-installed skills from the web. Upgrade must:
- Replace GSD core skills (planner, executor, verifier, etc.) with Superpowers skills
- Replace GSD workflows with v3.0 workflows
- Preserve user-installed skills (anything not in MANIFEST)
- Preserve `.quantis/` state (SPEC, ROADMAP, phases, STATE, CONSTITUTION, etc.)

---

## Phase 3 Decisions (Integration Testing & Polish)

**Date:** 2026-05-24
**Context:** Pre-planning discussion for Phase 3. Clarified scope, approach, and testing strategy.

### D-032: Update `/install` + `/update` to Quantis branding & correct repo
**Decision:** Sweep all "GSD" references in install.md and update.md. Update repo URL (currently `get-shit-done-for-antigravity`). Ensure `/update` becomes MANIFEST-aware (same pattern as `/upgrade`) so it doesn't overwrite user-installed skills.
**Rationale:** `/update` currently does blanket `cp -r .agents/*` which would clobber user skills. MANIFEST-aware update respects user customizations.

### D-033: `/upgrade` as standalone one-time migration workflow
**Decision:** Create a separate `/upgrade` workflow for GSD→v3.0 migration. Keep `/update` for v3.0→v3.x incremental updates. `/upgrade` is a one-time tool.
**Rationale:** Migration logic (renaming old skills, restructuring) is fundamentally different from incremental updates. Mixing them adds complexity for no future benefit.

### D-034: README — Full rewrite for v3.0
**Decision:** Rewrite README.md from scratch for v3.0 architecture. Cover Superpowers-powered skill system, skill categories, quick start, credits.
**Rationale:** The v2.x README (19KB) reflects a different architecture. A clean rewrite is faster and more accurate than patching.

### D-035: Include `CONSTITUTION.md` in install, remove `scripts/` reference
**Decision:** Add `CONSTITUTION.md` to install workflow. Remove `scripts/` from install (doesn't exist in v3.0). Ensure `docs/` content is current.
**Rationale:** CONSTITUTION.md is referenced by .gemini/GEMINI.md and skills. scripts/ doesn't exist in quantis-new — referencing it causes install errors.

### D-036: Systematic GSD reference sweep
**Decision:** Do a grep-based sweep of all files in quantis-new/ for stale "GSD", "get-shit-done", "Get Shit Done" references. Replace with Quantis branding throughout.
**Rationale:** Leftover GSD references in banners, messages, and comments undermine the Quantis brand consistency.

### D-037: No separate test suite — verify during execution
**Decision:** Delete `tests/` (Claude Code test harnesses, incompatible with Antigravity). No persistent test script. Verification happens inline during Phase 3 execution (GSD sweep, cross-reference checks, install file list validation). Real-world testing = using Quantis v3.0 on the next project.
**Rationale:** Quantis is markdown instruction files, not executable code. The Superpowers tests used `claude -p --plugin-dir` (Claude Code CLI) which doesn't exist in Antigravity. A persistent test script adds maintenance overhead with no CI/CD to run it.
