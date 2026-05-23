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

