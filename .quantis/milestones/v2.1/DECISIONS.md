# Decisions

> Previous milestone decisions archived in `.quantis/milestones/v2.0/DECISIONS.md`

---

## Phase 1 Decisions (Constitution & Spec Rigor)

**Date:** 2026-05-09
**Context:** Discussion before planning Phase 1. Studied Spec-Kit repo (cloned to `.quantis/references/spec-kit/`) for implementation patterns.

### D-001: Constitution Scope — Comprehensive
**Decision:** ~150 lines covering 10 articles: Code Quality, Error Handling, Logging, Input Validation, Testing Strategy, Security Defaults, Documentation, Performance, Dependency Policy, Architecture.
**Rationale:** The #1 gap is "it works" code vs production code. A comprehensive constitution is the enforcement mechanism.

### D-002: Clarification Markers — Both Inline + Summary
**Decision:** Use inline `[NEEDS CLARIFICATION: specific question]` markers in SPEC.md body AND an auto-generated "Unresolved Questions" summary section at the bottom.
**Rationale:** Inline markers keep ambiguity visible in context. Summary section gives a scannable overview. `/stress-test` auto-generates the summary from inline markers.

### D-003: Spec/Plan Separation — Strict (Additive)
**Decision:** SPEC = pure user intent, PLAN = technical choices. But existing Constraints section stays as-is — "MIT licensed", "macOS only" are legitimate project constraints, not tech implementation details.
**Rationale:** Studied Spec-Kit's spec template — their spec has zero tech details. Our existing constraints are business constraints, not tech choices. No restructuring needed, just add new sections.

### D-004: Stress-Test Mode — Adversarial
**Decision:** `/stress-test` adversarially argues with the spec: finds vague terms, probes failure modes, spots contradictions, challenges assumptions, surfaces edge cases.
**Rationale:** A checklist catches known gaps. Adversarial questioning catches unknown unknowns.

### D-005: Constitution Creation — Interactive Q&A in /new-project
**Decision:** Add constitution creation as a new phase in `/new-project` with interactive Q&A about code style, error handling, testing strategy, etc.
**Rationale:** Each project has different quality standards. Interactive creation ensures the constitution reflects actual project needs.

### D-006: Missing Constitution — Hard Fail
**Decision:** `/plan` hard-fails if CONSTITUTION.md doesn't exist.
**Rationale:** The constitution is the enforcement mechanism for production code quality. Without it, the entire v2.1 purpose is defeated.

### D-007: SPEC Template Changes — Additive Only
**Decision:** Add new sections (Quality Requirements, Unresolved Questions, Edge Cases, `[NEEDS CLARIFICATION]` instructions) without removing or restructuring existing sections.
**Rationale:** No breaking changes. Existing projects continue working.

### D-008: Constitution vs PROJECT_RULES — Separate Concerns
**Decision:** Constitution is project-specific (per-project, filled during `/new-project`). PROJECT_RULES.md and QUANTIS-STYLE.md stay as framework-level rules.
**Rationale:** PROJECT_RULES defines Quantis framework conventions. Constitution defines project-specific quality standards. Different scopes, no overlap.

### D-009: Constitution Articles — 10 Articles
**Decision:** Template includes 10 articles:
1. Code Quality Standards (naming, function length, separation of concerns)
2. Error Handling (strategy, patterns, logging on errors)
3. Logging & Observability (structured/plaintext, levels, what to log)
4. Input Validation (boundaries, schemas, sanitization)
5. Testing Strategy (unit/integration/e2e balance, coverage, test-first)
6. Security Defaults (no hardcoded secrets, parameterized queries, CORS)
7. Documentation (docstrings, README, API docs)
8. Performance (N+1, unbounded loops, memory)
9. Dependency Policy (approval, max deps, version pinning)
10. Architecture (separation of concerns, layers, dependency direction)

### D-010: Constitution Placement in /new-project — First Step
**Decision:** Constitution Q&A is the very first step in `/new-project`, before spec creation.
**Rationale:** Quality standards should be defined before writing requirements. The constitution informs how the spec is written.

### D-011: Stress-Test Trigger — Suggested, Not Forced
**Decision:** `/new-project` suggests running `/stress-test` after SPEC creation but doesn't force it. `/plan` hard-fails on unresolved `[NEEDS CLARIFICATION]` markers as the actual safety net.
**Rationale:** Two-layer protection — stress-test catches gaps proactively, plan-checker catches them mandatorily. Forcing stress-test on every project is heavy for simple projects.

---

## Phase 2 Decisions (Plan Iteration)

**Date:** 2026-05-10
**Context:** Discussion before planning Phase 2. Evaluated scope of `/update-plan` and `/checklist` workflows.

### D-012: Drop /checklist — Redundant
**Decision:** Remove `/checklist` from Phase 2 scope. The plan-checker already runs automatically inside `/plan` (step 7) and would also run inside `/update-plan`. A standalone `/checklist` command solves no real problem.
**Rationale:** The plan-checker is already integrated at every point where validation matters. Exposing it as a separate command adds surface area with no benefit.

### D-013: /update-plan — Conversational Revision
**Decision:** `/update-plan` is a conversational revision workflow: user discusses concerns naturally, then runs `/update-plan N` to apply the discussed changes and re-validate.
**Rationale:** The natural flow is: `/plan` generates → user reads and has doubts → discuss → `/update-plan` applies changes. This is simpler and more natural than a formal review-with-diff interface.

### D-014: /update-plan — Optional Step
**Decision:** `/update-plan` is explicitly optional. Users can go directly from `/plan` to `/execute` if satisfied with the generated plans.
**Rationale:** Most plans don't need revision. Adding a mandatory review step would slow down the workflow for the common case.

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

